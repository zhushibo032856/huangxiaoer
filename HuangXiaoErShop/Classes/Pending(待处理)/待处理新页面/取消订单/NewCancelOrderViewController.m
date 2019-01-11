//
//  NewCancelOrderViewController.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/12/14.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "NewCancelOrderViewController.h"
#import "CellModel.h"
#import "NewLayoutModel.h"
#import "NewCancelTableViewCell.h"

static NSString * const CancelCell = @"NewCancelTableViewCell";
static NSString * const NoneCell = @"NoneDataCell";

@interface NewCancelOrderViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *layoutArr;
@property (nonatomic, assign) NSInteger thePage;

@end

@implementation NewCancelOrderViewController

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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, kScreenHeight - 86 - 59 - 44 - 30) style:UITableViewStyleGrouped];
    }else{
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, kScreenHeight - 64 - 49 - 44) style:UITableViewStyleGrouped];
    }
    _tableView.backgroundColor = kColor(240, 240, 240);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = NO;
    [_tableView registerNib:[UINib nibWithNibName:@"NewCancelTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CancelCell];
    [_tableView registerClass:[NoneDataTableViewCell class] forCellReuseIdentifier:NoneCell];
    [self.view addSubview:_tableView];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (kArrayIsEmpty(self.dataSource)) {
        return self.tableView.height;
    }
    NewLayoutModel *model = _layoutArr[indexPath.section];
    return model.cellHei;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [UIView new];
    return view;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (kArrayIsEmpty(self.dataSource)) {
        return 1;
    }
    return _dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (kArrayIsEmpty(self.dataSource)) {
        NoneDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NoneCell forIndexPath:indexPath];
        [cell showNoDataWithImgurl:@"remind-5" andTipString:@"暂无取消订单"];
        return cell;
    }
    NewCancelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CancelCell forIndexPath:indexPath];
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
                              @"isPay":@"3",
                              @"orderStatus":@"5",
                              @"page":@(_thePage),
                              @"size":@"20",
                              };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html", nil];
    
    [manager POST:[NSString stringWithFormat:@"%@/appordersr/findOrdersByDate",HXEORDER] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      //  NSLog(@"findallall---%@",responseObject);
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
                
                NewLayoutModel *layoutModel = [NewLayoutModel new];
                [layoutModel getCellHitghtWithCellModel:model];
                [self.layoutArr addObject:layoutModel];
                
            }
            if (self->_thePage == 1) {
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
