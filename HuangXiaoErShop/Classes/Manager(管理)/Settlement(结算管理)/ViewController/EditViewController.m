//
//  EditViewController.m
//  HXEshop
//
//  Created by apple on 2018/4/9.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "EditViewController.h"
#import "BRTextField.h"
#import "ProvinceModel.h"
#import "CityModel.h"
#import "BankModel.h"
#import "ChildBankModel.h"

@interface EditViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *addView;
@property (nonatomic, strong) UIButton *submitButton;//提交按钮
@property (nonatomic, strong) UILabel *lineLable;
@property (nonatomic, strong) BRTextField *provinceTF;//省
@property (nonatomic, strong) BRTextField *cityTF;//市区
@property (nonatomic, strong) BRTextField *bankTF;//银行
@property (nonatomic, strong) BRTextField *childBankTF;//支行
@property (nonatomic, strong) BRTextField *accountTypeTF;//账户类型
@property (nonatomic, strong) UITextField *bankNumberTF;//银行卡号
@property (nonatomic, strong) UITextField *nameTF;//姓名
@property (nonatomic, strong) UIImageView *imageFour;
@property (nonatomic, strong) UIImageView *imageThree;

@property (nonatomic, strong) NSMutableArray *provinceArr;
@property (nonatomic, strong) NSMutableArray *cityArr;
@property (nonatomic, strong) NSMutableArray *bankArr;
@property (nonatomic, strong) NSMutableArray *childBankArr;

@property (nonatomic, strong) NSMutableDictionary *provinceDic;
@property (nonatomic, strong) NSMutableDictionary *cityDic;
@property (nonatomic, strong) NSMutableDictionary *bankDic;
@property (nonatomic, strong) NSMutableDictionary *childBankDic;

@end

@implementation EditViewController

