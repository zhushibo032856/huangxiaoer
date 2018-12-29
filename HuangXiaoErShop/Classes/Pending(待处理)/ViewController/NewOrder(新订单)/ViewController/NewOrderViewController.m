//
//  NewOrderViewController.m
//  HXEshop
//
//  Created by apple on 2018/3/8.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "NewOrderViewController.h"
#import "JieDanCell.h"
#import "HeadView.h"
#import "CellModel.h"
#import "OrderLayoutModel.h"
#import "ManagerModel.h"

#import "ConnecterManager.h"
#import "PostOrderModel.h"

@interface NewOrderViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;//数据源

@property (nonatomic, strong) HeadView *currentSecHeadView;


@property (nonatomic, strong) NSMutableArray *layoutArr;//订单菜品数据

@property (nonatomic, strong) UISwitch *AutoSwitch;

@property (nonatomic, assign) NSInteger thePage;

@property (nonatomic, strong) NSMutableArray *dataArray;//主页数据

@property (nonatomic, assign) NSInteger isAuto;

@property (nonatomic, assign) NSInteger index;

@end

@implementation NewOrderViewController

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
    
    UIView *autoJDView = [UIView new];
    autoJDView.frame = CGRectMake(0, 0, kScreenWidth, 40);
    autoJDView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
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

    CGFloat commen = kNav_H + kTabbar_H;
    if (iPhoneX) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, kScreenHeight - commen - 155) style:(UITableViewStyleGrouped)];
    }else{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, kScreenHeight - 70 -  64 - 49) style:(UITableViewStyleGrouped)];
    }
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"JieDanCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"JieDanCell"];
    self.tableView.delaysContentTouches = YES;

    [self jieDanZhuangTai];
    
    [self setRefresh];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setRefresh) name:@"postnote" object:nil];

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

