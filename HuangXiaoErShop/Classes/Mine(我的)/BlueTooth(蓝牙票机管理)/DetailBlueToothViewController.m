//
//  DetailBlueToothViewController.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/10/31.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "DetailBlueToothViewController.h"
#import "ConnecterManager.h"
#import "BLEConnecter.h"

@interface DetailBlueToothViewController ()

@property (nonatomic, strong) UILabel *connState;

@end

@implementation DetailBlueToothViewController

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
    
    self.navigationItem.title = @"蓝牙票机";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
    
}
- (void)leftBarBtnClicked:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor(230, 230, 230);
    // Do any additional setup after loading the view.
    [self creatAutoLayout];
    
    
}

- (void)creatAutoLayout{
    
    UILabel *mineLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 100, 20)];
    mineLable.text = @"我的票机";
    [self.view addSubview:mineLable];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 30, kScreenWidth, 50)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    UIImageView *printImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 30, 30)];
    [printImage setImage:[UIImage imageNamed:@"bleMachines"]];
    [backView addSubview:printImage];
    
    UILabel *nameLable = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, kScreenWidth * 0.5, 30)];
    nameLable.text = _peripheral.name;
    [backView addSubview:nameLable];
    
    CBPeripheralState state = _peripheral.state;
    NSLog(@"%ld",(long)state);
    _connState = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth * 0.7, 10, kScreenWidth * 0.25, 30)];
    _connState.textAlignment = NSTextAlignmentRight;
    
    if (state == 2) {
        _connState.text = @"已连接";
        _connState.textColor = [UIColor greenColor];
    }else if(state == 1){
        _connState.text = @"断开连接";
        _connState.textColor = [UIColor redColor];
    }else{
        _connState.text = @"连接失败";
        _connState.textColor = [UIColor redColor];
    }
    
    
    [backView addSubview:_connState];
    
    UIButton *printButton = [UIButton buttonWithType:UIButtonTypeSystem];
    printButton.frame = CGRectMake(10, 90, kScreenWidth - 20, 40);
    printButton.layer.cornerRadius = 20;
    printButton.layer.masksToBounds = YES;
    [printButton setBackgroundColor:kColor(255, 210, 0)];
    [printButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [printButton addTarget:self action:@selector(printDataWithButton) forControlEvents:UIControlEventTouchUpInside];
    [printButton setTitle:@"预约打印测试" forState:UIControlStateNormal];
    
    [self.view addSubview:printButton];
    
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    closeButton.frame = CGRectMake(10, 140, kScreenWidth - 20, 40);
    closeButton.layer.cornerRadius = 20;
    closeButton.layer.masksToBounds = YES;
    [closeButton setBackgroundColor:[UIColor whiteColor]];
    [closeButton setTintColor:[UIColor redColor]];
    [closeButton setTitle:@"堂食打印测试" forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closerPrint) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
}

- (void)closerPrint{
//    if (_peripheral != nil) {
//        [Manager closePeripheral:_peripheral];
//    }
    
    [Manager write:[self escCommandWithDinein] progress:^(NSUInteger total, NSUInteger progress) {
        [MBProgressHUD showSuccess:@"打印中"];
    } receCallBack:^(NSData * _Nullable data) {
        
    }];
    
}

