//
//  TodayOrderViewController.m
//  HXEshop
//
//  Created by apple on 2018/3/4.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "TodayOrderViewController.h"
#import "LSPPageView.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThreeViewController.h"

@interface TodayOrderViewController ()


@end



@implementation TodayOrderViewController


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
    
  //  [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"backcolor"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationItem.title = @"订单详情";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21],NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
    
}
- (void)leftBarBtnClicked:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSMutableArray *testArray = [NSMutableArray array];
    NSArray *titleArr = @[@"今日订单",@"全部"];
    for (int i = 0; i < 2; i++) {
        [testArray addObject:[NSString stringWithFormat:@"%@",titleArr[i]]];
    }
    NSMutableArray *childVcArray = [NSMutableArray array];
    
    FirstViewController *firstVC = [FirstViewController new];
  //  SecondViewController *secondVC = [SecondViewController new];
    ThreeViewController *threeVC = [ThreeViewController new];
    NSArray *arr = @[firstVC,threeVC];
    [childVcArray addObjectsFromArray:arr];
    
    LSPPageView *pageView = [[LSPPageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) titles:testArray.mutableCopy style:nil childVcs:childVcArray.mutableCopy parentVc:self];
    pageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:pageView];

    // Do any additional setup after loading the view.
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
