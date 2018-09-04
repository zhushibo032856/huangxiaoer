//
//  AddMachinesViewController.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "AddMachinesViewController.h"
#import "BRTextField.h"

@interface AddMachinesViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *viewOne;
@property (nonatomic, strong) UIView *viewTwo;
@property (nonatomic, strong) UIView *viewThree;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UITextField *numberTF;//打票机编号

@property (nonatomic, strong) BRTextField *categoryTF;
@property (nonatomic, strong) BRTextField *nameTF;
@property (nonatomic, strong) BRTextField *pinPaiTF;


@end

@implementation AddMachinesViewController

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
    
    //   [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"backcolor"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationItem.title = @"票机管理";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
    
}
- (void)leftBarBtnClicked:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor(245, 245, 245);
    
    [self creatAutoLayout];
    
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
    
    // Do any additional setup after loading the view.
}
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer{
    [self.view endEditing:YES];
}

- (void)creatAutoLayout{
    
    
    self.viewOne = [[UIView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 80)];
    self.viewOne.backgroundColor = [UIColor whiteColor];
    UILabel *shopMessage = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 80, 20)];
    shopMessage.text = @"品牌信息";
    shopMessage.textColor = kColor(153, 153, 153);
    shopMessage.font = [UIFont systemFontOfSize:13];
    [self.viewOne addSubview:shopMessage];
    
    UILabel *numberLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 35, 80, 40)];
    numberLable.text = @"品牌名称";
    numberLable.font = [UIFont systemFontOfSize:15];
    [self.viewOne addSubview:numberLable];
    
    [self.viewOne addSubview:self.pinPaiTF];
    [self setupPinPaiTF:self.viewOne];
    [self.view addSubview:self.viewOne];
    
    
    self.viewTwo = [[UIView alloc]initWithFrame:CGRectMake(10, 100, kScreenWidth - 20, 205)];
    self.viewTwo.backgroundColor = [UIColor whiteColor];
    
    UILabel *piaojiMessage = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 80, 20)];
    piaojiMessage.font = [UIFont systemFontOfSize:13];
    piaojiMessage.text = @"票机信息";
    piaojiMessage.textColor = kColor(153, 153, 153);
    [self.viewTwo addSubview:piaojiMessage];
    
    UILabel *category = [[UILabel alloc]initWithFrame:CGRectMake(10, 35, 80, 40)];
    category.text = @"类型";
    category.font = [UIFont systemFontOfSize:15];
    [self.viewTwo addSubview:category];
    [self setupCategoryTF:self.viewTwo];
    [self.viewTwo addSubview:self.categoryTF];
    
    
    
    UILabel *lineLable1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 85, kScreenWidth - 40, 1)];
    lineLable1.backgroundColor = kColor(240, 240, 240);
    [self.viewTwo addSubview:lineLable1];
    
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(10, 95, 80, 40)];
    name.text = @"名称";
    name.font = [UIFont systemFontOfSize:15];
    [self.viewTwo addSubview:name];
    
    //   self.nameTF = [[BRTextField alloc]initWithFrame:CGRectMake(kScreenWidth * 0.7, 95, kScreenWidth * 0.25, 40)];
    [self setupNameTF:self.viewTwo];
    [self.viewTwo addSubview:self.nameTF];
    
    
    
    UILabel *lineLable2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 145, kScreenWidth - 40, 1)];
    lineLable2.backgroundColor = kColor(240, 240, 240);
    [self.viewTwo addSubview:lineLable2];
    
    UILabel *number = [[UILabel alloc]initWithFrame:CGRectMake(10, 155, 80, 40)];
    number.text = @"编号";
    number.font = [UIFont systemFontOfSize:15];
    [self.viewTwo addSubview:number];
    
    self.numberTF = [[UITextField alloc]initWithFrame:CGRectMake(kScreenWidth * 0.5 - 20, 155, kScreenWidth * 0.5 + 10, 40)];
    self.numberTF.placeholder = @"请输入打票机编号";
    self.numberTF.font = [UIFont systemFontOfSize:15];
    self.numberTF.textAlignment = NSTextAlignmentCenter;
    [self.viewTwo addSubview:self.numberTF];
    
    [self.view addSubview:self.viewTwo];
    
    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    self.button.frame = CGRectMake(10, 315, kScreenWidth - 20, 40);
    [self.button setTitle:@"绑定" forState:UIControlStateNormal];
    [self.button setBackgroundColor:kColor(255, 210, 0)];
    self.button.layer.masksToBounds = YES;
    self.button.layer.cornerRadius = 5;
    self.button.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.button addTarget:self action:@selector(addData) forControlEvents:UIControlEventTouchUpInside];
    self.button.tintColor = [UIColor whiteColor];
    
    [self.view addSubview:self.button];
}

