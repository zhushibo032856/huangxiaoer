//
//  OrderSelectViewController.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/8/3.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "OrderSelectViewController.h"
#import "AllOrderViewController.h"
#import "BeinOrderViewController.h"
#import "FinishedOrderViewController.h"
#import "CancelOrRefuseViewController.h"

@interface OrderSelectViewController ()
{
    UIButton * todayButton;
    UIButton *selectTimeButton;
    AllOrderViewController *allorderVC;
    BeinOrderViewController *beinVC;
    FinishedOrderViewController *finishedVC;
    CancelOrRefuseViewController *cancelVC;
}
@property (nonatomic, strong) LVDatePickerModel *birth;

@end

@implementation OrderSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDate *date=[NSDate date];
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *dateStr = [format stringFromDate:date];
    
    NSMutableArray *testArray = [NSMutableArray array];
    NSArray *titleArr = @[@"全部",@"进行中",@"已完成",@"取消/退款"];
    for (int i = 0; i < 4; i++) {
        [testArray addObject:[NSString stringWithFormat:@"%@",titleArr[i]]];
    }
    NSMutableArray *childVcArray = [NSMutableArray array];
    
    allorderVC = [AllOrderViewController new];
    beinVC = [BeinOrderViewController new];
    finishedVC = [FinishedOrderViewController new];
    cancelVC = [CancelOrRefuseViewController new];
    NSArray *arr = @[allorderVC,beinVC,finishedVC,cancelVC];
    [childVcArray addObjectsFromArray:arr];
    allorderVC.dataString = dateStr;
    beinVC.dataString = dateStr;
    finishedVC.dataString = dateStr;
    cancelVC.dataString = dateStr;
    LSPPageView *pageView = [[LSPPageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) titles:testArray.mutableCopy style:nil childVcs:childVcArray.mutableCopy parentVc:self];
    pageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:pageView];
    
    [self setNavigationController];
    // Do any additional setup after loading the view.
}
- (void)setNavigationController{
    
    //  [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"backcolor"] forBarMetrics:UIBarMetricsDefault];
    
    
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

- (void)getTodayTimeButton:(UIButton *)sender{
    [todayButton setBackgroundColor:kColor(255, 255, 255)];
    [todayButton setTintColor:kColor(255, 210, 0)];
    [selectTimeButton setBackgroundColor:kColor(255, 215, 0)];
    [selectTimeButton setTintColor:kColor(255, 255, 255)];
    
    NSDate *date=[NSDate date];
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *dateStr = [format stringFromDate:date];
    
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"dataNot" object:nil userInfo:@{@"dataString":dateStr}]];
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
        NSString *dataString = [NSString stringWithFormat:@"%@-%@-%@", birth.year,birth.month,birth.day];
        
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"dataNot" object:nil userInfo:@{@"dataString":dataString}]];
    };
    [vc showBirthView];
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
