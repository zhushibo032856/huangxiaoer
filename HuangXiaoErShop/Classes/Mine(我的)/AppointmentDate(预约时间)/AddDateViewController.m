//
//  AddDateViewController.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/10/23.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "AddDateViewController.h"
#import "WSDatePickerView.h"

@interface AddDateViewController ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UITextField *startTF;
@property (nonatomic, strong) UITextField *stopTF;

@property (nonatomic, strong) UIButton *selectButton;

@property (nonatomic, strong) UIButton *keepButton;

@end

@implementation AddDateViewController
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
    
    self.navigationItem.title = @"添加预约时间";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
    
}
- (void)leftBarBtnClicked:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
 //   NSLog(@"%@",_netArray);
    
    [self creatAutoLayout];
    // Do any additional setup after loading the view.
}

- (void)creatAutoLayout{
    
    _backView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 100)];
    _backView.backgroundColor = [UIColor whiteColor];
    _backView.layer.cornerRadius = 5;
    _backView.layer.masksToBounds = YES;
    [self.view addSubview:_backView];
    
    NSArray *titleArr = @[@"选择开始时间",@"选择结束时间"];
    
    for (int i = 0; i < titleArr.count; i ++) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _selectButton.frame = CGRectMake(10, 10 + 45 * i, kScreenWidth * 0.4, 35);
        [_selectButton setTitle:titleArr[i] forState:UIControlStateNormal];
        _selectButton.tag = i + 300;
        // [_selectButton setBackgroundColor:[UIColor cyanColor]];
        [_selectButton setTintColor:[UIColor blackColor]];
        [_selectButton addTarget:self action:@selector(uploadDateWithSelectButton:) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:_selectButton];
    }
    
    
    _startTF = [[UITextField alloc]initWithFrame:CGRectMake(kScreenWidth * 0.5, 10, kScreenWidth * 0.4, 35)];
    
    _startTF.placeholder = @"点击左侧选择时间";
    _startTF.textAlignment = NSTextAlignmentRight;
    _startTF.enabled = NO;
    [_backView addSubview:_startTF];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, kScreenWidth - 40, 1)];
    line.backgroundColor = kColor(230, 230, 230);
    [_backView addSubview:line];
    
    _stopTF = [[UITextField alloc]initWithFrame:CGRectMake(kScreenWidth * 0.5, 55, kScreenWidth * 0.4, 35)];
    _stopTF.placeholder = @"点击左侧选择时间";
    _stopTF.enabled = NO;
    _stopTF.textAlignment = NSTextAlignmentRight;
    [_backView addSubview:_stopTF];
    
    
    _keepButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _keepButton.frame = CGRectMake(kScreenWidth * 0.1, 120, kScreenWidth * 0.8, 50);
    [_keepButton setTintColor:[UIColor blackColor]];
    _keepButton.layer.cornerRadius = 25;
    _keepButton.layer.masksToBounds = YES;
    [_keepButton setBackgroundColor:kColor(255, 210, 0)];
    [_keepButton setTitle:@"保存" forState:UIControlStateNormal];
    [_keepButton addTarget:self action:@selector(submitWithButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_keepButton];
    
}

- (void)uploadDateWithSelectButton:(UIButton *)button{
    
    switch (button.tag) {
        case 300:
        {
            WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowHourMinute CompleteBlock:^(NSDate *selectDate) {
                NSString *dateString = [selectDate stringWithFormat:@"HH:mm"];
                self.startTF.text = [NSString stringWithFormat:@"%@",dateString];
                [self dateArrWith];
            }];
            datepicker.dateLabelColor = [UIColor blackColor];//年-月-日-时-分 颜色
            datepicker.datePickerColor = [UIColor redColor];//滚轮日期颜色
            datepicker.doneButtonColor = [UIColor orangeColor];//确定按钮的颜色
            [datepicker show];
        }
            break;
        case 301:
        {
            WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowHourMinute CompleteBlock:^(NSDate *selectDate) {
                NSString *dateString = [selectDate stringWithFormat:@"HH:mm"];
                
          //      NSLog(@"**********%@",self.startTF.text);
                if ([self.startTF.text isEqualToString:@""]) {
           //         NSLog(@"请先选择初始时间");
                }else{
                    self.stopTF.text = [NSString stringWithFormat:@"%@",dateString];
                    [self dateArrWith];
                    
                }
            }];
            datepicker.dateLabelColor = [UIColor blackColor];//年-月-日-时-分 颜色
            datepicker.datePickerColor = [UIColor redColor];//滚轮日期颜色
            datepicker.doneButtonColor = [UIColor orangeColor];//确定按钮的颜色
            //  datepicker.yearLabelColor = [UIColor cyanColor];//大号年份字体颜色
            [datepicker show];
            
        }
            break;
            
        default:
            break;
    }
    
}
- (void)dateArrWith{
    
    
    if (kStringIsEmpty(self.startTF.text) && kStringIsEmpty(self.stopTF.text)) {
        
        CGFloat startX = [[self.startTF.text substringWithRange:NSMakeRange(0, 2)] integerValue];
        CGFloat startY = [[self.startTF.text substringWithRange:NSMakeRange(3, 2)] integerValue];
        
        CGFloat X = startX * 60 + startY;
  //      NSLog(@"%.f",X);
        
        CGFloat stopX = [[self.stopTF.text substringWithRange:NSMakeRange(0, 2)] integerValue];
        CGFloat stopY = [[self.stopTF.text substringWithRange:NSMakeRange(3, 2)] integerValue];
        
        CGFloat Y = stopX * 60 + stopY;
 //       NSLog(@"%.f",Y);
        if (Y < X){
  //          NSLog(@"结束时间不能小于初始时间");
            self.stopTF.text = @"结束时间不能小于初始时间";
            return;
        }
    }else{
   //     NSLog(@"初始时间不能为空");
    }
}

