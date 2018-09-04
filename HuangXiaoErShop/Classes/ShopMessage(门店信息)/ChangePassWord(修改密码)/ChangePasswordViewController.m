//
//  ChangePasswordViewController.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()

@property (nonatomic, strong) UITextField *passWord;
@property (nonatomic, strong) UITextField *oldPassWord;
@property (nonatomic, strong) UIButton *submitBT;

@end

@implementation ChangePasswordViewController

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
    
    self.navigationItem.title = @"修改密码";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
}
- (void)leftBarBtnClicked:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatAutoLayout];
    // Do any additional setup after loading the view.
}

- (void)creatAutoLayout{
    
    self.passWord = [[UITextField alloc]initWithFrame:CGRectMake(kScreenWidth * 0.1, 30, kScreenWidth * 0.8, 30)];
    self.passWord.secureTextEntry = YES;
    self.passWord.placeholder = @"请输入新密码";
    [self.view addSubview:self.passWord];
    
    self.oldPassWord = [[UITextField alloc]initWithFrame:CGRectMake(kScreenWidth * 0.1, 80, kScreenWidth * 0.8, 30)];
    self.oldPassWord.placeholder = @"请输入旧密码";
    [self.view addSubview:self.oldPassWord];
    
    for (int i = 0; i < 2; i ++) {
        UILabel *lineLable = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth * 0.1, 70 + 50 * i, kScreenWidth * 0.8, 1)];
        lineLable.backgroundColor = kColor(210, 210, 210);
        [self.view addSubview:lineLable];
    }
    
    self.submitBT = [UIButton buttonWithType:UIButtonTypeSystem];
    self.submitBT.frame = CGRectMake(kScreenWidth * 0.25, 136, kScreenWidth * 0.5, 40);
    self.submitBT.layer.cornerRadius = 5;
    self.submitBT.layer.masksToBounds = YES;
    [self.submitBT setTitle:@"提交" forState:UIControlStateNormal];
    self.submitBT.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.submitBT setTintColor:[UIColor whiteColor]];
    self.submitBT.backgroundColor = kColor(255, 230, 0);
    [self.submitBT addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.submitBT];
    
}

- (void)submit{
    
    if (![self.oldPassWord.text isEqualToString:KUSERPASSWORD]) {
        [MBProgressHUD showError:@"旧密码输入错误"];
        return;
    }
    if (self.passWord.text.length == 0) {
        [MBProgressHUD showError:@"密码不能为空"];
        return;
    }
    if (self.passWord.text.length < 5) {
        [MBProgressHUD showError:@"密码格式有误，请重新输入"];
        return;
    }
    [self submitWithPassword:self.passWord.text OldPassword:self.oldPassWord.text];
    
}

- (void)submitWithPassword:(NSString *)password
               OldPassword:(NSString *)oldPassword{
    
    NSDictionary *partner = @{
                              @"newPassWord": password,
                              @"oldPassWord": oldPassword,
                              @"token": KUSERID
                              };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"image/jpeg", @"image/png",@"text/json",@"text/plain", nil];
    [manager POST:[NSString stringWithFormat:@"%@/appcommercial/updatePassWord",HXECOMMEN] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // NSLog(@"%@",responseObject);
        if ([responseObject[@"status"] integerValue] == 200) {
            [MBProgressHUD showSuccess:@"修改成功"];
            
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setValue:self.passWord.text forKey:@"password"];
            [user synchronize];
 //           [[AppDelegate mainAppDelegate] showLoginView];
        }else{
            [MBProgressHUD showSuccess:@"修改失败"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
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
