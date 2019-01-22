//
//  BindingAliPayViewController.m
//  HuangXiaoErShop
//
//  Created by apple on 2019/1/16.
//  Copyright © 2019年 aladdin. All rights reserved.
//

#import "BindingAliPayViewController.h"

@interface BindingAliPayViewController ()
@property (weak, nonatomic) IBOutlet UIView *BackView;

@property (weak, nonatomic) IBOutlet UITextField *NumberTF;
@property (weak, nonatomic) IBOutlet UITextField *NameTF;
@property (weak, nonatomic) IBOutlet UIButton *SubmitBT;

@end

@implementation BindingAliPayViewController
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
    
    self.navigationItem.title = @"绑定支付宝";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
    
}
- (void)leftBarBtnClicked:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor(240, 240, 240);
    
    self.BackView.layer.masksToBounds = YES;
    self.BackView.layer.cornerRadius = 8;
    
    self.SubmitBT.layer.masksToBounds = YES;
    self.SubmitBT.layer.cornerRadius = 25;
    self.SubmitBT.backgroundColor = kColor(255, 210, 0);
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)SubmitData:(UIButton *)sender {
    
}


@end
