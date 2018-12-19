//
//  MessageFourViewController.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/12/4.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "MessageFourViewController.h"
#import "MessageDetailViewController.h"
#import "MessageOneTableViewCell.h"

@interface MessageFourViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger thePage;

@end

static NSString * const messageOne = @"MessageOneTableViewCell";

@implementation MessageFourViewController
- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    leftBtn.frame = CGRectMake(0, 0, 30, 30);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"itemBack"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBarBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    [self setNavigationController];
    
}
- (void)setNavigationController{
    
    //  self.navigationItem.title = @"消息中心";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
    
}
- (void)leftBarBtnClicked:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor(230, 230, 230);
    
    [self initTableView];
    
    [self setRefreshWith:@"0"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(send:) name:@"PostSelectIndex" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readAlreadyToUnread) name:@"ReadAlreadyToUnread" object:nil];
}
- (void)readAlreadyToUnread{
    [self setRefreshWith:@"0"];
}

- (void)send:(NSNotification *)dataDic{
    
    [self.dataArray removeAllObjects];
    //   [self getDataFromNetWithStatus:dataDic.userInfo[@"PostIndex"]];
    [self setRefreshWith:dataDic.userInfo[@"PostIndex"]];
}

- (void)setRefreshWith:(NSString *)status{
    _thePage = 1;
    __block typeof(self) weakself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.tableView.mj_footer resetNoMoreData];
        weakself.thePage = 1;
        [self getDataFromNetWithStatus:status];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.thePage += 1;
        [self getDataFromNetWithStatus:status];
        [self.tableView.mj_footer endRefreshing];
    }];
    // 进入界面时刷新
    [self.tableView.mj_header beginRefreshing];
    [self.tableView reloadData];
}


- (void)initTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavHeight - 50) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = NO;
    [_tableView registerClass:[MessageOneTableViewCell class] forCellReuseIdentifier:messageOne];
    
    [self.view addSubview:_tableView];
    
}

- (void)getDataFromNetWithStatus:(NSString *)status{
    
    NSDictionary *partner = @{
                              @"commercialId": KUSERSHOPID,
                              @"page": @(_thePage),
                              @"size": @(20),
                              @"status": status,
                              @"token": KUSERID,
                              @"type": @"SYSMSG"
                              };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html", nil];
    
    [manager POST:[NSString stringWithFormat:@"%@/webMessage/findCommercialMsgList",HXECOMMEN] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //  NSLog(@"%@",responseObject);
        NSDictionary *data = responseObject[@"data"];
        if ([responseObject[@"status"] integerValue] == 200) {
            if (_thePage == 1) {
                [self.dataArray removeAllObjects];
            }
            NSArray *arr = data[@"rows"];
            for (NSDictionary *dic in arr) {
                MessageModel *model = [[MessageModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
            }
            if (_thePage == 1) {
                [self.tableView.mj_header endRefreshing];
            }else{
                if (arr.count == 0) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [self.tableView.mj_footer endRefreshing];
                }
            }
            [self.tableView reloadData];
        }else{
            [self.tableView.mj_header endRefreshing];
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
        
        //   NSLog(@"%ld",_dataArray.count);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
    }];
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MessageModel *model = _dataArray[indexPath.section];
    
    MessageOneTableViewCell *cellOne = [tableView dequeueReusableCellWithIdentifier:messageOne forIndexPath:indexPath];
    
    cellOne.layer.masksToBounds = YES;
    cellOne.layer.cornerRadius = 10;
    [cellOne setDataForCellWith:model];
    
    return cellOne;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageModel *model = _dataArray[indexPath.section];
    MessageDetailViewController * detailVC = [[MessageDetailViewController alloc]init];
    detailVC.hidesBottomBarWhenPushed = YES;
    detailVC.model = model;
    [self.navigationController pushViewController:detailVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
