//
//  ShopSettingViewController.m
//  HuangXiaoErShop
//
//  Created by apple on 2019/1/9.
//  Copyright © 2019年 aladdin. All rights reserved.
//

#import "ShopSettingViewController.h"
#import "MineOneTableViewCell.h"
#import "EditShopMessageViewController.h"
#import "MachinesManagerViewController.h"
#import "QRViewController.h"
#import "AppointmentDateViewController.h"
#import "ManagerModel.h"

@interface ShopSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableView *secondTableView;

@property (nonatomic, strong) NSMutableArray *dataArray;//数据源

@end

static NSString *const mineCell = @"MineOneTableViewCell";

@implementation ShopSettingViewController
- (NSMutableArray*)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
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
    
    self.navigationItem.title = @"店铺设置";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
    
}
- (void)leftBarBtnClicked:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor(240, 240, 240);
    [self requestShopManager];
    [self initTableView];
    // Do any additional setup after loading the view.
}

//请求主页信息
- (void)requestShopManager{
    
    NSDictionary *partner = @{
                              @"token":KUSERID
                              };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html", nil];
    
    [manager POST:[NSString stringWithFormat:@"%@/appcommercial/findbytoken",HXECOMMEN] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //     NSLog(@"%@",responseObject);
        
        if ([responseObject[@"status"] integerValue] == 200) {
            [self.dataArray removeAllObjects];
            NSDictionary *dic = responseObject[@"data"];
            
            ManagerModel *model = [[ManagerModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];

        }else{
            [MBProgressHUD showMessage:responseObject[@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)initTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 50) style:UITableViewStylePlain];
    _tableView.layer.masksToBounds = YES;
    _tableView.layer.cornerRadius = 8;
    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[MineOneTableViewCell class] forCellReuseIdentifier:mineCell];
    [self.view addSubview:_tableView];
    
    _secondTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 70, kScreenWidth - 20, 150) style:UITableViewStylePlain];
    _secondTableView.layer.masksToBounds = YES;
    _secondTableView.layer.cornerRadius = 8;
    _secondTableView.delegate = self;
    _secondTableView.dataSource = self;
    _secondTableView.scrollEnabled = NO;
    _secondTableView.separatorStyle = NO;
    [_secondTableView registerClass:[MineOneTableViewCell class] forCellReuseIdentifier:mineCell];
    [self.view addSubview:_secondTableView];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_tableView == tableView) {
        return 1;
    }
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_tableView == tableView) {
        MineOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineCell forIndexPath:indexPath];
        cell.voiceSwitch.hidden = YES;
        cell.voiceLable.text = @"店铺信息";
        [cell.voiceimageView setImage:[UIImage imageNamed:@"shopBianji"]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
     MineOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineCell forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.voiceSwitch.hidden = YES;
    if (indexPath.row == 0) {
        cell.voiceLable.text = @"店铺收款码";
        [cell.voiceimageView setImage:[UIImage imageNamed:@"codeImage"]];
    }else if (indexPath.row == 1){
        cell.voiceLable.text = @"票机管理";
        [cell.voiceimageView setImage:[UIImage imageNamed:@"piaoji"]];
    }else{
        cell.voiceLable.text = @"营业时间";
        [cell.voiceimageView setImage:[UIImage imageNamed:@"yuyueTime"]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_tableView == tableView) {
        self.hidesBottomBarWhenPushed=YES;
        EditShopMessageViewController *editShopMessageVC = [[EditShopMessageViewController alloc]init];
       // editShopMessageVC.hidesBottomBarWhenPushed = YES;
        editShopMessageVC.model = [self.dataArray firstObject];
        [self.navigationController pushViewController:editShopMessageVC animated:YES];
      //  editShopMessageVC.hidesBottomBarWhenPushed = NO;
    }else{
        if (indexPath.row == 0) {
            self.hidesBottomBarWhenPushed=YES;
            QRViewController *qrVC = [[QRViewController alloc]init];
            [self.navigationController pushViewController:qrVC animated:YES];
        //    self.hidesBottomBarWhenPushed = NO;
        }else if (indexPath.row == 1){
            self.hidesBottomBarWhenPushed=YES;
            MachinesManagerViewController *macVC = [[MachinesManagerViewController alloc]init];
            [self.navigationController pushViewController:macVC animated:YES];
         //   self.hidesBottomBarWhenPushed = NO;
        }else{
            [self selectIsOpen];
        }
    }
    
}
#pragma mark 商户预约权限查询
- (void)selectIsOpen{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:[NSString stringWithFormat:@"%@/appcommercial/findUserBookTime/%@/%@",HXECOMMEN,KUSERSHOPID,KUSERID] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //   NSLog(@"%@",responseObject);
        NSDictionary *data = responseObject[@"data"];
        NSString *isOpen = data[@"isOpen"];
        
        if ([responseObject[@"status"] integerValue] == 200) {
            if ([isOpen integerValue] == 1) {
                [MBProgressHUD showError:@"权限不足,请联系客服"];
            }else{
                self.hidesBottomBarWhenPushed=YES;
                AppointmentDateViewController *appointmentVC = [[AppointmentDateViewController alloc]init];
                [self.navigationController pushViewController:appointmentVC animated:YES];
             //   self.hidesBottomBarWhenPushed = NO;
            }
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
