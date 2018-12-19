//
//  DetailIncomeViewController.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/12/19.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "DetailIncomeViewController.h"

@interface DetailIncomeViewController ()

@end

@implementation DetailIncomeViewController
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
    
    self.navigationItem.title = @"预计收入详情";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21],NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
    
}
- (void)leftBarBtnClicked:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColor(240, 240, 240);
    
    [self initDetailIncomeView];
    // Do any additional setup after loading the view.
}

- (void)initDetailIncomeView{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 150)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 10;
    [self.view addSubview:view];
    
    UILabel *oneLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, kScreenWidth * 0.3, 30)];
    oneLable.text = @"订单支付金额";
    [view addSubview:oneLable];
    
    UILabel *totalFeeLable = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth * 0.4, 15, kScreenWidth * 0.5, 30)];
    totalFeeLable.textAlignment = NSTextAlignmentRight;
    totalFeeLable.text = [NSString stringWithFormat:@"￥%@",self.model.totalFee];
    [view addSubview:totalFeeLable];
    
    UILabel *twoLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 60, kScreenWidth * 0.3, 30)];
    twoLable.text = @"平台服务费";
    [view addSubview:twoLable];
    
    UILabel *fuwuFeeLable = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth * 0.4, 60, kScreenWidth * 0.5, 30)];
    fuwuFeeLable.textAlignment = NSTextAlignmentRight;
    CGFloat total = [self.model.totalFee floatValue];
    CGFloat income = [self.model.income floatValue];
    CGFloat fuwu = total - income;
    fuwuFeeLable.text = [NSString stringWithFormat:@"￥%.2f",fuwu];
    [view addSubview:fuwuFeeLable];
    
    UILabel *threeLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 105, kScreenWidth * 0.3, 30)];
    threeLable.text = @"预计收入";
    [view addSubview:threeLable];
    
    UILabel *lineLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 96, kScreenWidth - 40, 1)];
    lineLable.backgroundColor = kColor(240, 240, 240);
    [view addSubview:lineLable];
    
    UILabel *incomeLable = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth * 0.4, 105, kScreenWidth * 0.5, 35)];
    incomeLable.text = [NSString stringWithFormat:@"￥%@",_model.income];
    incomeLable.textAlignment = NSTextAlignmentRight;
    [view addSubview:incomeLable];
    
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
