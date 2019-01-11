//
//  NewneworderViewController.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/12/14.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "NewneworderViewController.h"
#import "ManagerModel.h"
#import "NewOrderTableViewCell.h"
#import "NewAppointTableViewCell.h"

#import "CellModel.h"
#import "OrderLayoutModel.h"

#import "ConnecterManager.h"
#import "PostOrderModel.h"

@interface NewneworderViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UISwitch *AutoSwitch;
@property (nonatomic, assign) NSInteger isAuto;
@property (nonatomic, strong) NSMutableArray *dataArray;//主页数据

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;//数据源
@property (nonatomic, strong) NSMutableArray *layoutArr;//订单菜品数据
@property (nonatomic, assign) NSInteger thePage;
@property (nonatomic, assign) NSInteger index;

@end

static NSString * const newOrderCell = @"NewOrderTableViewCell";
static NSString * const newAppointCell = @"NewAppointTableViewCell";
static NSString * const noneCell = @"noneCell";

@implementation NewneworderViewController

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

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor(240, 240, 240);
    
  //  [self jieDanZhuangTai];
    [self creatAutoJieDanView];
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
        [self jieDanZhuangTai];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.thePage += 1;
        [self getdata];
    }];
    [self.tableView.mj_header beginRefreshing];
    
}
#pragma mark 自动接单操作
- (void)creatAutoJieDanView{
    
    UIView *autoJDView = [UIView new];
    autoJDView.frame = CGRectMake(0, 0, kScreenWidth, 40);
    autoJDView.backgroundColor = [UIColor whiteColor];
    
    UILabel *autoLb = [[UILabel alloc] initWithFrame:(CGRectMake(20, 5, 80, 30))];
    autoLb.font = [UIFont systemFontOfSize:15];
    [autoJDView addSubview:autoLb];
    autoLb.text = @"自动接单";
    self.AutoSwitch = [[UISwitch alloc] initWithFrame:(CGRectMake(kScreenWidth - 70, 0, 60, 30))];
    
    [self.AutoSwitch setOn:YES animated:YES];
    _AutoSwitch.centerY = autoJDView.centerY;
    
    [self.AutoSwitch addTarget:self action:@selector(changeAutoJiedan) forControlEvents:UIControlEventTouchUpInside];
    [autoJDView addSubview:_AutoSwitch];
    [self.view addSubview:autoJDView];
}

