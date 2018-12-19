//
//  NewRefundViewController.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/12/14.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "NewRefundViewController.h"
#import "CellModel.h"
#import "NewRefundModel.h"
#import "NewRefundTableViewCell.h"

static NSString * const RefundCell = @"NewRefundTableViewCell";

@interface NewRefundViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *layoutArr;
@property (nonatomic, assign) NSInteger thePage;

@end

@implementation NewRefundViewController
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}


- (NSMutableArray *)layoutArr {
    if (!_layoutArr) {
        self.layoutArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _layoutArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColor(240, 240, 240);
    
    [self creatTableView];
    [self setRefresh];
    // Do any additional setup after loading the view.
}
- (void)setRefresh {
    _thePage = 1;
    __block typeof(self)weakself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.tableView.mj_footer resetNoMoreData];
        weakself.thePage = 1;
        [self getdata];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.thePage += 1;
        [self getdata];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)creatTableView{
    
    if (iPhoneX) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, kScreenHeight - 64 - kNavHeight - 44) style:UITableViewStyleGrouped];
    }else{
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, kScreenHeight - 64 - kNavHeight - 44) style:UITableViewStyleGrouped];
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"NewRefundTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:RefundCell];
    [self.view addSubview:_tableView];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000001;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [UIView new];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewRefundModel *model = _layoutArr[indexPath.section];
    return model.cellHei;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewRefundTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RefundCell forIndexPath:indexPath];
    CellModel *model = self.dataSource[indexPath.section];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 10;
    [cell cellViewsValueWithModel:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)getdata{
    
    NSDate *date =[NSDate date];
    NSString *currentTime = [[NSString stringWithFormat:@"%@", date]substringWithRange:NSMakeRange(0, 10)];
    NSString *string = @" 00:00:00";
    NSString *createTime = [NSString stringWithFormat:@"%@""%@",currentTime,string];
    
    NSDictionary *partner = @{
                              @"createTime":createTime,
                              @"token":KUSERID,
                              @"isPay":@"4",
                              @"orderStatus":@"8",
                              @"page":@(_thePage),
                              @"size":@"20",
                              };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html", nil];
    
    [manager POST:[NSString stringWithFormat:@"%@/appordersr/findOrdersByDate",HXEORDER] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
   //     NSLog(@"findallall---%@",responseObject);
        if ([responseObject[@"status"] integerValue] == 200){
            if (_thePage == 1) {
                [self.dataSource removeAllObjects];
                [self.layoutArr removeAllObjects];
            }
            NSDictionary *dataDic = responseObject[@"data"];
            NSArray *arr = dataDic[@"rows"];
            for (NSDictionary *xd in arr) {
                CellModel *model = [CellModel new];
                [model setValuesForKeysWithDictionary:xd];
                [self.dataSource addObject:model];
                
                NewRefundModel *layoutModel = [NewRefundModel new];
                [layoutModel getCellHitghtWithCellModel:model];
                [self.layoutArr addObject:layoutModel];
                
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
        }else if ([responseObject[@"status"] integerValue] == 301){
            [self.tableView.mj_header endRefreshing];
            [[AppDelegate mainAppDelegate] showLoginView];
        }else {
            [self.tableView.mj_header endRefreshing];
            [MBProgressHUD showMessage:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.tableView.mj_header endRefreshing];
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
