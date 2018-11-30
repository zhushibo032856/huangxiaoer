//
//  MyBlueViewController.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/11/14.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "MyBlueViewController.h"
#import "SearchBlueToothTableViewCell.h"
#import "ConnecterManager.h"

static NSString * const searchCell = @"SearchBlueToothTableViewCell";

@interface MyBlueViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *printTableView;
@property (nonatomic, strong) NSMutableDictionary *dicts;

@end

@implementation MyBlueViewController

-(NSMutableDictionary *)dicts {
    if (!_dicts) {
        _dicts = [[NSMutableDictionary alloc]init];
    }
    return _dicts;
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
    
    _printTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    _printTableView.delegate = self;
    _printTableView.dataSource = self;

    [_printTableView registerClass:[SearchBlueToothTableViewCell class] forCellReuseIdentifier:searchCell];
    [self.view addSubview:_printTableView];
    
    [self creatAutoLayout];
    // Do any additional setup after loading the view.
}

- (void)creatAutoLayout{
    
    if (Manager.bleConnecter == nil) {
        
        [Manager didUpdateState:^(NSInteger state) {
            switch (state) {
                case CBManagerStateUnknown:
                    [MBProgressHUD showError:@"未发现蓝牙设备"];
                    break;
                case CBManagerStateResetting:
                    [MBProgressHUD showError:@"Resetting"];
                    break;
                case CBManagerStateUnsupported:
                    [MBProgressHUD showError:@"设备不支持"];
                    break;
                case CBManagerStateUnauthorized:
                    [MBProgressHUD showError:@"当前未授权"];
                    break;
                case CBManagerStatePoweredOff:
                    [MBProgressHUD showError:@"蓝牙可用，但是未打开"];
                    break;
                case CBManagerStatePoweredOn:
                    //     [MBProgressHUD showError:@"蓝牙可用"];
                    [self startScane];
                    break;
                    
                default:
                    break;
            }
        }];
    }else{
        [self startScane];
    }
}

- (void)startScane{
    
    [Manager scanForPeripheralsWithServices:nil options:nil discover:^(CBPeripheral * _Nullable peripheral, NSDictionary<NSString *,id> * _Nullable advertisementData, NSNumber * _Nullable RSSI) {
        
        if (peripheral.name != nil) {
            NSUInteger oldCounts = [self.dicts count];
            [self.dicts setObject:peripheral forKey:peripheral.identifier.UUIDString];
            
            //     NSLog(@"%@",_dicts);
            if (oldCounts < [self.dicts count]) {
                [_printTableView reloadData];
            }
        }
    }];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

        return [[self.dicts allKeys]count];

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        SearchBlueToothTableViewCell *seaCell = [tableView dequeueReusableCellWithIdentifier:searchCell forIndexPath:indexPath];
        CBPeripheral *peripheral = [self.dicts objectForKey:[self.dicts allKeys][indexPath.row]];
        seaCell.nameLable.text = peripheral.name;
        
        return seaCell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
        CBPeripheral *peripheral = [self.dicts objectForKey:[self.dicts allKeys][indexPath.row]];
        [self connectDevice:peripheral];

}

-(void)connectDevice:(CBPeripheral *)peripheral {
    
    _block(peripheral);
    [Manager connectPeripheral:peripheral options:nil timeout:5 connectBlack:self.state];
    
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setValue:peripheral.identifier.UUIDString forKey:@"blueTooth"];
        [user setValue:peripheral.name forKey:@"blueName"];
        [user synchronize];
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
