//
//  BindingWXViewController.m
//  HuangXiaoErShop
//
//  Created by apple on 2019/1/15.
//  Copyright © 2019年 aladdin. All rights reserved.
// 750 1559

#import "BindingWXViewController.h"

@interface BindingWXViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation BindingWXViewController

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
    
    self.navigationItem.title = @"绑定微信";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
    
}
- (void)leftBarBtnClicked:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor(240, 240, 240);
    CGFloat h = 1559 * (kScreenWidth - 20) / 750;
    
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.frame = CGRectMake(0, 0, kScreenWidth , kScreenHeight);
    _scrollView.contentSize = CGSizeMake(kScreenWidth, h + 60);
    _scrollView.userInteractionEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = YES;//是否显示侧边的滚动栏
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.scrollsToTop = NO;
    _scrollView.scrollEnabled = YES;
    
    [self.view addSubview:_scrollView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, h)];
    [imageView setImage:[UIImage imageNamed:@"BindingWXImage"]];
    [_scrollView addSubview:imageView];
    // Do any additional setup after loading the view.
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
