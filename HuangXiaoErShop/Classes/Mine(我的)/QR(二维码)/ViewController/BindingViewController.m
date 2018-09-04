//
//  BindingViewController.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "BindingViewController.h"

@interface BindingViewController ()

@property (nonatomic, strong) UITextField *machineTF;

@end

@implementation BindingViewController

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
    
    UIView *nameView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    nameView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:nameView];
    
    UILabel *nameLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 100, 20)];
    nameLable.text = @"机具号";
    [nameView addSubview:nameLable];
    
    _machineTF = [[UITextField alloc]initWithFrame:CGRectMake(kScreenWidth * 0.6, 20, kScreenWidth * 0.35, 20)];
    _machineTF.placeholder = @"请输入机具号";
    _machineTF.textAlignment = NSTextAlignmentRight;
    [nameView addSubview:_machineTF];
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    submitButton.frame = CGRectMake(0, 70, kScreenWidth, 50);
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [submitButton setTintColor:kColor(255, 255, 255)];
    [submitButton setBackgroundColor:kColor(255, 210, 0)];
    [submitButton addTarget:self action:@selector(submitMachine) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
    
    
    // Do any additional setup after loading the view.
}

- (void)submitMachine{
    
    if (kStringIsEmpty(self.machineTF.text)) {
        [MBProgressHUD showError:@"机具号不能为空"];
        return;
    }else{
        
        [self uploadMessageToSerivesWithMachines:self.machineTF.text];
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
    
    self.machineTF.text = @"";
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
