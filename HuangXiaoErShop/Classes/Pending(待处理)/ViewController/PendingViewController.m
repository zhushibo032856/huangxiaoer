//
//  PendingViewController.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/8/3.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "PendingViewController.h"
#import "NewOrderViewController.h"
#import "CallNameViewController.h"
#import "CancelOrderViewController.h"
#import "RefundViewController.h"

@interface PendingViewController ()

@end

@implementation PendingViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setNavigationController];
    
    NSMutableArray *testArray = [NSMutableArray array];
    NSArray *titleArr = @[@"新订单",@"叫号",@"取消订单",@"拒单"];
    for (int i = 0; i < 4; i++) {
        [testArray addObject:[NSString stringWithFormat:@"%@",titleArr[i]]];
    }
    NSMutableArray *childVcArray = [NSMutableArray array];
    
    NewOrderViewController *newVC = [NewOrderViewController new];
    CallNameViewController *callVC = [CallNameViewController new];
    CancelOrderViewController *cancelVC = [CancelOrderViewController new];
    RefundViewController *refundVC = [RefundViewController new];
    NSArray *arr = @[newVC,callVC,cancelVC,refundVC];
    [childVcArray addObjectsFromArray:arr];
    
    LSPPageView *pageView = [[LSPPageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) titles:testArray.mutableCopy style:nil childVcs:childVcArray.mutableCopy parentVc:self];
    
    pageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:pageView];
    
    // Do any additional setup after loading the view.
}



- (void)setNavigationController{
    self.navigationItem.title = @"待处理";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
    
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
