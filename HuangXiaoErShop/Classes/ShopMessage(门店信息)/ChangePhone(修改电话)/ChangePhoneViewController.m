//
//  ChangePhoneViewController.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "ChangePhoneViewController.h"

@interface ChangePhoneViewController ()

@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UITextField *codeTF;

@property (nonatomic, strong) UIButton *codeTips;
@property (nonatomic, strong) UIButton *codeBtn;

@property (nonatomic, strong) UIButton *submitBtn;

@end

@implementation ChangePhoneViewController

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
    
    self.navigationItem.title = @"修改手机号";
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
    
    self.phoneTF = [[UITextField alloc]initWithFrame:CGRectMake(kScreenWidth * 0.1, 30, kScreenWidth * 0.8, 30)];
    self.phoneTF.placeholder = @"请输入手机号";
    self.phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:self.phoneTF];
    
    self.codeTF = [[UITextField alloc]initWithFrame:CGRectMake(kScreenWidth * 0.1, 80, kScreenWidth * 0.8, 30)];
    self.codeTF.placeholder = @"验证码";
    self.codeTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:self.codeTF];
    
    for (int i = 0; i < 2; i ++) {
        UILabel *lineLable = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth * 0.1, 70 + 50 * i, kScreenWidth * 0.8, 1)];
        lineLable.backgroundColor = kColor(210, 210, 210);
        [self.view addSubview:lineLable];
    }
    
    self.codeTips = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.codeTips.size = CGSizeMake(70 * ScaleNumberWidth, 20 * ScaleNumberHeight);
    self.codeTips.center = CGPointMake(CGRectGetMaxX(self.codeTF.frame) + self.codeTips.width / 2, self.codeTF.centerY);
    self.codeTips.userInteractionEnabled = NO;
    [self.codeTips setImage:[UIImage imageNamed:@"l_hint"] forState:(UIControlStateNormal)];
    [self.codeTips setTitle:@"验证码错误" forState:(UIControlStateNormal)];
    [self.codeTips setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    [self.codeTips.titleLabel setFont:FontType_Title(10.5f)];
    [self.codeTips setHidden:YES];
    [self.view addSubview:self.codeTips];
    
    self.codeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.codeBtn.frame = CGRectMake(CGRectGetMaxX(self.phoneTF.frame) - 80 * ScaleNumberWidth, CGRectGetMinY(self.codeTF.frame), 90 * ScaleNumberWidth, CGRectGetHeight(self.codeTF.frame));
    [self.codeBtn setTitleColor:kGreenColor forState:(UIControlStateNormal)];
    [self.codeBtn.titleLabel setFont:FontType_Title(12.5f)];
    [self.codeBtn setTitle:@"获取验证码" forState:(UIControlStateNormal)];
    [self.codeBtn addTarget:self action:@selector(getCodeAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.codeBtn];
    
    self.submitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.submitBtn.frame = CGRectMake(kScreenWidth * 0.25, 136, kScreenWidth * 0.5, 40);
    self.submitBtn.layer.cornerRadius = 5;
    self.submitBtn.layer.masksToBounds = YES;
    [self.submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    self.submitBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.submitBtn setTintColor:[UIColor whiteColor]];
    self.submitBtn.backgroundColor = kColor(255, 230, 0);
    [self.submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.submitBtn];
    
}

- (void)getCodeAction:(UIButton *)sender{
    
    self.codeTips.hidden = YES;
    
    if (![RandomClass checkTelNumber:self.phoneTF.text]) {
        [MBProgressHUD showError:@"请输入正确手机号"];
        return;
    }
    NSDictionary *partner = @{
                              @"phone": self.phoneTF.text
                              };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"image/jpeg", @"image/png",@"text/json",@"text/plain", nil];
    
    [manager POST:[NSString stringWithFormat:@"%@/sms/sms",HXELOGIN] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //  NSLog(@"%@",responseObject);
        if ([responseObject[@"status"] integerValue] == 200) {
            [MBProgressHUD showSuccess:responseObject[@"msg"]];
            [self timeReduce];
        }else{
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showError:@"验证码获取失败"];
    }];
    
    
}

- (void)submit{
    
    [self submitWithPhone:self.phoneTF.text Code:self.codeTF.text];
}

- (void)submitWithPhone:(NSString *)phone
                   Code:(NSString *)code{
    
    NSDictionary *partner = @{
                              @"code": code,
                              @"phone": phone,
                              @"token": KUSERID
                              };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"image/jpeg", @"image/png",@"text/json",@"text/plain", nil];
    
    [manager POST:[NSString stringWithFormat:@"%@/appcommercial/updatePhone",HXECOMMEN] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //  NSLog(@"%@",responseObject);
        if ([responseObject[@"status"] integerValue] == 200) {
            
            [MBProgressHUD showSuccess:responseObject[@"msg"]];
            
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setValue:self.phoneTF.text forKey:@"phone"];
            [user synchronize];
 //           [[AppDelegate mainAppDelegate] showLoginView];
        }else{
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
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
                [self.codeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                [self.codeBtn setTitleColor:kGreenColor forState:UIControlStateNormal];
                self.codeBtn.userInteractionEnabled = YES;
            });
        }
        else {
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮显示读秒效果
                [self.codeBtn setTitle:[NSString stringWithFormat:@"%ds后重发", seconds] forState:UIControlStateNormal];
                [self.codeBtn setTitleColor:kGreenColor forState:UIControlStateNormal];
                self.codeBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
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
