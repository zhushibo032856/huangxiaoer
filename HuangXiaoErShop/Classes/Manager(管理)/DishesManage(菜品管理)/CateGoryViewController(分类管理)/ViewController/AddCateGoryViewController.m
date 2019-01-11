//
//  AddCateGoryViewController.m
//  HXEshop
//
//  Created by apple on 2018/3/27.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "AddCateGoryViewController.h"
#import "DishesManagerViewController.h"

@interface AddCateGoryViewController ()

@property (nonatomic, strong) UIView *addView;
@property (nonatomic, strong) UIButton *keepButton;
@property (nonatomic, strong) UITextField *keepTF;

@end

@implementation AddCateGoryViewController

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
    
  //  [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"backcolor"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationItem.title = @"添加分类";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
    
}
- (void)leftBarBtnClicked:(UIButton *)btn
{
    for (UIViewController *controlle in self.navigationController.viewControllers) {
        if ([controlle isKindOfClass:[DishesManagerViewController class]]) {
            [self.navigationController popToViewController:controlle animated:YES];
        }
    }
 //   [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor(240, 240, 240);
    
    self.addView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 50)];
    self.addView.backgroundColor = [UIColor whiteColor];
    self.addView.layer.masksToBounds = YES;
    self.addView.layer.cornerRadius = 8;
    [self.view addSubview:self.addView];
    
    UILabel *nameLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 150, 30)];
    nameLable.text = @"品类名称";
    [self.addView addSubview:nameLable];
    
    self.keepTF = [[UITextField alloc]initWithFrame:CGRectMake(kScreenWidth * 0.5, 10, kScreenWidth * 0.4, 30)];
    self.keepTF.placeholder = @"请输入品类名称";
    [self.addView addSubview:self.keepTF];
    
    self.keepButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.keepButton.layer.masksToBounds = YES;
    self.keepButton.layer.cornerRadius = 8;
    self.keepButton.frame = CGRectMake(10, 70, kScreenWidth - 20, 50);
    [self.keepButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.keepButton setBackgroundColor:[UIColor whiteColor]];
    [self.keepButton setTintColor:[UIColor blackColor]];
    [self.keepButton addTarget:self action:@selector(KeepButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.keepButton];
    
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
    // Do any additional setup after loading the view.
}

-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer{
    [self.view endEditing:YES];
}

- (void)KeepButton:(UIButton *)sender{
    
    if (kStringIsEmpty(self.keepTF.text)) {
        [MBProgressHUD showError:@"分类名不能为空"];
    }else{
        [self addCategory:self.keepTF.text];
    }

}

- (void)addCategory:(NSString *)categoryName{
    
    
    
    NSDictionary *partner = @{
                              @"name": categoryName,
                              @"token": KUSERID
                              };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    
    [manager POST:[NSString stringWithFormat:@"%@/appproduct/category/add",HXECOMMEN] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
            NSLog(@"%@",responseObject);
        if ([responseObject[@"status"] integerValue] == 200) {
            [MBProgressHUD showSuccess:@"添加成功"];

            [[NSNotificationCenter defaultCenter] postNotificationName:@"notiEdit" object:nil];
        }else
            [MBProgressHUD showError:@"添加失败"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    //提交之后置空输入框
    self.keepTF.text = @"";
    
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
