//
//  BusinessanalysisViewController.m
//  HXEshop
//
//  Created by apple on 2018/5/30.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "BusinessanalysisViewController.h"
#import <WebKit/WebKit.h>

@interface BusinessanalysisViewController ()

@property (nonatomic, strong) WKWebView *wkWebView;

@end

@implementation BusinessanalysisViewController
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;

    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    leftBtn.frame = CGRectMake(0, 5, 40, 40);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"itemBack"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBarBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];

    [self setNavigationController];
    
}
- (void)setNavigationController{
    self.navigationController.navigationBar.frame = CGRectMake(0, 0, kScreenHeight, 64);
  
 //   [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"backcolor"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationItem.title = @"营业分析";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}] ;

}

- (void)leftBarBtnClicked:(UIButton *)btn{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
       // UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.frame];
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, -20, kScreenWidth, kScreenHeight + 20)];
    //    webView.backgroundColor = [UIColor yellowColor];
    
//
//
//    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    leftBtn.frame = CGRectMake(10, 40, 30, 30);
////[leftBtn setBackgroundImage:[UIImage imageNamed:@"itemBack"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(leftBarBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [webView addSubview:leftBtn];
    
        NSString *string = [NSString stringWithFormat:@"http://51hxe.com/appweb/index.html?key=%@",KUSERID];
        NSURL *url = [NSURL URLWithString:string];
        NSLog(@"%@",url);
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [webView loadRequest:request];
        [self.view addSubview:webView];
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
