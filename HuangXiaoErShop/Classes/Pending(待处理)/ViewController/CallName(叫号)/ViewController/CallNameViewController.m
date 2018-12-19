//
//  CallNameViewController.m
//  HXEshop
//
//  Created by apple on 2018/3/8.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "CallNameViewController.h"
#import "CellModel.h"
#import "JiaoHaoTableViewCell.h"

static NSString * const jiaohaoCell = @"jiaohaoTableViewCell";

@interface CallNameViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *jiaohaoTableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger thePage;

@end


@implementation CallNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  //  self.view.backgroundColor = kColor(245, 245, 245);
    
    CGFloat commen = kNav_H + kTabbar_H;
    if (iPhoneX) {
        self.jiaohaoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -40, kScreenWidth, kScreenHeight - commen - 70) style:(UITableViewStyleGrouped)];
    }else{
        
        self.jiaohaoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -40, kScreenWidth, kScreenHeight  -  64 - 49) style:(UITableViewStyleGrouped)];
    }
    
 //   _jiaohaoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -45, kScreenWidth, kScreenHeight - 110) style:UITableViewStyleGrouped];
    [_jiaohaoTableView registerClass:[JiaoHaoTableViewCell class] forCellReuseIdentifier:jiaohaoCell];
    _jiaohaoTableView.delaysContentTouches = YES;
    _jiaohaoTableView.tableHeaderView = [[UIView alloc]init];
    _jiaohaoTableView.tableFooterView =  [[UIView alloc]init];
    _jiaohaoTableView.delegate = self;
    _jiaohaoTableView.dataSource = self;
    [self.view addSubview:_jiaohaoTableView];
    
    [self setRefresh];
    // Do any additional setup after loading the view.
}

- (void)setRefresh {
    _thePage = 1;
    __block typeof(self)weakself = self;
    self.jiaohaoTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.jiaohaoTableView.mj_footer resetNoMoreData];
        weakself.thePage = 1;
        [self requestData];
    }];
    
    self.jiaohaoTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.thePage += 1;
        [self requestData];
    }];
    [self.jiaohaoTableView.mj_header beginRefreshing];
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}

- (void)requestData{
    NSDate *date =[NSDate date];
    NSString *currentTime = [[NSString stringWithFormat:@"%@", date]substringWithRange:NSMakeRange(0, 10)];
    NSString *string = @" 00:00:00";
    NSString *createTime = [NSString stringWithFormat:@"%@""%@",currentTime,string];
    
    NSDictionary *partner = @{
                              @"createTime":createTime,
                              @"token":KUSERID,
                              @"isPay":@"2",
                              @"orderStatus":@"0",
                              @"page":@(_thePage),
                              @"size":@"20",
                              };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html", nil];
    
    [manager POST:[NSString stringWithFormat:@"%@/appordersr/findOrdersByDate",HXEORDER] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //   NSLog(@"findallall---%@",responseObject);
        if ([responseObject[@"status"] integerValue] == 200){
            if (_thePage == 1) {
                [self.dataArray removeAllObjects];
            }
            NSDictionary *dataDic = responseObject[@"data"];
            NSArray *arr = dataDic[@"rows"];
            
            for (NSDictionary *xd in arr) {
                CellModel *model = [CellModel new];
                [model setValuesForKeysWithDictionary:xd];
                [self.dataArray addObject:model];
            }
            if (_thePage == 1) {
                [self.jiaohaoTableView.mj_header endRefreshing];
            }else{
                if (arr.count == 0) {
                    [self.jiaohaoTableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [self.jiaohaoTableView.mj_footer endRefreshing];
                }
            }
            [self.jiaohaoTableView reloadData];
        }else if ([responseObject[@"status"] integerValue] == 301){
            [self.jiaohaoTableView.mj_header endRefreshing];
            [[AppDelegate mainAppDelegate] showLoginView];
        }else {
            [self.jiaohaoTableView.mj_header endRefreshing];
            [MBProgressHUD showMessage:responseObject[@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.jiaohaoTableView.mj_header endRefreshing];
        
    }];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JiaoHaoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:jiaohaoCell forIndexPath:indexPath];
    CellModel *model = self.dataArray[indexPath.section];
    
   // if ([model.orderStatus integerValue] == 4 || [model.orderStatus integerValue] == 2) {
        [cell cellGetDataWithModel:model];
        
  //  }
    return cell;
}


- (void)jiaohaoWithUserID: (NSString *)userID OrderNum: (NSString *)orderNum{
    
    NSDictionary *partner = @{
                              @"id": userID,
                              @"orderNum": orderNum,
                              @"token": KUSERID
                              };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html", nil];
    
    [manager POST:[NSString stringWithFormat:@"%@/appordersr/orderremind",HXEORDER] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
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

