//
//  NewPendingViewController.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/12/14.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "NewPendingViewController.h"
#import "NewneworderViewController.h"
#import "NewCuiDanViewController.h"
#import "NewCancelOrderViewController.h"
#import "NewRefundViewController.h"

@interface NewPendingViewController ()

@end

@implementation NewPendingViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"待处理";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *testArray = [NSMutableArray array];
    NSArray *titleArr = @[@"新订单",@"催单",@"取消订单",@"退款"];
    for (int i = 0; i < 4; i++) {
        [testArray addObject:[NSString stringWithFormat:@"%@",titleArr[i]]];
    }
    NSMutableArray *childVcArray = [NSMutableArray array];
    
    NewneworderViewController *newVC = [[NewneworderViewController alloc]init];
    NewCuiDanViewController *cuiVC = [[NewCuiDanViewController alloc]init];
    NewCancelOrderViewController *cancelVC = [[NewCancelOrderViewController alloc]init];
    NewRefundViewController *refundVC = [[NewRefundViewController alloc]init];
    
    NSArray *arr = @[newVC,cuiVC,cancelVC,refundVC];
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