- (void)printDataWithButton{
    
    [Manager write:[self escCommand] progress:^(NSUInteger total, NSUInteger progress) {
        [MBProgressHUD showSuccess:@"打印中"];
    } receCallBack:^(NSData * _Nullable data) {

    }];
    
}
-(NSData *)escCommand{
    
    int x = arc4random() % 3;

    EscCommand *command = [[EscCommand alloc]init];
    [command addInitializePrinter];
    
    if (x == 0) {
        [command addPrintAndFeedLines:1];
        [command addPrintMode:0x0];
        [command addText:@"****"];
        
        [command addPrintMode:0x16 | 0x32];
        [command addText:@"  黄小二  "];
        [command addSetJustification:1];
        
        [command addPrintMode:0x0];
        [command addText:@"****\n"];
    }else if (x == 1){
        [command addPrintAndFeedLines:1];
        [command addPrintMode:0x16 | 0x32];
        [command addText:@"黄小二【未支付单】\n"];
    }else{
        [command addPrintAndFeedLines:1];
        [command addPrintMode:0x16 | 0x32];
        [command addText:@"黄小二【退款单】\n"];
        
        [command addPrintMode:0x0];
        [command addText:@"-------------------------------\n"];
        
        [command addPrintMode:0x16 | 0x32];
        [command addText:@"这家饭太难吃了\n"];
        
        [command addPrintMode:0x0];
        [command addText:@"-------------------------------\n"];
    }
    
    
    
    [command addPrintMode:0x0];
    //   [command addPrintAndFeedLines:2];
    [command addText:@"黄小二(龙湖镇小学一号餐厅)\n"];
    [command addSetJustification:0];
    
    [command addPrintMode:0x0];
    [command addText:@"-------------------------------\n"];
    [command addSetJustification:0];
    
    NSString *string = @"9";
    [command addText:[NSString stringWithFormat:@"叫号：%@\n",string]];
    [command addText:@"预约时间：\n"];
    
    
    [command addPrintMode:0x16 | 0x32];
    [command addText:@"09-21 17:24\n"];
    
    [command addPrintMode:0x0];
    [command addText:@"-------------------------------\n"];
    
    [command addPrintMode:0x16];
    [command addText:@"黄焖鸡 X1"];
    
    [command addPrintMode:0x0];
    [command addText:@"\n*******************************\n"];
    
    [command addPrintMode:0x16 | 0x32];
    [command addText:@"备注："];
    [command addPrintMode:0x0];
    [command addText:@"\n*******************************\n"];
    
    [command addText:@"订单价格："];
    [command addText:@"\n-------------------------------\n"];
    
    [command addText:@"用户名:黄小二\n"];
    [command addText:@"123456789\n"];
    [command addText:@"订单号:D123456787654321\n\n\n\n"];
    
 
    [command queryRealtimeStatus:0x02];
    return [command getCommand];
}

-(NSData *)escCommandWithDinein{
    
    int x = arc4random() % 2;
    
    EscCommand *command = [[EscCommand alloc]init];
    [command addInitializePrinter];
    
    if (x == 0) {
        [command addPrintAndFeedLines:1];
        [command addPrintMode:0x0];
        [command addText:@"注意:堂食订单\n"];
        [command addPrintMode:0x0];
        [command addText:@"===============================\n"];
        
        [command addPrintMode:0x16 | 0x32];
        [command addSetJustification:1];
        [command addText:@"黄小二【堂食】\n"];
        
        
    }else{
        [command addPrintAndFeedLines:1];
        [command addPrintMode:0x16 | 0x32];
        [command addText:@"黄小二【退款单】\n"];
        
        [command addPrintMode:0x0];
        [command addText:@"-------------------------------\n"];
        
        [command addPrintMode:0x16 | 0x32];
        [command addText:@"退款原因:这家饭太难吃了\n"];
        
        [command addPrintMode:0x0];
        [command addText:@"-------------------------------\n"];
    }
    
    
    
    [command addPrintMode:0x0];
    [command addSetJustification:1];
    [command addText:@"*黄小二*\n"];
    
    [command addSetJustification:0];
    [command addPrintMode:0x0];
    [command addText:[NSString stringWithFormat:@"下单时间:2018-12-12"]];
    
    [command addPrintMode:0x0];
    [command addText:@"\n-------------------------------\n"];
    
    [command addPrintMode:0x16 | 0x32];
    [command addText:[NSString stringWithFormat:@"桌号:28"]];
    
    [command addPrintMode:0x0];
    [command addText:@"\n-------------------------------\n"];
    
    [command addPrintMode:0x16];
    [command addText:@"黄焖鸡 X1"];
    
    [command addPrintMode:0x0];
    [command addText:@"\n*******************************\n"];
    
    [command addPrintMode:0x16 | 0x32];
    [command addText:@"备注:这只是一个测试"];
    [command addPrintMode:0x0];
    [command addText:@"\n*******************************\n"];
    
    [command addText:@"订单价格："];
    [command addText:@"\n-------------------------------\n"];
    
    [command addText:@"用户名:黄小二\n"];
    [command addText:@"123456789\n"];
    [command addText:@"订单号:D123456787654321\n\n\n\n"];
    
    
    [command queryRealtimeStatus:0x02];
    return [command getCommand];
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
