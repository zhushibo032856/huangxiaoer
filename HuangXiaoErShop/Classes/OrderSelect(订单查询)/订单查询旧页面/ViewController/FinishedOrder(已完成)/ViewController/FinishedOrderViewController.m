//
//  FinishedOrderViewController.m
//  HXEshop
//
//  Created by apple on 2018/4/26.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "FinishedOrderViewController.h"
#import "AllOrderTableViewCell.h"
#import "CellModel.h"
#import "AllOrderLayoutModel.h"

@interface FinishedOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableDictionary *dic;//创建一个字典进行判断收缩还是展开
}
@property (nonatomic, strong) UIView *dataView;
@property (nonatomic, strong) UILabel *dataLable;
@property (nonatomic, strong) UITextField *dataTF;
@property (nonatomic, strong) UIButton *dataButton;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *changeButton;
@property (nonatomic, strong) UILabel *foodLable;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *layoutArr;

@property (nonatomic, assign) NSInteger thePage;

@end
static NSString * const allOrderCell = @"AllOrderTableViewCell";

@implementation FinishedOrderViewController

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

    
    dic = [NSMutableDictionary dictionary];
    
    [self creatTableView];
    
 //   [self requestDataWithDataString:self.dataString];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(send:) name:@"dataNot" object:nil];
    [self setRefreshWithDataString:self.dataString];
}

- (void)send:(NSNotification *)dataDic{
    //   NSLog(@"=======%@",dataDic.userInfo[@"dataString"]);
    [self.dataSource removeAllObjects];
    [self.layoutArr removeAllObjects];
 //   [self requestDataWithDataString:dataDic.userInfo[@"dataString"]];
    [self setRefreshWithDataString:dataDic.userInfo[@"dataString"]];
}

- (void)setRefreshWithDataString:(NSString *)dataString{
    
    _thePage = 1;
    __block typeof(self)weakself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.tableView.mj_footer resetNoMoreData];
        weakself.thePage = 1;
        [self requestDataWithDataString:dataString];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.thePage += 1;
        [self requestDataWithDataString:dataString];
        [self.tableView.mj_footer endRefreshing];
    }];
    // 进入界面时刷新
    [self.tableView.mj_header beginRefreshing];
}

