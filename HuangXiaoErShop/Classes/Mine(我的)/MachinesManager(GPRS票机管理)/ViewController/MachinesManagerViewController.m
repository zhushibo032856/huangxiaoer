//
//  MachinesManagerViewController.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "MachinesManagerViewController.h"
#import "MyMachineTableViewCell.h"
#import "AddMachinesTableViewCell.h"
#import "AddMachinesViewController.h"
#import "MachinesModel.h"
#import "MachinesDetailViewController.h"

#import "MyBlueViewController.h"
#import "DetailMessageTableViewCell.h"
#import "BlueModel.h"
#import "DetailBlueToothViewController.h"
#import "ConnecterManager.h"



@interface MachinesManagerViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) NSInteger thePage;

@property (nonatomic, strong) UIImageView *blueImageView;
@property (nonatomic, strong) UILabel *stateLable;
@property (nonatomic, strong) UILabel *nameLable;

@property (nonatomic, strong) NSMutableDictionary *dic;

@property (nonatomic, strong) CBPeripheral *peripheral;//手动连接蓝牙信息
@property (nonatomic, strong) CBPeripheral *lastPeripheral;//自动连接上一次的蓝牙信息

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

static NSString *const myCell = @"myMachinesCell";
static NSString *const addCell = @"addMachinesCell";
static NSString *const detailCell = @"detailMessageCell";



@implementation MachinesManagerViewController

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}
- (NSMutableDictionary *)dic{
    if (!_dic) {
        _dic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _dic;
}
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArr;
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (!kStringIsEmpty(KBLUETOOTH)) {
        [self startScanLastPrint];
    }
    
    self.navigationController.navigationBarHidden = NO;
    
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    leftBtn.frame = CGRectMake(0, 0, 30, 30);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"itemBack"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBarBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    [self setNavigationController];
    
}
- (void)setNavigationController{
    
    self.navigationItem.title = @"票机管理";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
    
}
- (void)leftBarBtnClicked:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)startScanLastPrint{

    if (Manager.bleConnecter == nil) {
        [Manager didUpdateState:^(NSInteger state) {
            switch (state) {
                case CBManagerStateUnsupported:
                    NSLog(@"The platform/hardware doesn't support Bluetooth Low Energy.");
                    break;
                case CBManagerStateUnauthorized:
                    NSLog(@"The app is not authorized to use Bluetooth Low Energy.");
                    break;
                case CBManagerStatePoweredOff:
                    NSLog(@"Bluetooth is currently powered off.");
                    break;
                case CBManagerStatePoweredOn:
                    [self connectLastPrint];
                    NSLog(@"Bluetooth power on");
                    break;
                case CBManagerStateUnknown:
                default:
                    break;
            }
        }];
    }else{
        [self connectLastPrint];
    }
}
- (void)connectLastPrint{
    
    if (KBLUETOOTH) {
        [Manager scanForPeripheralsWithServices:nil options:nil discover:^(CBPeripheral * _Nullable peripheral, NSDictionary<NSString *,id> * _Nullable advertisementData, NSNumber * _Nullable RSSI) {
            if ([peripheral.identifier.UUIDString isEqualToString:KBLUETOOTH]) {
                NSLog(@"相同则开始连接此蓝牙");
                [Manager connectPeripheral:peripheral options:nil timeout:2 connectBlack:^(ConnectState state) {
                    
                    [self updateConnectState:state];
//
                    _lastPeripheral = peripheral;
                    [self updateNameWith:_lastPeripheral];
                    [self.tableview reloadData];
                    [Manager stopScan];
                }];
            }else{
                NSLog(@"未找到该设备");
          //      [MBProgressHUD showError:@"未找到该设备"];
                [_blueImageView setImage:[UIImage imageNamed:@"bleMachines"]];
            }
        }];
    }else{
        NSLog(@"请手动连接蓝牙打票机");
        [_blueImageView setImage:[UIImage imageNamed:@"bleMachines"]];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatAutoLayout];
    [self setRefresh];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setRefresh) name:@"notiEdit" object:nil];
    // Do any additional setup after loading the view.
}
- (void)setRefresh {

    _thePage = 1;
    __block typeof(self)weakself = self;
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.tableview.mj_footer resetNoMoreData];
        weakself.thePage = 1;
        [self requsetData];
    }];
    
    self.tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.thePage = 1;
        [self.tableview.mj_footer endRefreshing];
    }];
    // 进入界面时刷新
    [self.tableview.mj_header beginRefreshing];
    
}

- (void)creatAutoLayout{
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    
    self.tableview.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    self.tableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    self.tableview.tableHeaderView.backgroundColor = [UIColor whiteColor];
    UILabel *myLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 20)];
    myLable.text = @"蓝牙票机";
    myLable.font = [UIFont systemFontOfSize:13];
    [self.tableview.tableHeaderView addSubview:myLable];
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    [self.tableview registerClass:[MyMachineTableViewCell class] forCellReuseIdentifier:myCell] ;
    [self.tableview registerClass:[AddMachinesTableViewCell class] forCellReuseIdentifier:addCell];
    [self.tableview registerClass:[DetailMessageTableViewCell class] forCellReuseIdentifier:detailCell];
    
    [self.view addSubview:self.tableview];
    
}

