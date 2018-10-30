//
//  LoginViewController.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/8/1.
//  Copyright © 2018年 aladdin. All rights reserved.
//
//750  1334
#import "LoginViewController.h"



static CGFloat const lineHeight = 0.8f;

@interface LoginViewController ()

@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UITextField *passWordTF;
@property (nonatomic, strong) UIButton *imageButton;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *signButton;
@property (nonatomic, strong) UIButton *forgetPassword;

@end

@implementation LoginViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatLoginView];
    
//    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
//    [manager startMonitoring];
//    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        NSLog(@"*********%ld",(long)status);
//        NSString *string = [NSString stringWithFormat:@"%ld",(long)status];
//        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//        [user setValue:string forKey:@"AFNetwork"];
//        [user synchronize];
//    }];

    
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
    // Do any additional setup after loading the view.
}

-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer{
    [self.view endEditing:YES];
}


- (void)creatLoginView {
    
    //logo
    self.logoView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight * 0.36)];
    self.logoView.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:self.logoView];
    
    //手机号
    self.phoneTF = [[UITextField alloc]initWithFrame:CGRectMake(kScreenWidth * 0.13, kScreenHeight * 0.36, kScreenWidth * 0.74, kScreenHeight * 0.076)];
    self.phoneTF.placeholder = @"请输入手机号";
    [self.view addSubview:self.phoneTF];
    
    UILabel *lineLable = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth * 0.13, CGRectGetMaxY(self.phoneTF.frame), kScreenWidth * 0.74, lineHeight)];
    lineLable.backgroundColor = kColor(240, 240, 240);
    [self.view addSubview:lineLable];
    
    //密码
    self.passWordTF = [[UITextField alloc]initWithFrame:CGRectMake(kScreenWidth * 0.13, kScreenHeight * 0.436, kScreenWidth * 0.5, kScreenHeight * 0.076)];
    self.passWordTF.placeholder = @"请输入密码";
    self.passWordTF.secureTextEntry = YES;
    [self.view addSubview:self.passWordTF];
    
    
    self.imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.imageButton.frame = CGRectMake(kScreenWidth * 0.75, CGRectGetHeight(self.passWordTF.frame) / 3 + kScreenHeight * 0.436, CGRectGetHeight(self.passWordTF.frame) / 3, CGRectGetHeight(self.passWordTF.frame) / 3);
    [self.imageButton setBackgroundImage:[UIImage imageNamed:@"passImage-1"] forState:UIControlStateNormal];
    [self.imageButton setTag:1000];
    [self.imageButton addTarget:self action:@selector(changeImageWithTag) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.imageButton];
    
    
    // 分割线
    UIView *line = [[UIView alloc] initWithFrame:(CGRectMake(kScreenWidth * 0.13, CGRectGetMaxY(self.passWordTF.frame), kScreenWidth * 0.74, lineHeight))];
    line.backgroundColor = kColor(240, 240, 240);
    [self.view addSubview:line];
    
    //登录
    self.loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.loginButton.frame = CGRectMake(kScreenWidth * 0.13, kScreenHeight * 0.574, kScreenWidth * 0.74, kScreenHeight * 0.067);
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginButton setTintColor:[UIColor blackColor]];
    
    [self.loginButton setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
    self.loginButton.layer.cornerRadius = kScreenHeight * 0.067 / 2;
    self.loginButton.layer.masksToBounds = YES;
    [self.loginButton addTarget:self action:@selector(handleUserLoginAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.loginButton];
    
    //成为商户
    self.signButton = [UIButton buttonWithType:UIButtonTypeCustom];

    
    
    
    
    
    //忘记密码
    
    
    
    
    
    
    
    if (!kStringIsEmpty(KUSERPHONE)) {
        self.phoneTF.text = KUSERPHONE;
    }
        if (!kStringIsEmpty(KUSERPASSWORD)) {
            self.passWordTF.text = KUSERPASSWORD;
    }
}

- (void)changeImageWithTag{
    [self.imageButton setBackgroundImage:[UIImage imageNamed:@"passImage"] forState:UIControlStateNormal];
    self.imageButton.tag = 1200;
    [self.imageButton addTarget:self action:@selector(changeImageWithChangeTag) forControlEvents:UIControlEventTouchUpInside];
    self.passWordTF.secureTextEntry = NO;
    
}
- (void)changeImageWithChangeTag{
    
    [self.imageButton setBackgroundImage:[UIImage imageNamed:@"passImage-1"] forState:UIControlStateNormal];
    self.imageButton.tag = 1000;
    [self.imageButton addTarget:self action:@selector(changeImageWithTag) forControlEvents:UIControlEventTouchUpInside];
    self.passWordTF.secureTextEntry = YES;
}

/** 处理用户登录事件 */
- (void)handleUserLoginAction:(UIButton *)sender {
    
    /** 判断手机号和密码格式 */
    if (![RandomClass checkTelNumber:self.phoneTF.text]) {
        [MBProgressHUD showError:@"请输入正确手机号"];
        return;
    }
    if (self.passWordTF.text.length == 0) {
        [MBProgressHUD showError:@"密码不能为空"];
        return;
    }
    if (self.passWordTF.text.length < 5) {
        [MBProgressHUD showError:@"密码格式有误，请重新输入"];
        return;
    }
    
    NSDictionary *parameter = @{
                                @"phone":self.phoneTF.text,
                                @"password":self.passWordTF.text
                                };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];

    [manager POST:[NSString stringWithFormat:@"%@/appcommercialUser/login",HXELOGIN] parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //    NSLog(@"%@",responseObject);
        
        if ([responseObject[@"status"] integerValue] == 200) {
           
            [MBProgressHUD showSuccess:@"登录成功"];
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setValue:self.phoneTF.text forKey:@"phone"];
            [user setValue:self.passWordTF.text forKey:@"password"];
            [user setValue:responseObject[@"data"] forKey:@"data"];
            [user synchronize];
            
            [[AppDelegate mainAppDelegate] showHomeView];
            
        }
        if([responseObject[@"status"] integerValue] == 400){
            [MBProgressHUD showError:responseObject[@"msg"]];
            
        }
        
    

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD showMessage:@"登录失败，请重新登录"];
        [[AppDelegate mainAppDelegate] showLoginView];
        
        if (error.code == -1) {
            [MBProgressHUD showError:@"未知网络地址"];
        }else if (error.code == -1001){
            [MBProgressHUD showError:@"请求超时"];
        }
    }];
    
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