- (void)requestDataWithDataString:(NSString *)dataString{
    
    NSString *currentTime = [[NSString stringWithFormat:@"%@", dataString]substringWithRange:NSMakeRange(0, 10)];
    NSString *string = @" 00:00:00";
    NSString *createTime = [NSString stringWithFormat:@"%@%@",currentTime,string];
    
    NSDictionary *partner = @{
                              @"createTime": createTime,
                              @"page": @(_thePage),
                              @"size": @"20",
                              @"token": KUSERID
                              };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html", nil];
    
    [manager POST:[NSString stringWithFormat:@"%@/appordersr0427/findorderimpl0427",HXEORDER] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    //    NSLog(@"%@",responseObject);
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
                
                AllOrderLayoutModel *layoutModel = [AllOrderLayoutModel new];
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
            [dic removeAllObjects];
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
- (void)creatTableView{
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    lineView.backgroundColor = kColor(240, 240, 240);
    [self.view addSubview:lineView];

    if(iPhoneX){
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, kScreenHeight - 86 - 59 - 44 - 30) style:UITableViewStyleGrouped];
    }else{
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, kScreenHeight - 64 - 49 - 44) style:UITableViewStyleGrouped];
    }
    [self.tableView registerNib:[UINib nibWithNibName:@"AllOrderTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:allOrderCell];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.separatorStyle = NO;
    /*
     保证刷新cell时不会上下跳动
     */
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    [self.view addSubview:self.tableView];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CellModel *model = self.dataSource[section];
    if ([model.orderType isEqualToString:@"APPOINTMENT"] ||[model.orderType isEqualToString:@"SECKILL"]) {
        return 150;
    }
    return 120;
}
//
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    CellModel *model = self.dataSource[section];
    
    if ([model.orderType isEqualToString:@"APPOINTMENT"] ||[model.orderType isEqualToString:@"SECKILL"]) {
        
        
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth - 20, 150)];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:headerView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = headerView.bounds;
        maskLayer.path = maskPath.CGPath;
        headerView.layer.mask = maskLayer;
        
        headerView.backgroundColor = [UIColor whiteColor];
        
        /* 取餐号 */
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(45, 10, 150, 15)];
        lable.font = [UIFont systemFontOfSize:20];
        if ([model.orderType isEqualToString:@"APPOINTMENT"] ||[model.orderType isEqualToString:@"SECKILL"]) {
            if (model.takeNum.length == 0) {
                lable.text = @"取餐号 --";
            }else if (model.takeNum.length < 2 && model.takeNum.length > 0) {
                lable.text = [NSString stringWithFormat:@"取餐号 0%@",model.takeNum];
            }else{
                lable.text = [NSString stringWithFormat:@"取餐号 %@",model.takeNum];
            }
        }else{//堂食
            if (model.deskNum.length < 2) {
                lable.text = [NSString stringWithFormat:@"桌号 0%@",model.deskNum];
            }else{
                lable.text = [NSString stringWithFormat:@"桌号 %@",model.deskNum];
            }
        }
        
        [headerView addSubview:lable];
        
        
        /* 拼团图片 */
        UIImageView *typeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 7, 20, 20)];
        if ([model.orderType isEqualToString:@"APPOINTMENT"] ||[model.orderType isEqualToString:@"SECKILL"]) {
            [typeImageView setImage:[UIImage imageNamed:@"APPOINTMENT"]];
        }else{//堂食
            [typeImageView setImage:[UIImage imageNamed:@"DINEIN"]];
        }
        [headerView addSubview:typeImageView];
        /* 接单状态 */
        UILabel *statusLable = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth * 0.3, 10, kScreenWidth * 0.6, 15)];
        statusLable.font = [UIFont systemFontOfSize:13];
        statusLable.textAlignment = NSTextAlignmentRight;
        statusLable.textColor = kColor(153, 153, 153);
        
        if ([model.orderStatus integerValue] == 1) {
            statusLable.text = @"待接单";
        }else if ([model.orderStatus integerValue] == 2){
            statusLable.text = @"已接单";
        }else if ([model.orderStatus integerValue] == 3){
            statusLable.text = @"商家拒单";
        }else if ([model.orderStatus integerValue] == 4){
            statusLable.text = @"等待取餐";
        }else if ([model.orderStatus integerValue] == 5){
            statusLable.text = @"用户退单";
        }else if ([model.orderStatus integerValue] == 6){
            statusLable.text = @"订单完成";
        }else{
            statusLable.text = @"已取消";
        }
        [headerView addSubview:statusLable];
        
        
        /* 用户名 */
        UILabel *nameLable = [[UILabel alloc]initWithFrame:CGRectMake(150, CGRectGetMaxY(lable.frame) + 15, kScreenWidth * 0.6, 15)];
        if (kStringIsEmpty(model.nickName)) {
            nameLable.text = [NSString stringWithFormat:@"黄小二"];
        }else{
            nameLable.text = [NSString stringWithFormat:@"%@",model.nickName];
        }
        nameLable.font = [UIFont systemFontOfSize:15];
        [headerView addSubview:nameLable];
        
        /* 联系顾客 */
        UIImageView *phoneImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth * 0.7 + 5, CGRectGetMaxY(lable.frame) + 16.5, 12, 12)];
        [phoneImageView setImage:[UIImage imageNamed:@"callPhone"]];
        [headerView addSubview:phoneImageView];
        
        UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeSystem];
        phoneButton.frame = CGRectMake(CGRectGetMaxX(phoneImageView.frame) - 2, CGRectGetMaxY(lable.frame) + 15, kScreenWidth * 0.2, 15);
        [phoneButton setTitle:@"联系顾客" forState:UIControlStateNormal];
        [phoneButton setTintColor:kColor(100, 100, 100)];
        [phoneButton setTag:1000 +section];
        phoneButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [phoneButton addTarget:self action:@selector(callNumberWithPhoneWith:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:phoneButton];
        
        /*预计到店时间*/
        UILabel *appointLable = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(nameLable.frame) + 12.5, kScreenWidth * 0.4, 15)];
        appointLable.text = @"预计到店时间";
        appointLable.font = [UIFont systemFontOfSize:15];
        [headerView addSubview:appointLable];
        
        UILabel *timeLable = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth * 0.5, CGRectGetMaxY(nameLable.frame) + 10, kScreenWidth * 0.4, 20)];
        [timeLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
        timeLable.textAlignment = NSTextAlignmentRight;
        if (kStringIsEmpty(model.useDate)) {
            timeLable.text = [NSString stringWithFormat:@""];
        }else{
            NSString *string = [model.useDate substringWithRange:NSMakeRange(5, 11)];
            timeLable.text = [NSString stringWithFormat:@"%@",string];
        }
        [headerView addSubview:timeLable];
        /* 订单 */
        UILabel *orderLable = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(nameLable.frame) + 45, 50, 15)];
        orderLable.text = @"订单";
        orderLable.font = [UIFont systemFontOfSize:13];
        orderLable.textColor = kColor(190, 190, 190);
        [headerView addSubview:orderLable];
        
        /* 菜单名 */
        OrderCaiModel *caiModel = model.arr.firstObject;
        self.foodLable = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(orderLable.frame) + 15, 150, 15)];
        self.foodLable.text = [NSString stringWithFormat:@"%@ ···",caiModel.goodsName];
        self.foodLable.font = [UIFont systemFontOfSize:15];
        
        [headerView addSubview:self.foodLable];
        
        /* 展开收起按钮 */
        self.changeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.changeButton.frame = CGRectMake(kScreenWidth * 0.76, CGRectGetMaxY(phoneButton.frame) + 30 + 30, kScreenWidth * 0.14, 25);
        self.changeButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.changeButton.layer setCornerRadius:12.5];
        [self.changeButton.layer setBorderWidth:1];
        [self.changeButton setTintColor:kColor(10, 10, 10)];
        [self.changeButton setTag:300 + section];
        [self.changeButton addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *str = [NSString stringWithFormat:@"%ld",(long)_changeButton.tag];
        
        if (kStringIsEmpty(dic[str])) {
            [dic setObject:@"0" forKey:str];
            [self.changeButton setTitle:@"展开" forState:UIControlStateNormal];
            [self.changeButton.layer setBorderColor:kColor(255, 210, 0).CGColor];
            self.foodLable.hidden = NO;
        }else {
            if ([dic[str] integerValue] == 0) {//如果是0，就把1赋给字典,打开cell
                [self.changeButton setTitle:@"展开" forState:UIControlStateNormal];
                [self.changeButton.layer setBorderColor:kColor(255, 210, 0).CGColor];
                self.foodLable.hidden = NO;
            }else{//反之关闭cell
                [self.changeButton setTitle:@"收起" forState:UIControlStateNormal];
                [self.changeButton.layer setBorderColor:[UIColor blackColor].CGColor];
                self.foodLable.hidden = YES;
            }
            
        }
        [headerView addSubview:self.changeButton];
        return headerView;
        
    }else{
        
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth - 20, 120)];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:headerView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = headerView.bounds;
        maskLayer.path = maskPath.CGPath;
        headerView.layer.mask = maskLayer;
        
        headerView.backgroundColor = [UIColor whiteColor];
        
        /* 取餐号 */
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(45, 10, 150, 15)];
        lable.font = [UIFont systemFontOfSize:20];
        if ([model.orderType isEqualToString:@"APPOINTMENT"] ||[model.orderType isEqualToString:@"SECKILL"]) {
            if (model.takeNum.length == 0) {
                lable.text = @"取餐号 --";
            }else if (model.takeNum.length < 2 && model.takeNum.length > 0) {
                lable.text = [NSString stringWithFormat:@"取餐号 0%@",model.takeNum];
            }else{
                lable.text = [NSString stringWithFormat:@"取餐号 %@",model.takeNum];
            }
        }else{//堂食
            lable.text = [NSString stringWithFormat:@"桌号 %@",model.deskNum];
        }
        
        [headerView addSubview:lable];
        
        
        /* 拼团图片 */
        UIImageView *typeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 7, 20, 20)];
        if ([model.orderType isEqualToString:@"APPOINTMENT"] ||[model.orderType isEqualToString:@"SECKILL"]) {
            [typeImageView setImage:[UIImage imageNamed:@"APPOINTMENT"]];
        }else{//堂食
            [typeImageView setImage:[UIImage imageNamed:@"DINEIN"]];
        }
        [headerView addSubview:typeImageView];
        /* 接单状态 */
        UILabel *statusLable = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth * 0.3, 10, kScreenWidth * 0.6, 15)];
        statusLable.font = [UIFont systemFontOfSize:13];
        statusLable.textAlignment = NSTextAlignmentRight;
        statusLable.textColor = kColor(153, 153, 153);
        
        if ([model.orderStatus integerValue] == 1) {
            statusLable.text = @"待接单";
        }else if ([model.orderStatus integerValue] == 2){
            statusLable.text = @"已接单";
        }else if ([model.orderStatus integerValue] == 3){
            statusLable.text = @"商家拒单";
        }else if ([model.orderStatus integerValue] == 4){
            statusLable.text = @"等待取餐";
        }else if ([model.orderStatus integerValue] == 5){
            statusLable.text = @"用户退单";
        }else if ([model.orderStatus integerValue] == 6){
            statusLable.text = @"订单完成";
        }else{
            statusLable.text = @"已取消";
        }
        [headerView addSubview:statusLable];
        
        
        /* 用户名 */
        UILabel *nameLable = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(lable.frame) + 15, kScreenWidth * 0.6, 15)];
        if (kStringIsEmpty(model.nickName)) {
            nameLable.text = [NSString stringWithFormat:@"黄小二"];
        }else{
            nameLable.text = [NSString stringWithFormat:@"%@",model.nickName];
        }
        nameLable.font = [UIFont systemFontOfSize:15];
        [headerView addSubview:nameLable];
        
        /* 联系顾客 */
        UIImageView *phoneImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth * 0.7 + 5, CGRectGetMaxY(lable.frame) + 16.5, 12, 12)];
        [phoneImageView setImage:[UIImage imageNamed:@"callPhone"]];
        [headerView addSubview:phoneImageView];
        
        UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeSystem];
        phoneButton.frame = CGRectMake(CGRectGetMaxX(phoneImageView.frame) - 2, CGRectGetMaxY(lable.frame) + 15, kScreenWidth * 0.2, 15);
        [phoneButton setTitle:@"联系顾客" forState:UIControlStateNormal];
        [phoneButton setTintColor:kColor(100, 100, 100)];
        [phoneButton setTag:1000 +section];
        phoneButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [phoneButton addTarget:self action:@selector(callNumberWithPhoneWith:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:phoneButton];
        
        /* 订单 */
        UILabel *orderLable = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(nameLable.frame) + 15, 50, 15)];
        orderLable.text = @"订单";
        orderLable.font = [UIFont systemFontOfSize:13];
        orderLable.textColor = kColor(190, 190, 190);
        [headerView addSubview:orderLable];
        
        /* 菜单名 */
        OrderCaiModel *caiModel = model.arr.firstObject;
        self.foodLable = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(orderLable.frame) + 15, 150, 15)];
        self.foodLable.text = [NSString stringWithFormat:@"%@ ···",caiModel.goodsName];
        self.foodLable.font = [UIFont systemFontOfSize:15];
        
        [headerView addSubview:self.foodLable];
        
        /* 展开收起按钮 */
        self.changeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.changeButton.frame = CGRectMake(kScreenWidth * 0.76, CGRectGetMaxY(phoneButton.frame) + 30, kScreenWidth * 0.14, 25);
        self.changeButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.changeButton.layer setCornerRadius:12.5];
        [self.changeButton.layer setBorderWidth:1];
        [self.changeButton setTintColor:kColor(10, 10, 10)];
        [self.changeButton setTag:300 + section];
        [self.changeButton addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *str = [NSString stringWithFormat:@"%ld",(long)_changeButton.tag];
        
        if (kStringIsEmpty(dic[str])) {
            [dic setObject:@"0" forKey:str];
            [self.changeButton setTitle:@"展开" forState:UIControlStateNormal];
            [self.changeButton.layer setBorderColor:kColor(255, 210, 0).CGColor];
            self.foodLable.hidden = NO;
        }else {
            if ([dic[str] integerValue] == 0) {//如果是0，就把1赋给字典,打开cell
                [self.changeButton setTitle:@"展开" forState:UIControlStateNormal];
                [self.changeButton.layer setBorderColor:kColor(255, 210, 0).CGColor];
                self.foodLable.hidden = NO;
            }else{//反之关闭cell
                [self.changeButton setTitle:@"收起" forState:UIControlStateNormal];
                [self.changeButton.layer setBorderColor:[UIColor blackColor].CGColor];
                self.foodLable.hidden = YES;
            }
            
        }
        [headerView addSubview:self.changeButton];
        return headerView;
    }
}

