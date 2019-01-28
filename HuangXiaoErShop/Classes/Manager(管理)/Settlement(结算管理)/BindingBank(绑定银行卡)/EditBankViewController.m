//
//  EditBankViewController.m
//  HuangXiaoErShop
//
//  Created by apple on 2019/1/16.
//  Copyright © 2019年 aladdin. All rights reserved.
//

#import "EditBankViewController.h"
#import "BRTextField.h"
#import "BankModel.h"

@interface EditBankViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *FirstView;

@property (weak, nonatomic) IBOutlet UIView *SecondView;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *numberTF;
@property (weak, nonatomic) IBOutlet UIButton *SubmitBT;

@property (nonatomic, strong) BRTextField *bankTF;
@property (nonatomic, strong) NSMutableArray *bankArr;
@property (nonatomic, strong) NSMutableDictionary *bankDic;

@end

@implementation EditBankViewController

- (NSMutableArray *)bankArr{
    if (!_bankArr) {
        _bankArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _bankArr;
}
- (NSMutableDictionary *)bankDic{
    if (!_bankDic) {
        _bankDic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _bankDic;
}

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
    
    self.navigationItem.title = @"编辑银行卡";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
    
}
- (void)leftBarBtnClicked:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor(240, 240, 240);
    
    
    [self getDataForBank];
    [self initView];
    // Do any additional setup after loading the view from its nib.
}

- (void)initView{
    
    self.FirstView.layer.masksToBounds = YES;
    self.FirstView.layer.cornerRadius = 8;
    
    self.SecondView.layer.masksToBounds = YES;
    self.SecondView.layer.cornerRadius = 8;
    
    self.SubmitBT.layer.masksToBounds = YES;
    self.SubmitBT.layer.cornerRadius = 25;
    [self.SubmitBT setBackgroundColor:kColor(255, 210, 0)];
    
    self.nameTF.text = self.model.settlementAccountName;
    self.numberTF.text = self.model.settlementAccount;
    
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
            
            [self.SecondView addSubview:self.bankTF];
            [self setupBankTF:self.SecondView];
            
        }else{
            [MBProgressHUD showMessage:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (BRTextField *)getBankTextField:(UIView *)view{
    BRTextField *textField = [[BRTextField alloc]initWithFrame:CGRectMake(80, 40, kScreenWidth - 135, 30)];
    textField.backgroundColor = [UIColor clearColor];
    textField.font = [UIFont systemFontOfSize:15];
    textField.textAlignment = NSTextAlignmentRight;
    textField.delegate = self;
    [_SecondView addSubview:textField];
    return textField;
}
- (void)setupBankTF:(UIView *)view{
    if (!_bankTF) {
        _bankTF = [self getBankTextField:view];
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
                
            }];
        };
    }
}


- (IBAction)SubmitData:(UIButton *)sender {
    
    if (kStringIsEmpty(self.bankTF.text)) {
        [MBProgressHUD showError:@"请选择银行"];
        return;
    }
    if (kStringIsEmpty(_nameTF.text)) {
        [MBProgressHUD showError:@"请输入姓名"];
        return;
    }
    if (kStringIsEmpty(self.numberTF.text)) {
        [MBProgressHUD showError:@"请输入银行卡号"];
        return;
    }
    BOOL isRight = [self checkCardNo:self.numberTF.text];
    if (!isRight) {
        [MBProgressHUD showError:@"银行卡号错误，请重新输入"];
    }else{
        [self RequestWithOpenBank:[self.bankDic objectForKey:self.bankTF.text] SettlementAccount:self.numberTF.text SettlementAccountName:self.nameTF.text];
    }
}

- (void)RequestWithOpenBank:(NSString *)openBank
          SettlementAccount:(NSString *)settlementAccount
      SettlementAccountName:(NSString *)settlementAccountName{
    
    NSDictionary *partner = @{
                              @"openBank": openBank,
                              @"settlementAccount": settlementAccount,
                              @"settlementAccountName": settlementAccountName,
                              @"sys_user_id": KUSERSHOPID,
                              @"token": KUSERID
                              };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //@"http://bei.51hxe.com:9002/appcommercial/changeBankAccount"
    [manager POST:[NSString stringWithFormat:@"%@/appcommercial/changeBankAccount",HXECOMMEN] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"status"] integerValue] == 200) {
            [MBProgressHUD showSuccess:responseObject[@"msg"]];
        }else{
            [MBProgressHUD showSuccess:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (BOOL) checkCardNo:(NSString*) cardNo{
    int oddsum = 0;     //奇数求和
    int evensum = 0;    //偶数求和
    int allsum = 0;
    int cardNoLength = (int)[cardNo length];
    int lastNum = [[cardNo substringFromIndex:cardNoLength-1] intValue];
    
    cardNo = [cardNo substringToIndex:cardNoLength - 1];
    for (int i = cardNoLength -1 ; i>=1;i--) {
        NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i-1, 1)];
        int tmpVal = [tmpString intValue];
        if (cardNoLength % 2 ==1 ) {
            if((i % 2) == 0){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }else{
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }
    }
    
    allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) == 0)
        return YES;
    else
        return NO;
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
