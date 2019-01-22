//
//  ForgetViewController.m
//  HuangXiaoErShop
//
//  Created by apple on 2019/1/14.
//  Copyright © 2019年 aladdin. All rights reserved.
//

#import "ForgetViewController.h"

@interface ForgetViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *FirstView;
@property (weak, nonatomic) IBOutlet UIView *SecondView;

@property (weak, nonatomic) IBOutlet UITextField *PhoneTF;
@property (weak, nonatomic) IBOutlet UITextField *CodeTF;
@property (weak, nonatomic) IBOutlet UITextField *NewPassWord;
@property (weak, nonatomic) IBOutlet UITextField *AgainPassWord;

@property (weak, nonatomic) IBOutlet UIButton *CodeBT;
@property (weak, nonatomic) IBOutlet UIButton *SubmitBT;

@property (nonatomic, strong) NSString *changePasswordToken;

@end

@implementation ForgetViewController

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
    
    self.navigationItem.title = @"重置密码";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21],NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
    
}
- (void)leftBarBtnClicked:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor(240, 240, 240);
    
    [self initView];
    // Do any additional setup after loading the view.
}

- (void)initView{
    
    
    self.FirstView.layer.masksToBounds = YES;
    self.FirstView.layer.cornerRadius = 8;
    
    self.SecondView.layer.masksToBounds = YES;
    self.SecondView.layer.cornerRadius = 8;
    

    [self.CodeBT setBackgroundColor:kColor(255, 210, 0)];
    self.CodeBT.layer.masksToBounds = YES;
    self.CodeBT.layer.cornerRadius = 20;
    [self.SubmitBT setBackgroundColor:kColor(255, 210, 0)];
    self.SubmitBT.layer.masksToBounds = YES;
    self.SubmitBT.layer.cornerRadius = 25;
    

    self.CodeTF.delegate = self;
    [self.CodeTF addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
}
#pragma mark 获取验证码
- (IBAction)GetCode:(UIButton *)sender {
    
    if (![RandomClass checkTelNumber:self.PhoneTF.text]) {
        [MBProgressHUD showError:@"请输入正确手机号"];
        return;
    }
    
    NSDictionary *parameter = @{
                                @"phone":self.PhoneTF.text,
                                };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];

    [manager POST:[NSString stringWithFormat:@"%@/sms/sms",HXELOGIN] parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      //  NSLog(@"%@",responseObject);
        if ([responseObject[@"status"] integerValue] == 200) {
            [MBProgressHUD showSuccess:responseObject[@"msg"]];
            [self timeReduce];
        }else{
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)timeReduce {
    
    __block NSInteger time = 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮的样式
                [self.CodeBT setTitle:@"重新发送" forState:UIControlStateNormal];
                [self.CodeBT setTitleColor:kColor(0, 0, 0) forState:UIControlStateNormal];
                [self.CodeBT setBackgroundColor:kColor(255, 210, 0)];
                self.CodeBT.userInteractionEnabled = YES;
            });
        }
        else {
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮显示读秒效果
                [self.CodeBT setTitle:[NSString stringWithFormat:@"%ds后重发", seconds] forState:UIControlStateNormal];
                [self.CodeBT setTitleColor:kColor(153, 153, 153) forState:UIControlStateNormal];
                [self.CodeBT setBackgroundColor:kColor(204, 204, 204)];
                self.CodeBT.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark 商户校验

- (void)textFieldDidEndEditing:(UITextField *)textField{
   // NSLog(@"%@",textField.text);
    
    if (textField.text.length != 4) {
        [MBProgressHUD showError:@"验证码长度为4位有效数字"];
        return;
    }
    
    
    NSDictionary *parameter = @{
                                @"phone":self.PhoneTF.text,
                                @"smsCode": textField.text
                                };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];

    [manager POST:@"http://bei.51hxe.com:9002/appcommercial/changePasswordSmsVerify" parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //    NSLog(@"%@",responseObject);
        
        if ([responseObject[@"status"] integerValue] == 200) {
            [MBProgressHUD showSuccess:responseObject[@"msg"]];
            self.changePasswordToken = responseObject[@"data"];
        }else{
            [MBProgressHUD showError:responseObject[@"msg"]];
            self.CodeTF.text = @"";
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}
#pragma mark 提交信息
- (IBAction)SubmitBT:(UIButton *)sender {
    if (![RandomClass checkTelNumber:self.PhoneTF.text]) {
        [MBProgressHUD showError:@"请输入正确手机号"];
        return;
    }
    
    if (kStringIsEmpty(self.CodeTF.text)) {
        [MBProgressHUD showError:@"验证码不能为空"];
        return;
    }
    
    if (kStringIsEmpty(self.NewPassWord.text)) {
        [MBProgressHUD showError:@"密码不能为空"];
        return;
    }
    
    if (kStringIsEmpty(self.AgainPassWord.text)) {
        [MBProgressHUD showError:@"密码不能为空"];
        return;
    }
    
    if (self.CodeTF.text.length != 4) {
        [MBProgressHUD showError:@"验证码长度错误"];
        return;
    }
    if (self.NewPassWord.text.length < 5 || self.AgainPassWord.text.length < 5) {
        [MBProgressHUD showError:@"密码长度不能小于5个字符"];
        return;
    }
    
    if (![self.NewPassWord.text isEqualToString:self.AgainPassWord.text]) {
        [MBProgressHUD showError:@"两次密码不一致,请重新输入"];
        return;
    }
    
    if (kStringIsEmpty(self.changePasswordToken)) {
        [MBProgressHUD showError:@"验证码验证失败"];
        self.CodeTF.text = @"";
        return;
    }
    NSDictionary *parameter = @{
                                @"changePasswordToken": self.changePasswordToken,
                                @"newPassword": self.NewPassWord.text
                                };
    NSLog(@"%@",parameter);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];

    [manager POST:@"http://bei.51hxe.com:9002/appcommercial/commercialChangePassword" parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     //   NSLog(@"%@",responseObject);
        if ([responseObject[@"status"] integerValue] == 200) {
            [MBProgressHUD showSuccess:responseObject[@"msg"]];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
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