- (BRTextField *)getTextField:(UIView *)view{
    
    BRTextField *textField = [[BRTextField alloc]initWithFrame:CGRectMake(kScreenWidth * 0.6, 35, kScreenWidth * 0.35, 40)];
    textField.backgroundColor = [UIColor clearColor];
    textField.font = [UIFont systemFontOfSize:15];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.delegate = self;
    [view addSubview:textField];
    return textField;
}

- (BRTextField *)getTextFieldName:(UIView *)view{
    
    BRTextField *textField = [[BRTextField alloc]initWithFrame:CGRectMake(kScreenWidth * 0.6, 95, kScreenWidth * 0.35, 40)];
    textField.backgroundColor = [UIColor clearColor];
    textField.font = [UIFont systemFontOfSize:15];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.delegate = self;
    [view addSubview:textField];
    return textField;
}
- (BRTextField *)getTextFieldPinPai:(UIView *)view{
    
    BRTextField *textField = [[BRTextField alloc]initWithFrame:CGRectMake(kScreenWidth * 0.6, 35, kScreenWidth * 0.35, 40)];
    textField.backgroundColor = [UIColor clearColor];
    textField.font = [UIFont systemFontOfSize:15];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.delegate = self;
    [view addSubview:textField];
    return textField;
}

- (void)setupCategoryTF:(UIView *)view{
    if (!_categoryTF) {
        _categoryTF = [self getTextField:view];
        _categoryTF.placeholder = @"请选择类型";
        __weak typeof(self) weakSelf = self;
        _categoryTF.tapAcitonBlock = ^{
            [BRStringPickerView showStringPickerWithTitle:@"类型名称" dataSource:@[@"GPRS"] defaultSelValue:@"GPRS" isAutoSelect:YES resultBlock:^(id selectValue) {
                weakSelf.categoryTF.text = selectValue;
            }];
        };
    }
    
}

- (void)setupNameTF:(UIView *)view{
    if (!_nameTF) {
        _nameTF = [self getTextFieldName:view];
        _nameTF.placeholder = @"请选择名称";
        __weak typeof(self) weakSelf = self;
        _nameTF.tapAcitonBlock = ^{
            [BRStringPickerView showStringPickerWithTitle:@"名称" dataSource:@[@"收银", @"后厨"] defaultSelValue:@"收银" isAutoSelect:YES resultBlock:^(id selectValue) {
                weakSelf.nameTF.text = selectValue;
            }];
        };
    }
}

- (void)setupPinPaiTF:(UIView *)view{
    if (!_pinPaiTF) {
        _pinPaiTF = [self getTextFieldPinPai:view];
        _pinPaiTF.placeholder = @"请选择品牌名称";
        __weak typeof(self) weakSelf = self;
        _pinPaiTF.tapAcitonBlock = ^{
            [BRStringPickerView showStringPickerWithTitle:@"名称" dataSource:@[@"风驰", @"飞印"] defaultSelValue:@"风驰" isAutoSelect:YES resultBlock:^(id selectValue) {
                weakSelf.pinPaiTF.text = selectValue;
            }];
        };
    }
}


/** 添加打印机请求 */
- (void)addData{
    
    if (kStringIsEmpty(self.numberTF.text)) {
        [MBProgressHUD showError:@"打印机编号不能为空"];
        return;
    }
    NSString *categoryString = [NSString string];
    if ([self.categoryTF.text  isEqual: @"蓝牙"]) {
        categoryString = [NSString stringWithFormat:@"LY"];
    }else{
        categoryString = [NSString stringWithFormat:@"GP"];
    }
    
    NSString *nameString = [NSString string];
    if ([self.nameTF.text isEqualToString:@"收银"]) {
        nameString = [NSString stringWithFormat:@"SY"];
    }else{
        nameString = [NSString stringWithFormat:@"HC"];
    }
    NSString *pinPaiString = [NSString string];
    if ([self.pinPaiTF.text isEqualToString:@"风驰"]) {
        pinPaiString = [NSString stringWithFormat:@"FC"];
    }else{
        pinPaiString = [NSString stringWithFormat:@"FY"];
    }
    
    
    NSDictionary *partner = @{
                              @"deviceNo":self.numberTF.text,
                              @"brand": pinPaiString,
                              @"name": nameString,
                              @"token": KUSERID,
                              @"type": categoryString
                              };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html", nil];
    
    [manager POST:[NSString stringWithFormat:@"%@/appprint/bind",HXECOMMEN] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //   NSLog(@"%@",responseObject);
        
        if ([responseObject[@"status"] integerValue] == 200) {
            [MBProgressHUD showSuccess:responseObject[@"msg"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"notiEdit" object:nil];
        }else{
            [MBProgressHUD showError:responseObject[@"msg"]];
            
        }
        
        //    NSLog(@"%@",partner);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    self.pinPaiTF.text = @"";
    self.numberTF.text = @"";
    self.categoryTF.text = @"";
    self.nameTF.text = @"";
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