- (void)action:(UIButton *)sender{
    NSString *str = [NSString stringWithFormat:@"%ld",sender.tag];
    
    if ([dic[str] integerValue] == 0) {//如果是0，就把1赋给字典,打开cell
        [dic setObject:@"1" forKey:str];
        
    }else{//反之关闭cell
        [dic setObject:@"0" forKey:str];
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag-300] withRowAnimation:UITableViewRowAnimationFade];
}
- (void)callNumberWithPhoneWith:(UIButton *)sender{
    
    CellModel *model = self.dataSource[sender.tag - 1000];
    NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel:%@",model.phone];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [UIView new];
    CellModel *model = self.dataSource[section];
    view.backgroundColor = kColor(255, 255, 255);
    
    UILabel *priceLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, kScreenWidth * 0.3, 20)];
    priceLable.text = @"本单预计收入";
    priceLable.font = [UIFont systemFontOfSize:13];
    [view addSubview:priceLable];
    
    
    UILabel *sumPriceLable = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth * 0.55, 5, kScreenWidth * 0.45 - 40, 20)];
    sumPriceLable.textAlignment = NSTextAlignmentRight;
    sumPriceLable.font = [UIFont systemFontOfSize:15];
    
    CGFloat totalPrice = [model.income floatValue];
    sumPriceLable.text = [NSString stringWithFormat:@"￥%.2f",totalPrice];
    
    [view addSubview:sumPriceLable];
    /* 分隔视图 */
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 30, kScreenWidth, 10)];
    lineView.backgroundColor = kColor(240, 240, 240);
    [view addSubview:lineView];
    
    return view;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *string = [NSString stringWithFormat:@"%ld",(long)section+300];
    if ([dic[string] integerValue] == 1 ) {  //打开cell返回数组的count
        return 1;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AllOrderLayoutModel *model = self.layoutArr[indexPath.section];
    return model.cellHei;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CellModel *model = self.dataSource[indexPath.section];
    AllOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:allOrderCell forIndexPath:indexPath];
    [cell cellViewsValueWithModel:model];
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