- (void)jieDanZhuangTai{
    NSDictionary *partner = @{
                              @"token":KUSERID
                              };
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
        
        NSLog(@"%@",responseObject);
        if ([responseObject[@"status"] integerValue] == 200) {
            
            [MBProgressHUD showSuccess:responseObject[@"msg"]];
        
        }else{
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CellModel *model = self.dataSource[section];
    if (model.isShow) {
        return 1;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    OrderLayoutModel *model = self.layoutArr[indexPath.section];
    return model.cellHei;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CellModel *model = self.dataSource[indexPath.section];
    JieDanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JieDanCell" forIndexPath:indexPath];
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

- (void)updatOrderStatusWithIndex:(NSInteger)index
                           BtnTag:(NSInteger)btnTag
{
    CellModel *model = self.dataSource[index];
    NSString *status;
    if (btnTag == 100) {
        status = @"3";
        [self isJieDanWithStastu:status orderNum:model.orderNum index:index];
    } else if (btnTag == 200){
        status = @"2";
        [self isJieDanWithStastu:status orderNum:model.orderNum index:index];
    }else if (btnTag == 300){
        status = @"4";
//        if ([model.isPay integerValue] != 2) {
//            [MBProgressHUD showError:@"当前订单不允许叫号"];
//        }else{
        [self jiaohaoWithUserID:model.tb_customer_id OrderNum:model.orderNum index:index Stastu:status butTag:300];
        //}
    }else if (btnTag == 400){
        [self callNumberWithPhone:model.phone];
    }
}
- (void)callNumberWithPhone:(NSString *)phone{
    NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel:%@",phone];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

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
     //   NSLog(@"%@",responseObject);
        if ([responseObject[@"status"] integerValue] != 400) {
            [MBProgressHUD showSuccess:@"叫号成功"];
           
            CellModel *model = self.dataSource[index];
            model.orderStatus = status;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:(UITableViewRowAnimationBottom)];
            
        }else{
            [MBProgressHUD showError:responseObject[@"msg"]];
        
        }
            [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)isJieDanWithStastu:(NSString *)status
                  orderNum:(NSString *)orderNum
                     index:(NSInteger)index
{
    
    NSDictionary *partner = @{
                              @"token":KUSERID,
                              @"orderStatusMsg":@"修改订单状态",
                              @"orderStatus":status,
                              @"orderNum":orderNum,
                              };
    NSLog(@"%@",partner);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html", nil];
    
    [manager POST:[NSString stringWithFormat:@"%@/appordersr/updatebyorderstatus",HXEORDER] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"status"] integerValue] == 200) {
           
           [self setRefresh];
        }else{
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
       
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
    }];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HeadView *sectionHeadView = [HeadView SetHeadView];
    sectionHeadView.frame = CGRectMake(0, 0, self.view.frame.size.width, 50);
 
    CellModel *model = self.dataSource[section];
    OrderCaiModel *caiModel = model.arr.firstObject;

    if ([model.orderType isEqualToString:@"APPOINTMENT"] || [model.orderType isEqualToString:@"SECKILL"]) {//预约
        [sectionHeadView.TypeImageView setImage:[UIImage imageNamed:@"APPOINTMENT"]];
    }else if ([model.orderType isEqualToString:@"ARRIVE"]){
        [sectionHeadView.TypeImageView setImage:[UIImage imageNamed:@"ARRIVE"]];
    }else if([model.orderType isEqualToString:@"PT"]){//拼团
        [sectionHeadView.TypeImageView setImage:[UIImage imageNamed:@"PT"]];
    }else if([model.orderType isEqualToString:@"DINEIN"]){//堂食
        [sectionHeadView.TypeImageView setImage:[UIImage imageNamed:@"DINEIN"]];
    }
    
    sectionHeadView.Bt.tag = section + 1000;
    
    if ([model.orderStatus integerValue] == 4) {
        UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipes:)];
        left.direction = UISwipeGestureRecognizerDirectionLeft;
        [sectionHeadView addGestureRecognizer:left];
        
    }else{
        UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipes)];
        left.direction = UISwipeGestureRecognizerDirectionLeft;
        [sectionHeadView addGestureRecognizer:left];
        
    }
    
    sectionHeadView.timeLb.font = [UIFont systemFontOfSize:15];
    if([model.orderType isEqualToString:@"DINEIN"]){//堂食
        
        NSString *string = [model.createTime substringWithRange:NSMakeRange(5, 11)];
        sectionHeadView.timeLb.text = [NSString stringWithFormat:@"%@",string];
    }else{
    if (kStringIsEmpty(model.useDate)) {
        sectionHeadView.timeLb.text = [NSString stringWithFormat:@""];
    }else{
    NSString *string = [model.useDate substringWithRange:NSMakeRange(5, 11)];
        sectionHeadView.timeLb.text = [NSString stringWithFormat:@"%@",string];
      }
    }
    
    
    if (model.arr.count == 1) {
        sectionHeadView.nameLable.text = [NSString stringWithFormat:@"%@  1",caiModel.goodsName];
    }else{
        sectionHeadView.nameLable.text = [NSString stringWithFormat:@"%@  ···",caiModel.goodsName];
    }
    
    if([model.orderType isEqualToString:@"DINEIN"]){//堂食
        if (model.deskNum.length < 2) {
            sectionHeadView.xunxuLb.text = [NSString stringWithFormat:@"0%@",model.deskNum];
        }else{
            sectionHeadView.xunxuLb.text = [NSString stringWithFormat:@"%@",model.deskNum];
        }
    }else{
        if (model.takeNum.length < 2) {
            sectionHeadView.xunxuLb.text = [NSString stringWithFormat:@"0%@",model.takeNum];
        }else{
            sectionHeadView.xunxuLb.text = [NSString stringWithFormat:@"%@",model.takeNum];
        }
    }
    
    
    if ([model.orderStatus integerValue] == 1) {
        sectionHeadView.statusLb.text = @"等待接单";
        sectionHeadView.statusLb.textColor = [UIColor darkGrayColor];
    } else  if ([model.orderStatus integerValue] == 2) {
        sectionHeadView.statusLb.text = @"已接单";
        sectionHeadView.statusLb.textColor = kColor(18, 203, 119);
    } else  if ([model.orderStatus integerValue] == 3) {
        sectionHeadView.statusLb.text = @"已拒单";
        sectionHeadView.statusLb.textColor = [UIColor redColor];
    } else if ([model.orderStatus integerValue] == 4){
        sectionHeadView.statusLb.text = @"已叫号";
        sectionHeadView.statusLb.textColor = kColor(18, 203, 119);
    }
    
    [sectionHeadView.Bt addTarget:self action:@selector(BtAction:) forControlEvents:(UIControlEventTouchUpInside)];
    return sectionHeadView;
    
}

