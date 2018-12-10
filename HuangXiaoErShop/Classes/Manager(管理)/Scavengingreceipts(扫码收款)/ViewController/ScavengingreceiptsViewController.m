//
//  ScavengingreceiptsViewController.m
//  HXEshop
//
//  Created by apple on 2018/5/4.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "ScavengingreceiptsViewController.h"
#import "BirthdayView.h"
#import "ScavengingTableViewCell.h"


@interface ScavengingreceiptsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton * todayButton;
    UIButton *selectTimeButton;
}
@property (nonatomic, strong) LVDatePickerModel *birth;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger thePage;

@end
static NSString * const scavengCell = @"ScavengingTableViewCell";
@implementation ScavengingreceiptsViewController

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
    
 //   [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"backcolor"] forBarMetrics:UIBarMetricsDefault];
    
    UIView *timeView = [[UIView alloc]initWithFrame:CGRectMake(20, 20, 160, 30)];
    self.navigationItem.titleView = timeView;
    
    todayButton =[UIButton buttonWithType:UIButtonTypeSystem];
    todayButton.frame = CGRectMake(0, 0, 80, 30);
    [todayButton setTitle:@"今天" forState:UIControlStateNormal];
    [todayButton setBackgroundColor:kColor(255, 255, 255)];
    [todayButton setTintColor:kColor(255, 210, 0)];
    
    
    [todayButton.layer setBorderWidth:1];
    [todayButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [todayButton addTarget:self action:@selector(getTodayTimeButton:) forControlEvents:UIControlEventTouchUpInside];
    [timeView addSubview:todayButton];
    
    
    selectTimeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    selectTimeButton.frame = CGRectMake(CGRectGetMaxX(todayButton.frame) - 1, 0, 80, 30);
    [selectTimeButton setTitle:@"选择日期" forState:UIControlStateNormal];
    //  [selectTimeButton setBackgroundColor:kColor(255, 210, 0)];
    [selectTimeButton setTintColor:kColor(255, 255, 255)];
    [selectTimeButton.layer setBorderWidth:1];
    [selectTimeButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [selectTimeButton addTarget:self action:@selector(selectTimeButton:) forControlEvents:UIControlEventTouchUpInside];
    [timeView addSubview:selectTimeButton];
}
- (void)leftBarBtnClicked:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)getTodayTimeButton:(UIButton *)sender{
    [todayButton setBackgroundColor:kColor(255, 255, 255)];
    [todayButton setTintColor:kColor(255, 210, 0)];
    [selectTimeButton setBackgroundColor:kColor(255, 215, 0)];
    [selectTimeButton setTintColor:kColor(255, 255, 255)];
    
    NSDate *date=[NSDate date];
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *dateStr = [format stringFromDate:date];
    [self setRefreshWithDataString:dateStr];
}

