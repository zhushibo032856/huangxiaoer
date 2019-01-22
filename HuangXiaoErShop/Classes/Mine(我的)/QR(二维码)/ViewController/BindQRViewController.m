//
//  BindQRViewController.m
//  HuangXiaoErShop
//
//  Created by apple on 2019/1/22.
//  Copyright © 2019年 aladdin. All rights reserved.
//

#import "BindQRViewController.h"

@interface BindQRViewController ()
@property (weak, nonatomic) IBOutlet UITextField *MachineTF;
@property (weak, nonatomic) IBOutlet UIView *BackView;
@property (weak, nonatomic) IBOutlet UIButton *SubmitBT;

@end

@implementation BindQRViewController

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
    
    //
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"backcolor"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationItem.title = @"绑定机具号";
    
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
    
    self.SubmitBT.layer.masksToBounds = YES;
    self.SubmitBT.layer.cornerRadius = 25;
    self.SubmitBT.backgroundColor = kColor(255, 210, 0);
    
}
- (IBAction)SubmitMachine:(UIButton *)sender {
    
    if (kStringIsEmpty(self.MachineTF.text)) {
        [MBProgressHUD showError:@"机具号不能为空"];
        return;
    }else{
        
        [self uploadMessageToSerivesWithMachines:self.MachineTF.text];
    }
}
- (void)uploadMessageToSerivesWithMachines:(NSString *)machines{
    
    NSDictionary *partner = @{
                              @"machineNum": machines,
                              @"sys_user_id": KUSERSHOPID,
                              @"token": KUSERID
                              };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html", nil];
    
    [manager POST:[NSString stringWithFormat:@"%@/appcommercial/addmachine",HXECOMMEN] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        if ([responseObject[@"status"] integerValue] == 200) {
            [MBProgressHUD showSuccess:@"提交成功"];
        }else{
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    self.MachineTF.text = @"";
}
@end
