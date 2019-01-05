//
//  MemberCenterViewController.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/12/25.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "MemberCenterViewController.h"
#import "MemberTableViewCell.h"
#import "SumTableViewCell.h"
#import "MemberModel.h"

@interface MemberCenterViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) UITableView *sumTableView;

@property (nonatomic, assign) NSInteger thePage;

@end

static NSString * const CELL = @"MemberTableViewCell";
static NSString * const sumCell = @"SumTableViewCell";
static NSString * const noneCell = @"NoneDataCell";

@implementation MemberCenterViewController

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArr;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    leftBtn.frame = CGRectMake(0, 0, 30, 30);;
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"itemBack"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBarBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    [self setNavigationController];
    
}
- (void)setNavigationController{
    
    self.navigationItem.title = @"会员管理";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21],NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
    
}
- (void)leftBarBtnClicked:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor(240, 240, 240);
    
    [self initView];
    
    [self setRefresh];
    // Do any additional setup after loading the view.
}

- (void)setRefresh{
    _thePage = 1;
    __block typeof(self) weakself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.tableView.mj_footer resetNoMoreData];
        weakself.thePage = 1;
        [self getDataFromNetWork];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.thePage += 1;
       [self getDataFromNetWork];
        [self.tableView.mj_footer endRefreshing];
    }];
    // 进入界面时刷新
    [self.tableView.mj_header beginRefreshing];
    [self.tableView reloadData];
    
    
}

- (void)initView{
    
    _sumTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 15, kScreenWidth, 70) style:UITableViewStyleGrouped];
    _sumTableView.delegate = self;
    _sumTableView.dataSource = self;
    _sumTableView.separatorStyle = NO;
    _sumTableView.scrollEnabled = NO;
    _sumTableView.backgroundColor = kColor(240, 240, 240);
    [_sumTableView registerClass:[SumTableViewCell class] forCellReuseIdentifier:sumCell];
    [self.view addSubview:_sumTableView];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(15, 80, kScreenWidth - 30, kScreenHeight - kNavHeight - 80) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = NO;
    _tableView.backgroundColor = kColor(240, 240, 240);
    [_tableView registerNib:[UINib nibWithNibName:@"MemberTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CELL];
    [_tableView registerClass:[NoneDataTableViewCell class] forCellReuseIdentifier:noneCell];
    [self.view addSubview:_tableView];
    
}

- (void)getDataFromNetWork{
    
    NSDictionary *partner = @{
                              @"id": KUSERSHOPID,
                              @"page": @(_thePage),
                              @"size": @20,
                              @"token": KUSERID
                              };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    
    [manager POST:@"http://51hxe.com:9002/appcommercial/findMemberListData" parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      //  NSLog(@"%@",responseObject);
        NSDictionary *data = responseObject[@"data"];
        if ([responseObject[@"status"] integerValue] == 200) {
            NSArray *arr = data[@"rows"];
            if (_thePage == 1) {
                [self.dataArr removeAllObjects];
            }
            
            for (NSDictionary *dic in arr) {
                MemberModel *model = [MemberModel new];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArr addObject:model];
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
            [self.sumTableView reloadData];
        }else{
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView == _sumTableView) {
        return 15;
    }
    return 15;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [UIView new];
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _sumTableView) {
        return 1;
    }
    if (kArrayIsEmpty(self.dataArr)) {
        return 1;
    }
    return _dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _sumTableView) {
        
        return 50;
    }
    if (kArrayIsEmpty(self.dataArr)) {
        return 500;
    }
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _sumTableView) {
        MemberModel *model = self.dataArr.firstObject;
        SumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sumCell forIndexPath:indexPath];
        [cell setdataForCellWith:model];
        return cell;
    }
    if (kArrayIsEmpty(self.dataArr)) {
        NoneDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:noneCell forIndexPath:indexPath];
        [cell showNoDataWithImgurl:@"remind-2" andTipString:@"还没有新会员哦"];
        return cell;
    }
    MemberModel *model = self.dataArr[indexPath.section];
    MemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL forIndexPath:indexPath];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 10;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setDataForCellWith:model];
    cell.NumberLable.text = [NSString stringWithFormat:@"%ld",indexPath.section + 1];
    [cell.NumberLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
    return cell;
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
