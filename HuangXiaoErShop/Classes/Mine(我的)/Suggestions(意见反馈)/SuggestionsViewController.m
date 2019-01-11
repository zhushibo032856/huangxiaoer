//
//  SuggestionsViewController.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "SuggestionsViewController.h"

@interface SuggestionsViewController ()

@property (nonatomic, strong) UIView *suggestView;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UITextView *suggestTF;

@end

@implementation SuggestionsViewController

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
    self.navigationItem.title = @"意见反馈";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
    
}
- (void)leftBarBtnClicked:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor(240, 240, 240);
    
    self.suggestView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 230)];
    self.suggestView.backgroundColor = [UIColor whiteColor];
    self.suggestView.layer.masksToBounds = YES;
    self.suggestView.layer.cornerRadius = 8;
    [self.view addSubview:self.suggestView];
    
//    UILabel *phoneLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 30)];
//    phoneLable.text = @"客服热线";
//    phoneLable.font = [UIFont systemFontOfSize:15];
//    [self.suggestView addSubview:phoneLable];
//
//    UIImageView *phoneImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth * 0.55, 17.5, 15, 15)];
//    [phoneImage setImage:[UIImage imageNamed:@"callPhone"]];
//    [self.suggestView addSubview:phoneImage];
//
//    UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    phoneButton.frame = CGRectMake(CGRectGetMaxX(phoneImage.frame) , 10, kScreenWidth * 0.35, 30);
//    [phoneButton setTitle:@"0371-56033072" forState:UIControlStateNormal];
//    [phoneButton setTintColor:[UIColor blueColor]];
//    phoneButton.titleLabel.font = [UIFont systemFontOfSize:15];
//    [phoneButton addTarget:self action:@selector(CallPhoneNumber) forControlEvents:UIControlEventTouchUpInside];
//    [self.suggestView addSubview:phoneButton];
//
//    UILabel *lineLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, kScreenWidth - 40, 1)];
//    lineLable.backgroundColor = kColor(240, 240, 240);
//    [self.suggestView addSubview:lineLable];
//
//    UILabel *feedbackLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, 100, 20)];
//    feedbackLable.text = @"在线反馈";
//    // feedbackLable.textColor = kColor(150, 150, 150);
//    feedbackLable.font = [UIFont systemFontOfSize:15];
//    [self.suggestView addSubview:feedbackLable];
    
    self.suggestTF = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth - 40, 160)];
    self.suggestTF.font = [UIFont systemFontOfSize:17];
    self.suggestTF.layer.masksToBounds = YES;
    self.suggestTF.layer.cornerRadius = 8;
    self.suggestTF.placeholder = @"请输入您的意见和建议(100字)";
    self.suggestTF.backgroundColor = kColor(240, 240, 240);
    self.suggestTF.limitLength = @100;
    [self.suggestView addSubview:self.suggestTF];
    
    self.submitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.submitButton.frame = CGRectMake(30, 180, kScreenWidth - 80, 40);
    [self.submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [self.submitButton setTintColor:[UIColor blackColor]];
    self.submitButton.layer.masksToBounds = YES;
    self.submitButton.layer.cornerRadius = 20;
    self.submitButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.submitButton addTarget:self action:@selector(submitMessage) forControlEvents:UIControlEventTouchUpInside];
    self.submitButton.backgroundColor = kColor(255, 210, 0);
    [self.suggestView addSubview:self.submitButton];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
    
    
    // Do any additional setup after loading the view.
}
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer{
    [self.view endEditing:YES];
}

- (void)submitMessage{
    if (kStringIsEmpty(self.suggestTF.text)) {
        [MBProgressHUD showError:@"不能为空哦!!!"];
    }else{
        [self submitMessageWithContent:self.suggestTF.text];
    }
}

- (void)submitMessageWithContent:(NSString *)content{
    
    NSDictionary *partner = @{
                              @"content": content,
                              @"token": KUSERID,
                              @"userId": KUSERSHOPID,
                              @"userPhone": KUSERPHONE,
                              @"userType": @"3",
                              @"userUserName": KUSERUSERNAME
                              };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html", nil];
    [manager POST:[NSString stringWithFormat:@"%@/appuserbackmsg/adduserbackmsg",HXECOMMEN] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"status"] integerValue] == 200) {
            [MBProgressHUD showSuccess:responseObject[@"msg"]];
        }else{
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showError:@"提交反馈失败，请重试"];
    }];
    
    
}


//拨打电话
- (void)CallPhoneNumber{
    
    NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel:%@",@"0371-56033072"];
    //   NSLog(@"%@",phone);
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
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
