//
//  BusinessanalysisViewController.m
//  HXEshop
//
//  Created by apple on 2018/5/30.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "BusinessanalysisViewController.h"
#import <WebKit/WebKit.h>

@interface BusinessanalysisViewController ()<WKNavigationDelegate,WKUIDelegate>

@property (nonatomic, strong) WKWebView *wkWebView;

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) WKWebViewConfiguration *wkConfig;

@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, strong) UIBarButtonItem *item;

@property (nonatomic, strong) UIImageView *loadImageView;

@end

@implementation BusinessanalysisViewController


- (WKWebViewConfiguration *)wkConfig {
    if (!_wkConfig) {
        _wkConfig = [[WKWebViewConfiguration alloc] init];
        _wkConfig.allowsInlineMediaPlayback = YES;
        _wkConfig.allowsPictureInPictureMediaPlayback = YES;
    }
    return _wkConfig;
}

- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) configuration:self.wkConfig];
        _wkWebView.navigationDelegate = self;
        _wkWebView.UIDelegate = self;
        [self.view addSubview:_wkWebView];
    }
    return _wkWebView;
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
    
    //   [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"backcolor"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationItem.title = @"营业分析";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21],NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
    
}
- (void)leftBarBtnClicked:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    
//    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
//  //  self.progressView.backgroundColor = kColor(255, 210, 0);
//    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
//    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
//    [self.view addSubview:self.progressView];
//
//    /*
//     *添加KVO，WKWebView有一个属性estimatedProgress，就是当前网页加载的进度，所以监听这个属性。
//     */
//    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    [self startLoad];
    // Do any additional setup after loading the view.
}


- (void)startLoad{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://51hxe.com/appweb/index.html?key=%@",KUSERID]]];
    [self.wkWebView loadRequest:request];
    
    if (@available(iOS 11.0, *)) {
        self.wkWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
//    if ([keyPath isEqualToString:@"estimatedProgress"]) {
//        self.progressView.progress = self.wkWebView.estimatedProgress;
//        if (self.progressView.progress == 1) {
//            /*
//             *添加一个简单的动画，将progressView的Height变为1.4倍
//             *动画时长0.25s，延时0.3s后开始动画
//             *动画结束后将progressView隐藏
//             */
//            __weak typeof (self)weakSelf = self;
//            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
//                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
//            } completion:^(BOOL finished) {
//                weakSelf.progressView.hidden = YES;
//
//            }];
//        }
//    }else{
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//    }
//}

//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    NSLog(@"开始加载网页");

    [SVProgressHUD showWithStatus:@"网页加载中..."];
   [self.view bringSubviewToFront:self.progressView];

}

//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"加载完成");
    [SVProgressHUD dismiss];
    //加载完成后隐藏progressView
    //    self.progressView.hidden = YES;
}

//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败");
    [SVProgressHUD dismiss];
    //加载失败同样需要隐藏progressView
  //  self.progressView.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

//页面跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    //允许页面跳转
//    NSLog(@"%@",navigationAction.request.URL);
    decisionHandler(WKNavigationActionPolicyAllow);
}


#pragma mark - Tool bar item action

- (void)goBackAction {
    if ([self.wkWebView canGoBack]) {
        [self.wkWebView goBack];
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


//- (void)dealloc {
//    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
//}





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