-(void)handleSwipes:(UISwipeGestureRecognizer *)recognizer
{
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否删除已完成订单" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        CellModel *model = self.dataSource[_index];
 //       NSLog(@"===%@+++%ld",model.takeNum,self.index);
        NSString  *status = @"6";
        [self isJieDanWithStastu:status orderNum:model.orderNum index:_index];
        
        [self setRefresh];
    }];

    UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

    }];

    [alertView addAction:action];
    [alertView addAction:actionOne];
    [self presentViewController:alertView animated:YES completion:nil];
    [self.tableView reloadData];
    
}
- (void)handleSwipes{
    [MBProgressHUD showError:@"订单未完成，不能删除"];
}
- (void)BtAction:(UIButton *)sender {
    CellModel *model = self.dataSource[sender.tag - 1000];
    model.isShow = !model.isShow;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag - 1000] withRowAnimation:(UITableViewRowAnimationFade)];
    
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return view;
}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"------------");
//}


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

 //   NSLog(@"%@",lastTime);
    
    NSDate *nextDay = [NSDate dateWithTimeInterval:24*60*60 sinceDate:dateNow];//后一天
    NSString *nextTime = [format stringFromDate:nextDay];
    NSString *endTime = [NSString stringWithFormat:@"%@%@",nextTime,string];

 //   NSLog(@"%@",nextTime);
    
    
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
            NSLog(@"%@",dic);
            BOOL x = [responseObject[@"data"] isKindOfClass:[NSDictionary class]];
            
            if (x == 1) {
                [Manager write:[self escCommandWithOrderDic:dic] progress:^(NSUInteger total, NSUInteger progress) {
                    NSLog(@"打印成功");
                } receCallBack:^(NSData * _Nullable data) {
                    NSLog(@"打印失败");
                    NSLog(@"%@",data);
                    NSDate *date = [NSDate date];
                    NSLog(@"%@",date);
                }];
                
            }else{
                //   NSString *data = responseObject[@"data"];
                [MBProgressHUD showError:@"订单数据为空"];
                NSLog(@"数据为空");
            }
            
            
        }else{
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark
- (NSData *)escCommandWithOrderDic:(NSDictionary *)dic{
    
    EscCommand *command = [[EscCommand alloc]init];
    [command addInitializePrinter];
    
    NSInteger x = [dic[@"isPay"] integerValue];
    
    [command queryRealtimeStatus:2];
    
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
    
    [command addText:@"叫号:"];
    [command addPrintMode:0x16 | 0x32];
    [command addText:[NSString stringWithFormat:@"%@\n",takeNum]];
    
    [command addPrintMode:0x0];
    [command addText:@"预约时间:\n"];
    
    NSString *useDate = dic[@"useDate"];
    if (kStringIsEmpty(useDate)) {
        NSLog(@"数据为空");
    }else{
        NSString *dateString = [useDate substringWithRange:NSMakeRange(5, 11)];
        [command addPrintMode:0x16 | 0x32];
        [command addText:[NSString stringWithFormat:@"%@\n",dateString]];
    }
    
    
    [command addPrintMode:0x0];
    [command addText:@"-------------------------------\n"];
    
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
    [command addText:@"-------------------------------\n"];
    
    
    NSString *des = dic[@"des"];
    [command addText:[NSString stringWithFormat:@"备注:%@",des]];
    [command addText:@"\n-------------------------------\n"];
    
    
    NSString *totalFee = dic[@"totalFee"];
    [command addText:[NSString stringWithFormat:@"订单价格:%@元",totalFee]];
    [command addText:@"\n-------------------------------\n"];
    
    NSString *nickName = dic[@"nickName"];
    [command addText:[NSString stringWithFormat:@"%@\n",nickName]];
    
    NSString *phone = dic[@"phone"];
    [command addText:[NSString stringWithFormat:@"%@\n",phone]];
    
    [command addText:@"11111111111111 \n"];
    
    NSString *orderNum = dic[@"orderNum"];
    [command addText:[NSString stringWithFormat:@"订单号:%@\n\n\n\n\n",orderNum]];
    
    
    return [command getCommand];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

