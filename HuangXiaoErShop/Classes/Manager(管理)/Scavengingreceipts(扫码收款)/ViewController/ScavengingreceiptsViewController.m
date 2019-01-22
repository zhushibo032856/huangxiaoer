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
#import "ScavengModel.h"

@interface ScavengingreceiptsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton * todayButton;
    UIButton *selectTimeButton;
}
@property (nonatomic, strong) LVDatePickerModel *birth;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger thePage;

@end

static NSString * const scavengCell = @"ScavengingTableViewCell";
static NSString * const noneCell = @"NoneDataCell";

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
    leftBtn.frame = CGRectMake(0, 0, 30, 30);;
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"itemBack"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBarBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    [self setNavigationController];
    
}
- (void)setNavigationController{
    
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
    
    self.view.backgroundColor = kColor(240, 240, 240);

    if (iPhoneX) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, kScreenHeight - 86) style:(UITableViewStyleGrouped)];
    }else{
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, kScreenHeight - 64) style:(UITableViewStyleGrouped)];
    }
    self.tableView.backgroundColor = kColor(240, 240, 240);
    [self.tableView registerNib:[UINib nibWithNibName:@"ScavengingTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:scavengCell];
    [_tableView registerClass:[NoneDataTableViewCell class] forCellReuseIdentifier:noneCell];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = NO;
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
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (kArrayIsEmpty(self.dataArray)) {
        return self.tableView.height;
    }
    return 75;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (kArrayIsEmpty(self.dataArray)) {
        return 1;
    }
    return _dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (kArrayIsEmpty(self.dataArray)) {
        NoneDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:noneCell forIndexPath:indexPath];
        [cell showNoDataWithImgurl:@"remind-3" andTipString:@"暂无收款记录"];
        return cell;
    }
    ScavengModel *model = self.dataArray[indexPath.section];
    ScavengingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:scavengCell forIndexPath:indexPath];
    cell.selectionStyle = NO;
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 8;
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