- (void)selectTimeButton:(UIButton *)sender{
    BirthdayView *vc = [[BirthdayView alloc] init];
    [self.view addSubview:vc];
    vc.birthDay = self.birth;
    
    __weak typeof(self)weakSelf = self;
    vc.timeBlock = ^(LVDatePickerModel *birth) {
        weakSelf.birth = birth;
        [self->selectTimeButton setTitle:[NSString stringWithFormat:@"%@-%@",birth.month,birth.day] forState:UIControlStateNormal];
        [self->selectTimeButton setBackgroundColor:kColor(255, 255, 255)];
        [self->selectTimeButton setTintColor:kColor(255, 210, 0)];
        [self->todayButton setBackgroundColor:kColor(255, 228, 0)];
        [self->todayButton setTintColor:kColor(255, 255, 255)];
        NSString *timeString = [NSString stringWithFormat:@"%@-%@-%@",birth.year,birth.month,birth.day];
        [weakSelf setRefreshWithDataString:timeString];
    };
    [vc showBirthView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColor(230, 230, 230);
    
    self.titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    self.titleView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.titleView];
    
    UILabel *payTypeLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, kScreenWidth * 0.2, 30)];
    payTypeLable.text = @"支付方式";
    payTypeLable.font = [UIFont systemFontOfSize:14];
    payTypeLable.textAlignment = NSTextAlignmentCenter;
    [self.titleView addSubview:payTypeLable];
    
    UILabel *timeLable = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth * 0.3, 10, kScreenWidth * 0.1, 30)];
    timeLable.textAlignment = NSTextAlignmentCenter;
    timeLable.text = @"时间";
    timeLable.font = [UIFont systemFontOfSize:14];
    [self.titleView addSubview:timeLable];
    
    UILabel *moneyLable = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth * 0.55, 10, kScreenWidth * 0.1, 30)];
    moneyLable.textAlignment = NSTextAlignmentCenter;
    moneyLable.text = @"金额";
    moneyLable.font = [UIFont systemFontOfSize:14];
    [self.titleView addSubview:moneyLable];
    
    UILabel *orderNumberLable = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth * 0.75, 10, kScreenWidth * 0.2, 30)];
    orderNumberLable.textAlignment = NSTextAlignmentCenter;
    orderNumberLable.text = @"订单尾号";
    orderNumberLable.font = [UIFont systemFontOfSize:14];
    [self.titleView addSubview:orderNumberLable];
    
    CGFloat commen = kNav_H + kTabbar_H;
    if (iPhoneX) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 60, kScreenWidth - 20, kScreenHeight - commen - 60) style:(UITableViewStylePlain)];
    }else{
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 60, kScreenWidth - 20, kScreenHeight - 64 - 60) style:(UITableViewStylePlain)];
    }
    [self.tableView registerClass:[ScavengingTableViewCell class] forCellReuseIdentifier:scavengCell];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    NSDate *date=[NSDate date];
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *dateStr = [format stringFromDate:date];
    [self setRefreshWithDataString:dateStr];
    // Do any additional setup after loading the view.
}

- (void)setRefreshWithDataString:(NSString *)dataString{
    
    _thePage = 1;
    __block typeof(self)weakself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.tableView.mj_footer resetNoMoreData];
        weakself.thePage = 1;
        [self requestDataWithDate:dataString];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.thePage += 1;
        [self requestDataWithDate:dataString];
        [self.tableView.mj_footer endRefreshing];
    }];
    // 进入界面时刷新
    [self.tableView.mj_header beginRefreshing];
}

- (void)requestDataWithDate:(NSString *)dataString{
    
    NSString *currentTime = [[NSString stringWithFormat:@"%@", dataString]substringWithRange:NSMakeRange(0, 10)];
    NSString *string = @" 00:00:00";
    NSString *createTime = [NSString stringWithFormat:@"%@%@",currentTime,string];
    
    NSDictionary *partner = @{
                              @"createTime": createTime,
                              @"page": @(_thePage),
                              @"size": @(20),
                              @"token": KUSERID
                              };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    [manager POST:[NSString stringWithFormat:@"%@/appordersr0427/findallqr0427",HXEORDER] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"status"] integerValue] == 200) {
            if (_thePage == 1) {
                [self.dataArray removeAllObjects];
            }
            NSDictionary *dataDic = responseObject[@"data"];
            NSArray *arr = dataDic[@"rows"];
            for (NSDictionary *dic in arr) {
                ScavengModel *model = [ScavengModel new];
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
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
    }];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.dataArray.count == 0) {
        return self.tableView.frame.size.height;
    }else{
        return 0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:self.tableView.frame];
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth * 0.2, kScreenWidth * 0.2, kScreenWidth * 0.6, 30)];
    lable.text = @"今天没有扫码支付哦";
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = kColor(210, 210, 210);
    [view addSubview:lable];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ScavengModel *model = self.dataArray[indexPath.row];
    ScavengingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:scavengCell forIndexPath:indexPath];
    [cell cellSetDataWith:model];
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
