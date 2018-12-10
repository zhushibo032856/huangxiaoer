//
//  AppointmentDateViewController.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/10/20.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "AppointmentDateViewController.h"
#import "WSDatePickerView.h"
#import "AppointmentTableViewCell.h"
#import "EditDateViewController.h"
#import "AddDateViewController.h"
#import "SYAlertView.h"
static CGFloat const originXY = 20.0;
static CGFloat const heightButton = 40.0;

@interface AppointmentDateViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIButton *selectButton;

@property (nonatomic, strong) NSMutableArray *dataArray;//接收16进制转化为数组的数据

@property (nonatomic, strong) NSMutableArray *netArray;//存放16进制转化的2进制数组

@property (nonatomic, strong) UITableView *dateTableview;

@property (nonatomic, assign) NSInteger thePage;

@property (nonatomic, strong) SYAlertView *alertView;

@property (nonatomic, strong) UIView *titleEidtView;
@property (nonatomic, strong) UIView *editView;

@property (nonatomic, strong) UITextField *textfield;
@property (nonatomic, strong) UITextField *timeTF;

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UIButton *addButton;

@property (nonatomic, strong) UIView *dateView;

@end

@implementation AppointmentDateViewController

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
    
    self.navigationItem.title = @"预约时间";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
    
}
- (void)leftBarBtnClicked:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColor(230, 230, 230);

    [self creatAutoLayout];
    [self getDateFromNetWork];
    
    _dataArray = [[NSMutableArray alloc]init];
    _netArray = [[NSMutableArray alloc]init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDateFromNetWork) name:@"noti1" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDateFromNetWork) name:@"noti2" object:nil];
}


- (void)creatAutoLayout{
    
    UILabel *timeLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 80, 30)];
    timeLable.text = @"做餐时间";
    [self.view addSubview:timeLable];
    
    UIView *timeView = [[UIView alloc]initWithFrame:CGRectMake(10, 50, kScreenWidth - 20, 60)];
    timeView.backgroundColor = [UIColor whiteColor];
    timeView.layer.cornerRadius = 5;
    timeView.layer.masksToBounds = YES;
    [self.view addSubview:timeView];
    
    _timeTF = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, 30, 40)];
    
    _timeTF.textAlignment = NSTextAlignmentCenter;
    _timeTF.font = [UIFont systemFontOfSize:19];
    [timeView addSubview:_timeTF];
    
    UILabel *mintLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_timeTF.frame) + 10, 10, 40, 40)];
    mintLable.text = @"分钟";
    [timeView addSubview:mintLable];
    
    UIButton *didButton = [UIButton buttonWithType:UIButtonTypeSystem];
    didButton.frame = CGRectMake(kScreenWidth * 0.7, 10, kScreenWidth * 0.2, 40);
    [didButton setTitle:@"点击更改" forState:UIControlStateNormal];
    [didButton setTintColor:kColor(210, 210, 210)];
    [didButton setBackgroundColor:[UIColor whiteColor]];
    [didButton addTarget:self action:@selector(buttonDidTouch) forControlEvents:UIControlEventTouchUpInside];
    [timeView addSubview:didButton];
    
    UILabel *takeLable = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(timeView.frame) + 10, kScreenWidth - 20, 30)];
    takeLable.text = @"预约时间";
    [self.view addSubview:takeLable];
}

#pragma mark **创建时间列表布局
- (UIButton *)addButton{
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_addButton setTitle:@"添加预约时间" forState:UIControlStateNormal];
        [_addButton setTintColor:[UIColor blackColor]];
        [_addButton setBackgroundColor:[UIColor whiteColor]];
        _addButton.layer.cornerRadius = 5;
        _addButton.layer.masksToBounds = YES;
        [_addButton addTarget:self action:@selector(getToEditViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

- (void)creatAutoLayoutWithDateArrayount:(NSInteger)count{
    
    self.dateView = [[UIView alloc]initWithFrame:CGRectMake(10, 160, kScreenWidth - 20, 60 * count)];
    self.dateView.layer.cornerRadius = 5;
    self.dateView.layer.masksToBounds = YES;
    [self.view addSubview:self.dateView];
    
 //   NSLog(@"%@",_dateView);
   
    _dateTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth - 20, 60 * count) style:UITableViewStylePlain];
    _dateTableview.delegate = self;
    _dateTableview.dataSource = self;
    [_dateTableview registerClass:[AppointmentTableViewCell class] forCellReuseIdentifier:@"CELL"];
    [_dateTableview reloadData];
    [_dateView addSubview:_dateTableview];
    
    
    self.addButton.frame = CGRectMake(10, CGRectGetMaxY(_dateView.frame) + 10, kScreenWidth - 20, 50);
    [self.view addSubview:self.addButton];
 //   NSLog(@"%@",_addButton);
    
}
#pragma mark **做餐时间操作
- (SYAlertView *)alertView
{
    if (_alertView == nil) {
        _alertView = [[SYAlertView alloc] init];
        _alertView.isAnimation = YES;
    }
    return _alertView;
}

