//
//  EditAliPayViewController.m
//  HuangXiaoErShop
//
//  Created by apple on 2019/1/23.
//  Copyright © 2019年 aladdin. All rights reserved.
//

#import "EditAliPayViewController.h"

@interface EditAliPayViewController ()
@property (weak, nonatomic) IBOutlet UIView *BackView;

@property (weak, nonatomic) IBOutlet UITextField *NumberTF;
@property (weak, nonatomic) IBOutlet UITextField *NameTF;
@property (weak, nonatomic) IBOutlet UIButton *SubmitBT;

@end

@implementation EditAliPayViewController
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
    
    self.navigationItem.title = @"修改支付宝";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
    
}
- (void)leftBarBtnClicked:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColor(240, 240, 240);
    [self initView];
    // Do any additional setup after loading the view from its nib.
}

- (void)initView{
    
    self.BackView.layer.masksToBounds = YES;
    self.BackView.layer.cornerRadius = 8;
    
    [self.SubmitBT setBackgroundColor:kColor(255, 210, 0)];
    self.SubmitBT.layer.masksToBounds = YES;
    self.SubmitBT.layer.cornerRadius = 25;
    
    self.NumberTF.text = self.model.payeeAccount;
    self.NameTF.text = self.model.trueName;
    
}

- (IBAction)SubmitData:(UIButton *)sender {
    
    if (kStringIsEmpty(self.NameTF.text)) {
        [MBProgressHUD showError:@"请填写姓名"];
        return;
    }
    if (kStringIsEmpty(self.NumberTF.text)) {
        [MBProgressHUD showError:@"请填写账号"];
        return;
    }
    
    [self requestDataWithCount:self.NumberTF.text Name:self.NameTF.text];
    
}


- (void)requestDataWithCount:(NSString *)count
                        Name:(NSString *)name{
    
    NSDictionary *partner = @{
                              @"payeeAccount": count,
                              @"sysUserId": KUSERSHOPID,
                              @"token": KUSERID,
                              @"trueName": name
                              };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //@"http://bei.51hxe.com:9002/appcommercial/updateUserAlipay"
    [manager POST:[NSString stringWithFormat:@"%@/appcommercial/updateUserAlipay",HXECOMMEN] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      //  NSLog(@"%@",responseObject);
        if ([responseObject[@"status"] integerValue] == 200) {
            [MBProgressHUD showSuccess:responseObject[@"msg"]];
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