- (NSMutableArray *)provinceArr{
    if (!_provinceArr) {
        _provinceArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _provinceArr;
}
- (NSMutableArray *)cityArr{
    if (!_cityArr) {
        _cityArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _cityArr;
}
- (NSMutableArray *)bankArr{
    if (!_bankArr) {
        _bankArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _bankArr;
}
- (NSMutableArray *)childBankArr{
    if (!_childBankArr) {
        _childBankArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _childBankArr;
}

- (NSMutableDictionary *)provinceDic{
    if (!_provinceDic) {
        _provinceDic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _provinceDic;
}

- (NSMutableDictionary *)cityDic{
    if (!_cityDic) {
        _cityDic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _cityDic;
}

- (NSMutableDictionary *)bankDic{
    if (!_bankDic) {
        _bankDic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _bankDic;}

- (NSMutableDictionary *)childBankDic{
    if (!_childBankDic) {
        _childBankDic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _childBankDic;
}

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
    
  //  [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"backcolor"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationItem.title = @"修改账户信息";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
    
}
- (void)leftBarBtnClicked:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColor(240, 240, 240);
    
//    UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.frame];
//    NSString *string = [NSString stringWithFormat:@"http://51hxe.com/hxeweb/shanghudemo.html?id=%@&token=%@",KUSERSHOPID,KUSERID];
//    NSURL *url = [NSURL URLWithString:string];
//    NSLog(@"%@",url);
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [webView loadRequest:request];
//    [self.view addSubview:webView];
    [self creatAutoLayout];
    
    [self getDataForProvince];
    
    [self getDataForBank];
    // Do any additional setup after loading the view.
}

- (void)creatAutoLayout{
    self.addView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 300)];
    self.addView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.addView];
    
    UILabel *messageLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 30)];
    messageLable.text = @"账户信息";
    [messageLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    messageLable.textColor = [UIColor lightGrayColor];
    [self.addView addSubview:messageLable];
    
    [self.addView addSubview:self.accountTypeTF];
    self.accountTypeTF.text = @"2222222";
    [self setupAccontTF:self.addView];
    
    //地区
    UILabel *areaLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, 100, 30)];
    areaLable.text = @"地区";
    areaLable.textColor = kColor(150, 150, 150);
    [areaLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    [self.addView addSubview:areaLable];
    
    _imageFour = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth * 0.55, CGRectGetMaxY(messageLable.frame) + 25, 20, 20)];
    [_imageFour setImage:[UIImage imageNamed:@"pull-down"]];
    [self.addView addSubview:_imageFour];
    
    _imageThree = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth * 0.9, CGRectGetMaxY(messageLable.frame) + 25, 20, 20)];
    [_imageThree setImage:[UIImage imageNamed:@"pull-down"]];
    [self.addView addSubview:_imageThree];
    
    //银行
    UILabel *bankLable = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(areaLable.frame) + 20, 100, 30)];
    bankLable.text = @"选择银行";
    bankLable.textColor = kColor(150, 150, 150);
    [bankLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    [self.addView addSubview:bankLable];
    
    UIImageView *imageOne = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth * 0.9, CGRectGetMaxY(areaLable.frame) + 25, 20, 20)];
    [imageOne setImage:[UIImage imageNamed:@"pull-down"]];
    [self.addView addSubview:imageOne];
    
    //支行
    UILabel *childBankLable = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(bankLable.frame) + 20, 100, 30)];
    childBankLable.text = @"所属支行";
    childBankLable.textColor = kColor(150, 150, 150);
    [childBankLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    [self.addView addSubview:childBankLable];
    
    UIImageView *imageTwo = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth * 0.9, CGRectGetMaxY(bankLable.frame) + 25, 20, 20)];
    [imageTwo setImage:[UIImage imageNamed:@"pull-down"]];
    [self.addView addSubview:imageTwo];
    
    
    //银行卡号
    UILabel *bankNumberLable = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(childBankLable.frame) + 20, 100, 30)];
    bankNumberLable.text = @"银行卡号";
    bankNumberLable.textColor = kColor(150, 150, 150);
    [bankNumberLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    [self.addView addSubview:bankNumberLable];
    
    self.bankNumberTF = [[UITextField alloc]initWithFrame:CGRectMake(120, CGRectGetMaxY(childBankLable.frame) + 20, kScreenWidth - 170, 30)];
    self.bankNumberTF.font = [UIFont systemFontOfSize:15];
    self.bankNumberTF.placeholder = @"请输入银行卡号";
    [self.addView addSubview:self.bankNumberTF];
    
    //持卡人姓名
    UILabel *nameLable = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(bankNumberLable.frame) + 20, 100, 30)];
    nameLable.text = @"持卡人姓名";
    nameLable.textColor = kColor(150, 150, 150);
    [nameLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    [self. addView addSubview:nameLable];
    
    self.nameTF = [[UITextField alloc]initWithFrame:CGRectMake(120, CGRectGetMaxY(bankNumberLable.frame) + 20, kScreenWidth - 170, 30)];
    self.nameTF.font = [UIFont systemFontOfSize:15];
    self.nameTF.placeholder = @"请输入持卡人姓名";
    [self.addView addSubview:self.nameTF];
    
    //线
    for (int i = 0; i < 5 ; i ++) {
        self.lineLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 50 + 50 * i, kScreenWidth - 40, 1)];
        self.lineLable.backgroundColor = kColor(240, 240, 240);
        [self.addView addSubview:self.lineLable];
    }
    
    //提交按钮
    self.submitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.submitButton.frame = CGRectMake(kScreenWidth * 0.3, CGRectGetMaxY(self.addView.frame) + 10, kScreenWidth * 0.4, kScreenWidth * 0.4 * 0.25);
  //  [self.submitButton setBackgroundImage:[UIImage imageNamed:@"submit"] forState:UIControlStateNormal];
    [self.submitButton setTintColor:[UIColor whiteColor]];
    [self.submitButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.submitButton setBackgroundColor:kColor(255, 230, 0)];
    [self.submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.submitButton];
}
//查找所有省
- (void)getDataForProvince{
    
    NSDictionary *partner = @{
                              @"token": KUSERID
                              };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    [manager POST:[NSString stringWithFormat:@"%@/appcity/findprovinceall",HXECOMMEN] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //   NSLog(@"%@",responseObject);
        if ([responseObject[@"status"] integerValue] == 200) {
            NSArray *arr = responseObject[@"data"];
            for (NSDictionary *dic in arr) {
                ProvinceModel *model = [ProvinceModel new];
                [model setValuesForKeysWithDictionary:dic];
                [self.provinceArr addObject:model];
            }
            [self.addView addSubview:self.provinceTF];
            [self setupProvinceTF:self.addView];
        }else{
            [MBProgressHUD showMessage:responseObject[@"msg"]];
      //      [[AppDelegate mainAppDelegate] showLoginView];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}


//查找所有市
- (void)getDataForCityWithID:(NSString *)provinceID{
    
    NSDictionary *partner = @{
                              @"cityUpId": provinceID,
                              @"token": KUSERID
                              };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    [manager POST:[NSString stringWithFormat:@"%@/appcity/findcitybyprov",HXECOMMEN] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //  NSLog(@"%@",responseObject);
        
        if ([responseObject[@"status"] integerValue] == 200) {
            [self.cityArr removeAllObjects];
            NSArray *arr = responseObject[@"data"];
            for (NSDictionary *dic in arr) {
                
                CityModel *model = [CityModel new];
                [model setValuesForKeysWithDictionary:dic];
                [self.cityArr addObject:model];
            }
            
            [self.addView addSubview:self.cityTF];
            [self setupCityTF:self.addView];
        }else{
            [MBProgressHUD showMessage:responseObject[@"msg"]];
       //     [[AppDelegate mainAppDelegate] showLoginView];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
//查找所有银行
- (void)getDataForBank{
    
    NSDictionary *partner = @{
                              @"token": KUSERID
                              };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    [manager POST:[NSString stringWithFormat:@"%@/appcity/findbankcodeall",HXECOMMEN] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //   NSLog(@"%@",responseObject);
        
        if ([responseObject[@"status"] integerValue] == 200) {
            NSArray *arr = responseObject[@"data"];
            for (NSDictionary *dic in arr) {
                BankModel *model = [BankModel new];
                [model setValuesForKeysWithDictionary:dic];
                [self.bankArr addObject:model];
            }
            //  NSLog(@"%@",_bankArr);
            [self.addView addSubview:self.bankTF];
            [self setupBankTF:self.addView];
            
        }else{
            [MBProgressHUD showMessage:responseObject[@"msg"]];
       //     [[AppDelegate mainAppDelegate] showLoginView];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//查找所有银行支行
- (void)getDataForChildBankWithCityID:(NSString *)CityID
                         ParentBankId:(NSString *)parentBankId
                           ProvinceId:(NSString *)provinceId{
    
    NSDictionary *partner = @{
                              @"cityId": CityID,
                              @"parentBankId": parentBankId,
                              @"provinceId": provinceId,
                              @"token": KUSERID
                              };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    [manager POST:[NSString stringWithFormat:@"%@/appcity/findbankBranchall",HXECOMMEN] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //    NSLog(@"%@",responseObject);
        if ([responseObject[@"status"] integerValue] == 200) {
            [self.childBankArr removeAllObjects];
            NSArray *arr = responseObject[@"data"];
            for (NSDictionary *dic in arr) {
                ChildBankModel *model = [ChildBankModel new];
                [model setValuesForKeysWithDictionary:dic];
                [self.childBankArr addObject:model];
            }
            [self.addView addSubview:self.childBankTF];
            [self setupChildBankTF:self.addView];
        }else{
            [MBProgressHUD showMessage:responseObject[@"msg"]];
      //      [[AppDelegate mainAppDelegate] showLoginView];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
- (BRTextField *)getTextAccontField:(UIView *)view{
    BRTextField *textField = [[BRTextField alloc]initWithFrame:CGRectMake(120, 10, 150, 30)];
    textField.backgroundColor = [UIColor clearColor];
    textField.font = [UIFont systemFontOfSize:15];
    textField.textAlignment = NSTextAlignmentLeft;
    textField.delegate = self;
    [view addSubview:textField];
    return textField;
}
- (void)setupAccontTF:(UIView *)view{
    if (!_accountTypeTF) {
        _accountTypeTF = [self getTextAccontField:view];
      //  _accountTypeTF.placeholder = @"请选择账户";
        __weak typeof(self) weakSelf = self;
        
        _accountTypeTF.tapAcitonBlock = ^{
            [BRStringPickerView showStringPickerWithTitle:@"省份" dataSource:@[@"个人",@"企业"] defaultSelValue:@"个人" isAutoSelect:YES resultBlock:^(id selectValue) {
                weakSelf.accountTypeTF.text = selectValue;
                
            }];
        };
    }
}
- (BRTextField *)getTextField:(UIView *)view{
    BRTextField *textField = [[BRTextField alloc]initWithFrame:CGRectMake(85, 60, 150, 30)];
    textField.backgroundColor = [UIColor clearColor];
    textField.font = [UIFont systemFontOfSize:15];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.delegate = self;
    [view addSubview:textField];
    return textField;
}
- (void)setupProvinceTF:(UIView *)view{
    if (!_provinceTF) {
        _provinceTF = [self getTextField:view];
        __weak typeof(self) weakSelf = self;
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i < self.provinceArr.count; i ++) {
            ProvinceModel *model = self.provinceArr[i];
            [arr addObject:model.provinceName];
            [self.provinceDic setObject:model.provinceId forKey:model.provinceName];
        }
        _provinceTF.placeholder = kStringIsEmpty([arr firstObject])?@"请选择省份":[arr firstObject];
        _provinceTF.tapAcitonBlock = ^{
            [BRStringPickerView showStringPickerWithTitle:@"省份" dataSource:arr defaultSelValue:nil isAutoSelect:YES resultBlock:^(id selectValue) {
                weakSelf.provinceTF.text = selectValue;
                
                [weakSelf getDataForCityWithID:[weakSelf.provinceDic objectForKey:weakSelf.provinceTF.text]];
            }];
        };
    }
}
- (BRTextField *)getCityTextField:(UIView *)view{
    BRTextField *textField = [[BRTextField alloc]initWithFrame:CGRectMake(kScreenWidth * 0.6, 60, kScreenWidth * 0.3, 30)];
    textField.backgroundColor = [UIColor clearColor];
    textField.font = [UIFont systemFontOfSize:15];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.delegate = self;
    [view addSubview:textField];
    return textField;
}

- (void)setupCityTF:(UIView *)view{
    if (!_cityTF) {
        _cityTF = [self getCityTextField:view];
    }
    __weak typeof(self) weakSelf = self;
    NSMutableArray *arr = [NSMutableArray array];
    
    for (int i = 0; i < self.cityArr.count; i ++) {
        CityModel *model = self.cityArr[i];
        [arr addObject:model.cityName];
        [self.cityDic setObject:model.cityId forKey:model.cityName];
    }
    _cityTF.text = kStringIsEmpty([arr firstObject])?@"请选择城市":[arr firstObject];
    
    _cityTF.tapAcitonBlock = ^{
        [BRStringPickerView showStringPickerWithTitle:@"城市" dataSource:arr defaultSelValue:nil isAutoSelect:YES resultBlock:^(id selectValue) {
            weakSelf.cityTF.text = selectValue;
            
        }];
    };
}
- (BRTextField *)getBankTextField:(UIView *)view{
    BRTextField *textField = [[BRTextField alloc]initWithFrame:CGRectMake(120, 110, kScreenWidth * 0.65, 30)];
    textField.backgroundColor = [UIColor clearColor];
    textField.font = [UIFont systemFontOfSize:15];
    textField.textAlignment = NSTextAlignmentLeft;
    textField.delegate = self;
    [view addSubview:textField];
    return textField;
}
- (void)setupBankTF:(UIView *)view{
    if (!_bankTF) {
        _bankTF = [self getBankTextField:view];
        //   _bankTF.placeholder = @"请选择银行";
        __weak typeof(self) weakSelf = self;
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i < self.bankArr.count; i ++) {
            BankModel *model = self.bankArr[i];
            [arr addObject:model.bankName];
            [self.bankDic setObject:model.bankId forKey:model.bankName];
        }
        _bankTF.placeholder = kStringIsEmpty([arr firstObject])?@"请选择银行":[arr firstObject];
        _bankTF.tapAcitonBlock = ^{
            [BRStringPickerView showStringPickerWithTitle:@"银行" dataSource:arr defaultSelValue:nil isAutoSelect:YES resultBlock:^(id selectValue) {
                weakSelf.bankTF.text = selectValue;
                
                [weakSelf getDataForChildBankWithCityID:[weakSelf.cityDic objectForKey:weakSelf.cityTF.text] ParentBankId:[weakSelf.bankDic objectForKey:weakSelf.bankTF.text] ProvinceId:[weakSelf.provinceDic objectForKey:weakSelf.provinceTF.text]];
            }];
        };
    }
}
- (BRTextField *)getChileBankTextField:(UIView *)view{
    BRTextField *textField = [[BRTextField alloc]initWithFrame:CGRectMake(120, 160, kScreenWidth * 0.65, 30)];
    textField.backgroundColor = [UIColor clearColor];
    textField.font = [UIFont systemFontOfSize:15];
    textField.textAlignment = NSTextAlignmentLeft;
    textField.delegate = self;
    [view addSubview:textField];
    return textField;
}
- (void)setupChildBankTF:(UIView *)view{
    if (!_childBankTF) {
        _childBankTF = [self getChileBankTextField:view];
    }
    __weak typeof(self) weakSelf = self;
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < self.childBankArr.count; i ++) {
        ChildBankModel *model = self.childBankArr[i];
        [arr addObject:model.bankBranchName];
        [self.childBankDic setObject:model.bankCoupletNum forKey:model.bankBranchName];
    }
    _childBankTF.text = kStringIsEmpty([arr firstObject])?@"请选择支行":[arr firstObject];
    
    _childBankTF.tapAcitonBlock = ^{
        [BRStringPickerView showStringPickerWithTitle:@"支行" dataSource:arr defaultSelValue:nil isAutoSelect:YES resultBlock:^(id selectValue) {
            weakSelf.childBankTF.text = selectValue;
        }];
    };
}

//提交方法
- (void)submit{
    
    NSInteger account ;
    if ([self.accountTypeTF.text  isEqual: @"个人"]) {
        account = 1;
    }else{
        account = 2;
    }
    
    if (kStringIsEmpty(self.bankTF.text) || kStringIsEmpty(self.childBankTF.text) || kStringIsEmpty(self.bankNumberTF.text) || kStringIsEmpty(self.nameTF.text) || kStringIsEmpty(self.accountTypeTF.text)) {
        [MBProgressHUD showError:@"数据不能为空"];
        return;
    }else{
        [self RequestWithAccountType:account OpenBank:[self.bankDic objectForKey:self.bankTF.text] SettlementAccount:self.bankNumberTF.text SettlementAccountName:self.nameTF.text SubBranch:[self.childBankDic objectForKey:self.childBankTF.text]];
    }
    
}

//调用接口
- (void)RequestWithAccountType:(NSInteger )accountType
                      OpenBank:(NSString *)openBank
             SettlementAccount:(NSString *)settlementAccount
         SettlementAccountName:(NSString *)settlementAccountName
                     SubBranch:(NSString *)subBranch
{
    
    NSDictionary *partner = @{
                              @"accountType": @(accountType),
                              @"openBank": openBank,
                              @"settlementAccount": settlementAccount,
                              @"settlementAccountName": settlementAccountName,
                              @"subBranch": subBranch,
                              @"sys_user_id": KUSERSHOPID,
                              @"token": KUSERID
                              };
    NSLog(@"%@",partner);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    [manager POST:[NSString stringWithFormat:@"%@/appcommercial/addBankAccount",HXECOMMEN] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
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