- (void)buttonDidTouch{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.35f];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setType:@"cube"];
    [animation setSubtype:@"fromRight"];
    self.alertView.animation = animation;
    //
    self.alertView.containerView.frame = CGRectMake(20.0, 100.0, (self.alertView.frame.size.width - 40.0f), self.titleEidtView.frame.size.height);
    [self.alertView.containerView addSubview:self.titleEidtView];
    [self.alertView show];
}

- (UIView *)titleEidtView
{
    if (_titleEidtView == nil) {
        _titleEidtView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, (kScreenWidth - originXY * 2), 0.0)];
        _titleEidtView.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(originXY, originXY, (_titleEidtView.frame.size.width - originXY * 2), heightButton)];
        label.textColor = [UIColor blackColor];
        label.text = @"请输入时间";
        label.numberOfLines = 0;
        CGFloat height = [label.text boundingRectWithSize:CGSizeMake(label.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil].size.height;
        CGRect rectlabel = label.frame;
        rectlabel.size.height = 8.0f * 2 + height;
        label.frame = rectlabel;
        [_titleEidtView addSubview:label];
        
        UIView *currentView = label;
        
        _textfield = [[UITextField alloc] initWithFrame:CGRectMake(currentView.frame.origin.x, (currentView.frame.origin.y + currentView.frame.size.height + originXY), currentView.frame.size.width, heightButton)];
        _textfield.backgroundColor = kColor(230, 230, 230);
        _textfield.textAlignment = NSTextAlignmentCenter;
        _textfield.layer.masksToBounds = YES;
        _textfield.layer.cornerRadius = 5;
        _textfield.placeholder = @"20";
        [_titleEidtView addSubview:_textfield];
        
        currentView = _textfield;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(currentView.frame.origin.x, (currentView.frame.origin.y + currentView.frame.size.height + originXY), currentView.frame.size.width, heightButton)];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.backgroundColor = kColor(255, 210, 0);
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        [button addTarget:self action:@selector(hideClick) forControlEvents:UIControlEventTouchUpInside];
        [_titleEidtView addSubview:button];
        
        currentView = button;
        
        CGRect rect = _titleEidtView.frame;
        rect.size.height = currentView.frame.origin.y + currentView.frame.size.height + originXY;
        _titleEidtView.frame = rect;
    }
    return _titleEidtView;
}
- (void)hideClick
{
  //  NSLog(@"%@",_textfield.text);
    
    NSScanner* scan = [NSScanner scannerWithString:_textfield.text];
    
    int val;
    
    NSInteger X = [scan scanInt:&val] && [scan isAtEnd];

    
    if (kStringIsEmpty(_textfield.text)) {
        _timeTF.text = @"20";
    }else {
        if (X == 0){
        [MBProgressHUD showError:@"请输入整数!"];
        _textfield.text = @"";
        return;
        }else if ([_textfield.text integerValue] < 5){
            [MBProgressHUD showError:@"时间不能小于5分钟"];
            return;
        }else{
            _timeTF.text = _textfield.text;
        }
        
    }
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    [user setValue:_textfield.text forKey:@"dateTime"];
//    [user synchronize];
    
    [self uploadBookdistanceWithDateTime:_timeTF.text];
    
    [self.alertView hide];
    
}
- (void)uploadBookdistanceWithDateTime:(NSString *)dateTime{
    
    NSDictionary *partner = @{
                              @"bookdistance": dateTime,
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
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setValue:dateTime forKey:@"dateTime"];
            [user synchronize];
        }else{
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

#pragma mark  **添加页面
- (void)getToEditViewController{
    
    self.hidesBottomBarWhenPushed = YES;
    AddDateViewController *addVC = [[AddDateViewController alloc]init];
    addVC.netArray = _netArray;
    [self.navigationController pushViewController:addVC animated:YES];
    
}

#pragma mark  数据请求
- (void)getDateFromNetWork{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
    [manager GET:[NSString stringWithFormat:@"%@/appcommercial/findUserBookTime/%@/%@",HXECOMMEN,KUSERSHOPID,KUSERID] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       //   NSLog(@"%@",responseObject);
        
        if ([responseObject[@"status"] integerValue] == 200) {
           
            NSDictionary *dataDic = responseObject[@"data"];
            NSString *string = [dataDic objectForKey:@"bookTime"];
            NSString *bookdistance = dataDic[@"bookdistance"];
            _timeTF.text = [NSString stringWithFormat:@"%@",bookdistance];
            
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setValue:_timeTF.text forKey:@"dateTime"];
            [user synchronize];
            
            if (kStringIsEmpty(string)) {
                NSString *str = @"000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
                NSString *dataString = [self turnToArrWithString:str];
                _dataArray = [self ergodicGetStringWithString:dataString];
              //  NSLog(@"****%lu",(unsigned long)_dataArray.count);
                
               [self creatAutoLayoutWithDateArrayount:_dataArray.count];
                
            }else{
                NSString *dataString = [self turnToArrWithString:string];
               _dataArray = [self ergodicGetStringWithString:dataString];
           //     NSLog(@"%lu",(unsigned long)_dataArray.count);
             //   NSLog(@"%@",_dataArray);
                [self creatAutoLayoutWithDateArrayount:_dataArray.count];
            }
            [self.dateTableview reloadData];
        }else{
            
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

#pragma mark 16进制转2进制  转化为时间数组
- (NSString *)turnToArrWithString:(NSString *)string{
    
    NSMutableDictionary *hexDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    [hexDic setObject:@"0000" forKey:@"0"];
    [hexDic setObject:@"0001" forKey:@"1"];
    [hexDic setObject:@"0010" forKey:@"2"];
    [hexDic setObject:@"0011" forKey:@"3"];
    [hexDic setObject:@"0100" forKey:@"4"];
    [hexDic setObject:@"0101" forKey:@"5"];
    [hexDic setObject:@"0110" forKey:@"6"];
    [hexDic setObject:@"0111" forKey:@"7"];
    [hexDic setObject:@"1000" forKey:@"8"];
    [hexDic setObject:@"1001" forKey:@"9"];
    [hexDic setObject:@"1010" forKey:@"a"];
    [hexDic setObject:@"1011" forKey:@"b"];
    [hexDic setObject:@"1100" forKey:@"c"];
    [hexDic setObject:@"1101" forKey:@"d"];
    [hexDic setObject:@"1110" forKey:@"e"];
    [hexDic setObject:@"1111" forKey:@"f"];
    
    
    NSMutableString *binary = [NSMutableString string];
    for (int i = 0; i < string.length; i++) {
        NSString *key = [string substringWithRange:NSMakeRange(i, 1)];
        
        NSString *binaryStr = hexDic[key];
        
        [binary appendString:[NSString stringWithFormat:@"%@",binaryStr]];
    }
    
    //  NSLog(@"%@*****%ld",binary,binary.length);
    
    NSString *empt = nil;
    for (int i = 0; i < binary.length; i ++) {
        empt = [binary substringWithRange:NSMakeRange(i, 1)];
        [_netArray addObject:empt];
    }
    //    NSLog(@"%@",_netArray);
    return binary;
}

- (NSMutableArray *)ergodicGetStringWithString:(NSString *)string{
    NSString *empt = nil;
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i = 0; i < string.length; i ++) {
        empt = [string substringWithRange:NSMakeRange(i, 1)];
        [arr addObject:empt];
    }
    
    //  NSLog(@"%@",arr);
    NSString *tipString = [NSString string];
    NSString *timeString = [NSString string];
    
    NSMutableArray *timeArr = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < arr.count; i ++) {
        NSString *isTrue = arr[i];
        int n = i + 1;
        if (i == arr.count - 1) {
            n = i;
        }
        NSString *isNextTrue = arr[n];
        if ((i == arr.count - 1) && [isNextTrue isEqualToString:@"1"]) {
            isNextTrue = @"0";
        }
        
        CGFloat h = i / 60;
        CGFloat m = i % 60;
        NSString *min = [NSString string];
        if (m < 10) {
            min = [NSString stringWithFormat:@"0%.f",m];
        }else{
            min = [NSString stringWithFormat:@"%.f",m];
        }
        NSString *hour = [NSString string];
        if (h < 10) {
            hour = [NSString stringWithFormat:@"0%.f",h];
        }else{
            hour = [NSString stringWithFormat:@"%.f",h];
        }
        
        
        NSString *time = [NSString stringWithFormat:@"%@:%@",hour,min];
        
   //     NSLog(@"%@",time);
        if (([isTrue isEqualToString:@"1"] && [tipString isEqualToString:@"end"]) || ([isTrue isEqualToString:@"1"] && [tipString isEqualToString:@""])) {
            tipString = @"start";
            timeString = [NSString stringWithFormat:@"%@%@",time,@"~"];
            //   NSLog(@"******%@",timeString);
        }else if ([isTrue isEqualToString:@"1"] && [tipString isEqualToString:@"start"] && [isNextTrue isEqualToString:@"0"]){
            
            tipString = @"end";
            
            timeString = [NSString stringWithFormat:@"%@%@",timeString,time];
            //   NSLog(@"%@",timeString);
            [timeArr addObject:timeString];
            
            timeString = @"";
        }
    }
  //  NSLog(@"%@",timeArr);
    return timeArr;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AppointmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    
    cell.timeLable.text = _dataArray[indexPath.row];
    cell.index = indexPath.row;
    __weak typeof(self)weakSelf = self;
    cell.block = ^(NSInteger index, NSInteger buttonTag) {
        
        [weakSelf nextViewOrDelegateWith:index ButtonTag:buttonTag];
        
    };
    return cell;
}

- (void)nextViewOrDelegateWith:(NSInteger)index
                     ButtonTag:(NSInteger)buttonTag{
    if (buttonTag == 100) {
        [self eidtDateToNextViewWithIndex:index];
    }else{
        [self delegateDateWithIndex:index];
    }
    
}

#pragma mark 删除操作
- (void)delegateDateWithIndex:(NSInteger)index
{
    
    NSLog(@"%@",_dataArray[index]);
    
    NSString *string = _dataArray[index];
    
    NSArray *dateArr = [string componentsSeparatedByString:@"~"];
    NSLog(@"%@",dateArr);
    NSString *firstStr = dateArr.firstObject;
    NSString *lastStr = dateArr.lastObject;
    
    NSLog(@"%@     %@",firstStr,lastStr);
    
    NSArray *firstArr = [firstStr componentsSeparatedByString:@":"];
    NSLog(@"%@",firstArr);
    
    NSArray *lastArr = [lastStr componentsSeparatedByString:@":"];
    
    CGFloat X = [firstArr.firstObject integerValue] * 60 + [firstArr.lastObject integerValue];
    CGFloat Y = [lastArr.firstObject integerValue] * 60 + [lastArr.lastObject integerValue];
    
    NSLog(@"%.f  %.f",X,Y);
    
    NSMutableArray *newDateArr = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i <= Y - X; i++) {
        [newDateArr insertObject:@"0" atIndex:i];
    }
 //   NSLog(@"%@",_netArray);
    
    [_netArray replaceObjectsInRange:NSMakeRange(X, Y - X + 1) withObjectsFromArray:newDateArr];

//    NSLog(@"%@",_netArray);
    
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
    NSLog(@"%ld******%@",doString.length,doString);
    
    [self uploadDateWithDateString:doString];
    
    
    
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
            [self.dateView removeFromSuperview];
            [self getDateFromNetWork];
        }else{
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

#pragma mark 编辑操作
- (void)eidtDateToNextViewWithIndex:(NSInteger)index{
    
    self.hidesBottomBarWhenPushed = YES;
    EditDateViewController *editVC = [[EditDateViewController alloc]init];
    
    editVC.dataArray = _dataArray;
    editVC.netArray = _netArray;
    editVC.dateString = _dataArray[index];
    [self.navigationController pushViewController:editVC animated:YES];
  //  self.hidesBottomBarWhenPushed = NO;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