- (void)requsetData{
    
    NSDictionary *partner = @{
                              @"token": KUSERID
                              };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html", nil];
    
    [manager POST:[NSString stringWithFormat:@"%@/appprint/findall",HXECOMMEN] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
  //      NSLog(@"%@",responseObject);
        
        if ([responseObject[@"status"] integerValue] == 200) {
            if (_thePage == 1) {
                [self.dataSource removeAllObjects];
            }
            NSArray *arr = responseObject[@"data"];
            for (NSDictionary *dic in arr) {
                MachinesModel *model = [[MachinesModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataSource addObject:model];
            }
            if (_thePage == 1) {
                [self.tableview.mj_header endRefreshing];
            }else{
                if (arr.count == 0) {
                    [self.tableview.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [self.tableview.mj_footer endRefreshing];
                }
            }
            [self.tableview reloadData];
        }else {
            [self.tableview.mj_header endRefreshing];
            [MBProgressHUD showMessage:responseObject[@"msg"]];
        }

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        if (!KBLUETOOTH) {
            return 0;
        }else{
            return 1;
            
        }
    }else if (section == 1){
        return self.dataSource.count;
    }
        return 2;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
   
    
    if (section == 1) {
        if (self.dataSource.count == 0) {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
            self.tableview.tableFooterView = view;
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, 30)];
            lable.text = @"还未绑定打印机";
            lable.font = [UIFont systemFontOfSize:12];
            lable.textAlignment = NSTextAlignmentCenter;
            [self.tableview.tableFooterView addSubview:lable];
            return view;
        }else{
            return nil;
        }
        
        
    } else {
        return nil;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {
        DetailMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailCell forIndexPath:indexPath];
        _stateLable = [[UILabel alloc]initWithFrame:cell.stateLable.frame];
        [cell.contentView addSubview:_stateLable];
        
        _nameLable = [[UILabel alloc]initWithFrame:cell.nameLable.frame];
        [cell.contentView addSubview:_nameLable];
        
        _blueImageView = [[UIImageView alloc]initWithFrame:cell.blueImageView.frame];
        [cell.contentView addSubview:_blueImageView];
        
        cell.nameLable = _nameLable;
        cell.stateLable = _stateLable;
        cell.blueImageView = _blueImageView;

        return cell;
    }else if (indexPath.section == 1){
        MachinesModel *model = self.dataSource[indexPath.row];
        MyMachineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myCell forIndexPath:indexPath];
        [cell setDataForCellWithModel:model];
        return cell;
    }
    else {
        AddMachinesTableViewCell *cellAdd = [tableView dequeueReusableCellWithIdentifier:addCell forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cellAdd.addLable.text = @"添加GPRS新票机";
        }
        else{
            cellAdd.addLable.text = @"添加蓝牙新票机";
        }
        return cellAdd;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        self.hidesBottomBarWhenPushed = YES;
        
        DetailBlueToothViewController *detailVC = [[DetailBlueToothViewController alloc]init];
        if (KBLUETOOTH && _lastPeripheral) {
            detailVC.peripheral = _lastPeripheral;
        }else{
          detailVC.peripheral = _peripheral;
        }
        
        [self.navigationController pushViewController:detailVC animated:YES];
        
        self.hidesBottomBarWhenPushed = NO;
        
    }else if (indexPath.section == 1) {
        self.hidesBottomBarWhenPushed = YES;
        MachinesDetailViewController *macdetailVC = [[MachinesDetailViewController alloc]init];
        macdetailVC.model = self.dataSource[indexPath.row];
        [self.navigationController pushViewController:macdetailVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    } else if(indexPath.section == 2){
        if (indexPath.row == 0) {
            self.hidesBottomBarWhenPushed = YES;
            AddMachinesViewController *addVC = [[AddMachinesViewController alloc]init];
            [self.navigationController pushViewController:addVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }else{

            self.hidesBottomBarWhenPushed = YES;

            MyBlueViewController *myBlueVC = [[MyBlueViewController alloc]init];
            myBlueVC.state = ^(ConnectState state) {
                [self updateConnectState:state];
            };
            myBlueVC.block = ^(CBPeripheral *peripheral) {
                [self updateNameWith:peripheral];
            };
            [self.navigationController pushViewController:myBlueVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
    }
}
- (void)updateNameWith:(CBPeripheral *)peripheral{
    
    
    
    _peripheral = peripheral;

}


-(void)updateConnectState:(ConnectState)state{
    [_blueImageView setImage:[UIImage imageNamed:@"bleMachines"]];
    _nameLable.text = @"蓝牙打票机";
    _stateLable.text = @"";
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (state) {
            case CONNECT_STATE_CONNECTING:
             //   _stateLable.text = @"蓝牙连接中";
                break;
            case CONNECT_STATE_CONNECTED:
                [MBProgressHUD showSuccess:@"连接成功"];
                
                _stateLable.text = @"已连接";
                break;
            case CONNECT_STATE_FAILT:
                [MBProgressHUD showError:@"连接失败"];
              _stateLable.text = @"连接失败";
                break;
            case CONNECT_STATE_DISCONNECT:

                [MBProgressHUD showError:@"断开连接"];
                [self startScanLastPrint];
                _stateLable.text = @"已断开";
                break;
            default:
                [MBProgressHUD showError:@"连接超时"];
                break;
        }
    });
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
