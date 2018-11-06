//
//  BlueToothViewController.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/10/30.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "BlueToothViewController.h"
#import "MineBlueToothTableViewCell.h"
#import "SearchBlueToothTableViewCell.h"
#import "DetailBlueToothViewController.h"

#import "ConnecterManager.h"

static NSString * const mineCell = @"MineBlueToothTableViewCell";
static NSString * const searchCell = @"SearchBlueToothTableViewCell";

@interface BlueToothViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *printTableView;

@property (nonatomic, strong) NSMutableArray *devices;
@property (nonatomic, strong) NSMutableDictionary *dicts;

@property (nonatomic, strong) CBPeripheral *peripheral;

@end

@implementation BlueToothViewController

-(NSMutableArray *)devices {
    if (!_devices) {
        _devices = [[NSMutableArray alloc]init];
    }
    return _devices;
}

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
    
    self.view.backgroundColor = [UIColor whiteColor];
    

    _printTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _printTableView.delegate = self;
    _printTableView.dataSource = self;
    [_printTableView registerClass:[MineBlueToothTableViewCell class] forCellReuseIdentifier:mineCell];
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


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, kScreenWidth - 20, 20)];
    [view addSubview:lable];
    if (section == 0) {
        lable.text = @"我的票机";
    }else{
        lable.text = @"请选择要连接的票机";
    }
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return [[self.dicts allKeys]count];
      //  return 2;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        MineBlueToothTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineCell forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.nameLable.text = @"已连接票机";
        
        return cell;
    }else{
         SearchBlueToothTableViewCell *seaCell = [tableView dequeueReusableCellWithIdentifier:searchCell forIndexPath:indexPath];
        CBPeripheral *peripheral = [self.dicts objectForKey:[self.dicts allKeys][indexPath.row]];
        seaCell.nameLable.text = peripheral.name;
   
        return seaCell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 1) {
        CBPeripheral *peripheral = [self.dicts objectForKey:[self.dicts allKeys][indexPath.row]];

        [self connectDevice:peripheral];
    }else{
        if (!_peripheral) {
            [MBProgressHUD showError:@"请先连接打印机"];
            return;
        }
        NSLog(@"%@",_peripheral);
        
        

        
        
        self.hidesBottomBarWhenPushed = YES;
        DetailBlueToothViewController *detailVC = [[DetailBlueToothViewController alloc]init];
        detailVC.peripheral = _peripheral;
    //    NSLog(@"*******%@",_peripheral);
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    

}


-(void)connectDevice:(CBPeripheral *)peripheral {

    [Manager connectPeripheral:peripheral options:nil timeout:5 connectBlack:^(ConnectState state) {
        NSLog(@"%lu%@",(unsigned long)state,peripheral);
        
        switch (state) {
            case 0:
                [MBProgressHUD showError:@"未找到设备"];
                break;
            case 1:
                [MBProgressHUD showError:@"断开连接"];
                break;
            case 2:
                [MBProgressHUD showError:@"连接中"];
                break;
            case 3:
                [MBProgressHUD showError:@"连接成功"];
                _peripheral = peripheral;
                [self userDefaultWith:peripheral];
                break;
            case 4:
                [MBProgressHUD showError:@"连接超时"];
                break;
            case 5:
                [MBProgressHUD showError:@"连接失败"];
                break;
                
            default:
                break;
        }
    }];
   
}
- (void)userDefaultWith:(CBPeripheral *)peripheral{
    
    
    NSDictionary *dic = [self.dicts objectForKey:peripheral.identifier.UUIDString];
    
    
    
    NSUserDefaults *user = kUserDefaults;
  //  [user setObject:dic forKey:@"blueTooth"];
    [user synchronize];
    NSLog(@"%@",dic);

    
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