- (void)submitWithButton:(UIButton *)button{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    
    NSDate *startDate = [NSDate date];
    startDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@:00",self.startTF.text]];
    
    NSDate *stopDate = [NSDate date];
    stopDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@:00",self.stopTF.text]];
    
    if (kStringIsEmpty(self.startTF.text) || kStringIsEmpty(self.stopTF.text)) {
        [MBProgressHUD showError:@"数据不能为空"];
        return;
    }else{
        CGFloat startX = [[self.startTF.text substringWithRange:NSMakeRange(0, 2)] integerValue];
        CGFloat startY = [[self.startTF.text substringWithRange:NSMakeRange(3, 2)] integerValue];
        
        CGFloat XXX = startX * 60 + startY;
        
        
        CGFloat stopX = [[self.stopTF.text substringWithRange:NSMakeRange(0, 2)] integerValue];
        CGFloat stopY = [[self.stopTF.text substringWithRange:NSMakeRange(3, 2)] integerValue];
        
        CGFloat YYY = stopX * 60 + stopY;
        if (XXX > YYY) {
            [MBProgressHUD showError:@"结束时间不能小于开始时间"];
            return;
        }else{
   //         NSLog(@"%@",_netArray);
            
            NSMutableArray *newDateArr = [[NSMutableArray alloc]init];
            for (NSInteger i = 0; i <= YYY - XXX; i++) {
                [newDateArr insertObject:@"1" atIndex:i];
            }
            [_netArray replaceObjectsInRange:NSMakeRange(XXX, YYY - XXX + 1) withObjectsFromArray:newDateArr];
            
   //         NSLog(@"%@",_netArray);
            NSString *doString = [NSString string];
            for (int i = 0; i < 360; i ++) {
                NSArray *arr = [_netArray subarrayWithRange:NSMakeRange(0, 4)];
                [_netArray removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 4)]];
                //     NSLog(@"%@**%d",arr,i);
                
                NSString *string = [arr componentsJoinedByString:@""];
                //   NSLog(@"%@",string);
                
                NSString *binstring = [self getBinaryByHex:string];
                doString = [doString stringByAppendingString:binstring];
            }
         //   NSLog(@"%ld******%@",doString.length,doString);
            [self uploadDateWithDateString:doString];
        }
        
    }
    self.startTF.text = @"";
    self.stopTF.text = @"";
    
}

- (NSString *)getBinaryByHex:(NSString *)hex {
    NSMutableDictionary *hexDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    [hexDic setObject:@"0" forKey:@"0000"];
    [hexDic setObject:@"1" forKey:@"0001"];
    [hexDic setObject:@"2" forKey:@"0010"];
    [hexDic setObject:@"3" forKey:@"0011"];
    [hexDic setObject:@"4" forKey:@"0100"];
    [hexDic setObject:@"5" forKey:@"0101"];
    [hexDic setObject:@"6" forKey:@"0110"];
    [hexDic setObject:@"7" forKey:@"0111"];
    [hexDic setObject:@"8" forKey:@"1000"];
    [hexDic setObject:@"9" forKey:@"1001"];
    [hexDic setObject:@"a" forKey:@"1010"];
    [hexDic setObject:@"b" forKey:@"1011"];
    [hexDic setObject:@"c" forKey:@"1100"];
    [hexDic setObject:@"d" forKey:@"1101"];
    [hexDic setObject:@"e" forKey:@"1110"];
    [hexDic setObject:@"f" forKey:@"1111"];
    
    
    NSMutableString *binary = [NSMutableString string];
    
    binary = [hexDic objectForKey:hex];
    
    //   NSLog(@"%@",binary);
    
    return binary;
}

- (void)uploadDateWithDateString:(NSString *)dateString{
    NSString *bookdistance = [NSString string];
    if (kStringIsEmpty(KDATETIME)) {
        bookdistance = @"20";
    }else{
        bookdistance = [NSString stringWithFormat:@"%@",KDATETIME];
    }
    NSDictionary *partner = @{
                              @"bookTime": dateString,
                              @"bookdistance": bookdistance,
                              @"sysUserId": KUSERSHOPID,
                              @"token": KUSERID
                              };
    //   NSLog(@"%@",partner);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager POST:[NSString stringWithFormat:@"%@/appcommercial/updateUserBookTime",HXECOMMEN] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
   //     NSLog(@"%@",responseObject);
        if ([responseObject[@"status"] integerValue] == 200) {
            [MBProgressHUD showSuccess:responseObject[@"msg"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"noti2" object:nil];
        }else{
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
        
        
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