- (void)jieDanZhuangTai{
    
    NSDictionary *partner = @{
                              @"token":KUSERID
                              };
    NSLog(@"%@",partner);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html", nil];
    [manager POST:[NSString stringWithFormat:@"%@/appcommercial/findbytoken",HXECOMMEN] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //    NSLog(@"%@",responseObject);
        if ([responseObject[@"status"] integerValue] == 200) {
            NSDictionary *dataDic = responseObject[@"data"];
            ManagerModel *model = [[ManagerModel alloc]init];
            [model setValuesForKeysWithDictionary:dataDic];
            [self.dataArray addObject:model];
            
            _isAuto = model.isAuto;
            if (model.isAuto == 1) {
                [self.AutoSwitch setOn:YES animated:YES];
            }else if (model.isAuto == 2){
                [self.AutoSwitch setOn:NO animated:YES];
            }
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

- (void)changeAutoJiedan{
    
    if (_isAuto == 1) {
        [self closedAutoJiedanWithIsAuto:2];
    }else if (_isAuto == 2){
        [self closedAutoJiedanWithIsAuto:1];
    }
    
}

- (void)closedAutoJiedanWithIsAuto:(NSInteger )isAuto{
    
    NSDictionary *partner = @{
                              @"token":KUSERID,
                              @"isAuto": @(isAuto)
                              };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html", nil];
    
    [manager POST:[NSString stringWithFormat:@"%@/appcommercial/update",HXECOMMEN] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //   NSLog(@"%@",responseObject);
        if ([responseObject[@"status"] integerValue] == 200) {
            
            [MBProgressHUD showSuccess:responseObject[@"msg"]];
            
        }else{
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];
    
}

#pragma mark 新订单处理
- (void)creatTableView{
    
    if (iPhoneX) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 40, kScreenWidth - 20, kScreenHeight - 86 - 59 - 44 - 70) style:UITableViewStyleGrouped];
    }else{
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 40, kScreenWidth - 20, kScreenHeight - 49 - 64 - 44 - 40) style:UITableViewStyleGrouped];
    }
    _tableView.backgroundColor = kColor(240, 240, 240);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = NO;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 170;
    [_tableView registerNib:[UINib nibWithNibName:@"NewOrderTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:newOrderCell];
    [_tableView registerNib:[UINib nibWithNibName:@"NewAppointTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:newAppointCell];
    [_tableView registerClass:[NoneDataTableViewCell class] forCellReuseIdentifier:noneCell];
    [self.view addSubview:_tableView];
    
}

- (void)getdata{
    
    NSDate *date =[NSDate date];
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone]; // 获得系统的时区
    NSTimeInterval time = [zone secondsFromGMTForDate:date];// 以秒为单位返回当前时间与系统格林尼治时间的差
    NSDate *dateNow = [date dateByAddingTimeInterval:time];// 然后把差的时间加上,就是当前系统准确的时间
    
    NSString *string = @" 00:00:00";
    
    NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:dateNow];
    NSString *lastTime = [format stringFromDate:lastDay];
    NSString *startTime = [NSString stringWithFormat:@"%@%@",lastTime,string];

    NSDate *nextDay = [NSDate dateWithTimeInterval:24*60*60 sinceDate:dateNow];//后一天
    NSString *nextTime = [format stringFromDate:nextDay];
    NSString *endTime = [NSString stringWithFormat:@"%@%@",nextTime,string];
    
    NSDictionary *partner = @{
                              @"endTime": endTime,
                              @"startTime": startTime,
                              @"token": KUSERID,
                              @"page":@(_thePage),
                              @"size":@"20",
                              };
    
  //  NSLog(@"%@",partner);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html", nil];
    
    [manager POST:[NSString stringWithFormat:@"%@/appordersr/findOrdersByStatus",HXEORDER] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //    NSLog(@"findallall---%@",responseObject);
        
        if ([responseObject[@"status"] integerValue] == 200){
            if (_thePage == 1) {
                [self.dataSource removeAllObjects];
                [self.layoutArr removeAllObjects];
            }
            NSDictionary *dataDic = responseObject[@"data"];
            NSArray *arr = dataDic[@"rows"];
            for (NSDictionary *dic in arr) {
                CellModel *model = [CellModel new];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataSource addObject:model];
                
                OrderLayoutModel *layoutModel = [OrderLayoutModel new];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (kArrayIsEmpty(self.dataSource)) {
        return 1;
    }
    return _dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (kArrayIsEmpty(self.dataSource)) {
        return self.tableView.height;
    }
    OrderLayoutModel *model = self.layoutArr[indexPath.section];
    return model.cellHei;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (kArrayIsEmpty(self.dataSource)) {
        NoneDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:noneCell forIndexPath:indexPath];
        [cell showNoDataWithImgurl:@"remind-5" andTipString:@"暂无新订单"];
        return cell;
    }
    
    
    CellModel *model = self.dataSource[indexPath.section];
    if ([model.orderType isEqualToString:@"APPOINTMENT"] ||[model.orderType isEqualToString:@"SECKILL"]) {
        
        NewAppointTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:newAppointCell forIndexPath:indexPath];
        cell.layer.masksToBounds = YES;
        cell.layer.cornerRadius = 10;
        
        cell.index = indexPath.section;
        self.index = indexPath.section;
        [cell cellViewsValueWithModel:model];
        __weak typeof(self)weakSelf = self;
        cell.block = ^(NSInteger index, NSInteger btnTag) {
            [weakSelf updatOrderStatusWithIndex:index BtnTag:btnTag];
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
        
    }else{
        NewOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:newOrderCell forIndexPath:indexPath];
        cell.layer.masksToBounds = YES;
        cell.layer.cornerRadius = 10;
        
        cell.index = indexPath.section;
        self.index = indexPath.section;
        [cell cellViewsValueWithModel:model];
        __weak typeof(self)weakSelf = self;
        cell.block = ^(NSInteger index, NSInteger btnTag) {
            [weakSelf updatOrderStatusWithIndex:index BtnTag:btnTag];
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}


- (void)updatOrderStatusWithIndex:(NSInteger)index
                           BtnTag:(NSInteger)btnTag
{
    CellModel *model = self.dataSource[index];
    NSString *status;
    if (btnTag == 100) {
     //   status = @"3";
        LSXAlertInputView * alert=[[LSXAlertInputView alloc]initWithTitle:@"拒单原因" PlaceholderText:@"请输入拒单原因" WithKeybordType:LSXKeyboardTypeDefault CompleteBlock:^(NSString *contents) {
        //    NSLog(@"-----%@",contents);
            if (kStringIsEmpty(contents)) {
                [MBProgressHUD showError:@"拒单原因不能为空"];
            }else{
                [self isJvDanWithOrderNumber:model.orderNum index:index JvDanReason:contents];
            }
        }];
        [alert show];

    } else if (btnTag == 200){
        status = @"2";
        [self isJieDanWithStastu:status orderNum:model.orderNum index:index];
    }else if (btnTag == 300){
        status = @"4";

        [self jiaohaoWithUserID:model.tb_customer_id OrderNum:model.orderNum index:index Stastu:status butTag:300];
    }else if (btnTag == 400){
        [self printOrderWithOrderNumber:model.orderNum];
        NSLog(@"dayin ");
    }
}
#pragma mark 叫号操作
- (void)jiaohaoWithUserID: (NSString *)userID
                 OrderNum: (NSString *)orderNum
                    index:(NSInteger)index
                   Stastu:(NSString *)status
                   butTag:(NSInteger)butTag
{
    
    NSDictionary *partner = @{
                              @"id": userID,
                              @"orderNum": orderNum,
                              @"token": KUSERID,
                              @"msg": @"您的饭做好啦",
                              };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html", nil];
    
    [manager POST:[NSString stringWithFormat:@"%@/appordersr/orderremind",HXEORDER] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           NSLog(@"%@",responseObject);
        if ([responseObject[@"status"] integerValue] == 200) {
            [MBProgressHUD showSuccess:@"叫号成功"];
            
            CellModel *model = self.dataSource[index];
            model.orderStatus = status;
        //    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:(UITableViewRowAnimationBottom)];
            
        }else{
            [MBProgressHUD showError:responseObject[@"msg"]];
            
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
#pragma mark 拒单操作
- (void)isJvDanWithOrderNumber:(NSString *)orderNum
                         index:(NSInteger)index
                   JvDanReason:(NSString *)reason{
    NSDictionary *partner = @{
                              @"token":KUSERID,
                              @"orderStatusMsg":reason,
                              @"orderStatus":@"3",
                              @"orderNum":orderNum,
                              };
    //  NSLog(@"%@",partner);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html", nil];
    
    [manager POST:[NSString stringWithFormat:@"%@/appordersr/updatebyorderstatus",HXEORDER] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //     NSLog(@"%@",responseObject);
        if ([responseObject[@"status"] integerValue] == 200) {
            [self setRefresh];
        }else{
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
        
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //    NSLog(@"%@",error);
    }];
    
}
#pragma mark 接单操作
- (void)isJieDanWithStastu:(NSString *)status
                  orderNum:(NSString *)orderNum
                     index:(NSInteger)index{
    
    NSDictionary *partner = @{
                              @"token":KUSERID,
                              @"orderStatusMsg":@"修改订单状态",
                              @"orderStatus":status,
                              @"orderNum":orderNum,
                              };
  //  NSLog(@"%@",partner);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html", nil];
    
    [manager POST:[NSString stringWithFormat:@"%@/appordersr/updatebyorderstatus",HXEORDER] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
   //     NSLog(@"%@",responseObject);
        if ([responseObject[@"status"] integerValue] == 200) {
            [self setRefresh];
        }else{
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
        
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    //    NSLog(@"%@",error);
    }];
    
    
}


#pragma 打印订单
- (void)printOrderWithOrderNumber:(NSString *)orderNumber{
    
    NSDictionary *partner = @{
                              @"orderNum": orderNumber,
                              @"token": KUSERID
                              };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager POST:[NSString stringWithFormat:@"%@/appordersr/findOrderByOrderNums",HXEORDER] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"status"] integerValue] == 200) {
            
            NSDictionary *dic = responseObject[@"data"];
      //      NSLog(@"%@",dic);
            BOOL x = [responseObject[@"data"] isKindOfClass:[NSDictionary class]];
            
            if (x == 1) {
                [Manager write:[self escCommandWithOrderDic:dic] progress:^(NSUInteger total, NSUInteger progress) {
                 //   NSLog(@"打印成功");
                    [MBProgressHUD showSuccess:@"打印中"];
                } receCallBack:^(NSData * _Nullable data) {
                    NSLog(@"%@",data);
                }];
                
            }else{
                //   NSString *data = responseObject[@"data"];
                [MBProgressHUD showError:@"订单数据为空"];
             //   NSLog(@"数据为空");
            }
            
            
        }else{
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      //  NSLog(@"%@",error);
    }];
}

#pragma mark
- (NSData *)escCommandWithOrderDic:(NSDictionary *)dic{
    
    EscCommand *command = [[EscCommand alloc]init];
    [command addInitializePrinter];
    
    NSInteger x = [dic[@"isPay"] integerValue];
    
    [command queryRealtimeStatus:2];
    
    if ([dic[@"orderType"] isEqualToString:@"DINEIN"]) {
        
        if (x == 2) {
            [command addPrintMode:0x0];
            [command addText:@"注意:堂食订单\n"];
            [command addPrintMode:0x0];
            [command addText:@"===============================\n"];
            
            [command addPrintMode:0x16 | 0x32];
            [command addSetJustification:1];
            [command addText:@"黄小二【堂食】\n\n"];
            
        }else if (x == 3 || x == 4){
            NSString *refuse = dic[@"desFefount"];
            
            [command addPrintAndFeedLines:1];
            [command addPrintMode:0x16 | 0x32];
            [command addText:@"黄小二【退款单】\n"];
            
            [command addPrintMode:0x0];
            [command addText:@"-------------------------------\n"];
            
            [command addPrintMode:0x16 | 0x32];
            [command addPrintAndFeedLines:0];
            [command addText:[NSString stringWithFormat:@"退款原因:%@\n",refuse]];
            
            [command addPrintMode:0x0];
            [command addText:@"-------------------------------\n"];
        }
        
        NSString *shopSign = dic[@"shopSign"];
     //   NSString *diningName = dic[@"diningName"];
        [command addPrintMode:0x0];
        [command addSetJustification:1];
        [command addText:[NSString stringWithFormat:@"%@\n",shopSign]];
        
        [command addSetJustification:0];
        [command addPrintMode:0x0];
        [command addText:@"-------------------------------\n"];
        
        NSString *creatTime = dic[@"createTime"];
        if (kStringIsEmpty(creatTime)) {
            [command addPrintMode:0x0];
            [command addText:[NSString stringWithFormat:@""]];
        }else{
            NSString *dateString = [creatTime substringWithRange:NSMakeRange(5, 11)];
            [command addPrintMode:0x0];
            [command addText:[NSString stringWithFormat:@"下单时间%@",dateString]];
        }
        
        
        
        [command addPrintMode:0x0];
        [command addText:@"\n-------------------------------\n"];
        
        NSString *deskNum = dic[@"deskNum"];
        [command addPrintMode:0x16 | 0x32];
        [command addText:[NSString stringWithFormat:@"桌号:%@\n",deskNum]];
        
        [command addPrintMode:0x0];
        [command addText:@"-------------------------------\n"];
        
    }else{
        
        
        if (x == 2) {
            
            if ([dic[@"isPack"] integerValue] == 2) {
                [command addPrintAndFeedLines:1];
                [command addPrintMode:0x0];
                [command addText:@"===============================\n"];
                
                [command addPrintMode:0X0];
                [command addText:@"注意:此单用户要求打包\n"];
                [command addPrintMode:0x0];
                [command addText:@"===============================\n"];
                
                [command addPrintMode:0x16 | 0x32];
                [command addText:@"黄小二【打包】\n\n"];
                
            }else{
                [command addPrintAndFeedLines:1];
                [command addPrintMode:0x0];
                [command addText:@"****"];
                
                [command addPrintMode:0x16 | 0x32];
                [command addText:@"  黄小二  "];
                [command addSetJustification:1];
                
                [command addPrintMode:0x0];
                [command addText:@"****\n\n"];
            }
            
        }else if (x == 1){
            [command addPrintAndFeedLines:1];
            [command addPrintMode:0x16 | 0x32];
            [command addText:@"黄小二【未支付单】\n"];
        }else if(x == 3 || x ==4){
            
            NSString *refuse = dic[@"desFefount"];
            
            [command addPrintAndFeedLines:1];
            [command addPrintMode:0x16 | 0x32];
            [command addText:@"黄小二【退款单】\n"];
            
            [command addPrintMode:0x0];
            [command addText:@"-------------------------------\n"];
            
            [command addPrintMode:0x16 | 0x32];
            [command addText:[NSString stringWithFormat:@"退款原因:%@\n",refuse]];
            
            [command addPrintMode:0x0];
            [command addText:@"-------------------------------\n"];
        }
        
        NSString *shopSign = dic[@"shopSign"];
        NSString *diningName = dic[@"diningName"];
        [command addPrintMode:0x0];
        [command addText:[NSString stringWithFormat:@"%@(%@)\n",shopSign,diningName]];
        [command addSetJustification:0];
        
        [command addPrintMode:0x0];
        [command addText:@"-------------------------------\n"];
        [command addSetJustification:0];
        
        NSString *takeNum = dic[@"takeNum"];
        [command addPrintMode:0x16 | 0x32];
        [command addText:[NSString stringWithFormat:@"叫号:%@\n",takeNum]];
        
        [command addPrintMode:0x0];
        [command addText:@"-------------------------------\n"];
        [command addSetJustification:0];
        
        [command addPrintMode:0x0];
        [command addText:@"预约时间:\n"];
        
        NSString *useDate = dic[@"useDate"];
        if (kStringIsEmpty(useDate)) {
            [command addPrintMode:0x0];
            [command addText:[NSString stringWithFormat:@""]];
        }else{
            NSString *dateString = [useDate substringWithRange:NSMakeRange(5, 11)];
            [command addPrintMode:0x16 | 0x32];
            [command addText:[NSString stringWithFormat:@"%@\n",dateString]];
        }
        
        
        [command addPrintMode:0x0];
        [command addText:@"-------------------------------\n"];
    }
    
    
    
    NSArray *orderArr = dic[@"goodsList"];
    NSMutableArray *orderDetailArr = [NSMutableArray arrayWithCapacity:0];
    [command addPrintMode:0x16];
    for (NSDictionary *dic in orderArr) {
        PostOrderModel *model = [[PostOrderModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [orderDetailArr addObject:model];
    }
    
    for (int i = 0; i < orderDetailArr.count; i ++) {
        PostOrderModel *model = orderDetailArr[i];
        [command addText:[NSString stringWithFormat:@"%@    X%@\n",model.goodsName,model.goodsNum]];
    }
    
    [command addPrintMode:0x0];
    [command addText:@"*******************************\n"];
    
    
    NSString *des = dic[@"des"];
    [command addPrintMode:0x16 | 0x32];
    [command addText:[NSString stringWithFormat:@"备注:%@",des]];
    [command addPrintMode:0x0];
    [command addText:@"\n*******************************\n"];
    
    NSString *totalFee = dic[@"totalFee"];
    [command addText:[NSString stringWithFormat:@"订单价格:%@元",totalFee]];
    [command addText:@"\n-------------------------------\n"];
    
    NSString *nickName = dic[@"nickName"];
    [command addText:[NSString stringWithFormat:@"%@\n",nickName]];
    
    NSString *phone = dic[@"phone"];
    [command addText:[NSString stringWithFormat:@"%@\n",phone]];
    
    NSString *orderNum = dic[@"orderNum"];
    [command addText:[NSString stringWithFormat:@"订单号:%@\n\n\n\n\n",orderNum]];
    
    
    return [command getCommand];
    
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
