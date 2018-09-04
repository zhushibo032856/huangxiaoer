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

@interface MachinesManagerViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) NSInteger thePage;

@end

static NSString *const myCell = @"myMachinesCell";
static NSString *const addCell = @"addMachinesCell";

@implementation MachinesManagerViewController

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
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
    self.navigationItem.title = @"票机管理";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
}
- (void)leftBarBtnClicked:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 110) style:UITableViewStyleGrouped];
    
    self.tableview.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    self.tableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    self.tableview.tableHeaderView.backgroundColor = [UIColor whiteColor];
    UILabel *myLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 20)];
    myLable.text = @"我的票机";
    myLable.font = [UIFont systemFontOfSize:13];
    [self.tableview.tableHeaderView addSubview:myLable];
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    [self.tableview registerClass:[MyMachineTableViewCell class] forCellReuseIdentifier:myCell] ;
    [self.tableview registerClass:[AddMachinesTableViewCell class] forCellReuseIdentifier:addCell];
    
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
        
        NSLog(@"%@",responseObject);
        
        if ([responseObject[@"status"] integerValue] == 200) {
            if (self->_thePage == 1) {
                [self.dataSource removeAllObjects];
            }
            NSArray *arr = responseObject[@"data"];
            for (NSDictionary *dic in arr) {
                MachinesModel *model = [[MachinesModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataSource addObject:model];
            }
            if (self->_thePage == 1) {
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
    
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return self.dataSource.count;
    }else
        return 2;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
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
        MachinesModel *model = self.dataSource[indexPath.row];
        MyMachineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myCell forIndexPath:indexPath];
        [cell setDataForCellWithModel:model];
        return cell;
    } else {
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
        MachinesDetailViewController *macdetailVC = [[MachinesDetailViewController alloc]init];
        macdetailVC.model = self.dataSource[indexPath.row];
        [self.navigationController pushViewController:macdetailVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    } else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            self.hidesBottomBarWhenPushed = YES;
            AddMachinesViewController *addVC = [[AddMachinesViewController alloc]init];
            [self.navigationController pushViewController:addVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }else{
            [MBProgressHUD showSuccess:@"该功能暂未开放"];
            //            self.hidesBottomBarWhenPushed = YES;
            //            BlueToothViewController *blueToothVC = [BlueToothViewController new];
            //            [self.navigationController pushViewController:blueToothVC animated:YES];
            //            self.hidesBottomBarWhenPushed = NO;
        }
        
    }
    
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
