//
//  JieSuanViewController.m
//  HuangXiaoErShop
//
//  Created by apple on 2019/1/15.
//  Copyright © 2019年 aladdin. All rights reserved.
//

#import "JieSuanViewController.h"
#import "SchoolTableViewCell.h"
#import "OutShopTableViewCell.h"
#import "BindingWXViewController.h"
#import "BindingAliPayViewController.h"
#import "BindingBankViewController.h"
#import "EditBankViewController.h"
#import "BindModel.h"

@interface JieSuanViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *schoolTableView;
@property (nonatomic, strong) UITableView *shopTableView;

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

static NSString * const schoolCell = @"SchoolTableViewCell";
static NSString * const shopCell = @"OutShopTableViewCell";

@implementation JieSuanViewController

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArr;
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
    
    //  [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"backcolor"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationItem.title = @"结算管理";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
    
}
- (void)leftBarBtnClicked:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColor(240, 240, 240);
    
    NSInteger i = 1;
    if (i == 1) {
        [self creatSchoolTableView];
    }else{
        [self creatShopTableView];
    }
    
    
    // Do any additional setup after loading the view.
}

- (void)creatSchoolTableView{
    
    _schoolTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 100) style:UITableViewStylePlain];
    _schoolTableView.scrollEnabled = NO;
    _schoolTableView.layer.masksToBounds = YES;
    _schoolTableView.layer.cornerRadius = 8;
    _schoolTableView.delegate = self;
    _schoolTableView.dataSource = self;
    [_schoolTableView registerNib:[UINib nibWithNibName:@"SchoolTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:schoolCell];
    [self.view addSubview:_schoolTableView];
    
}

- (void)creatShopTableView{
    
    _shopTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 50) style:UITableViewStylePlain];
    _shopTableView.scrollEnabled = NO;
    _shopTableView.layer.masksToBounds = YES;
    _shopTableView.layer.cornerRadius = 8;
    _shopTableView.delegate = self;
    _shopTableView.dataSource = self;
    [_shopTableView registerNib:[UINib nibWithNibName:@"OutShopTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:shopCell];
    [self.view addSubview:_shopTableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _shopTableView) {
        return 1;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _schoolTableView) {
        SchoolTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:schoolCell forIndexPath:indexPath];
        cell.selectionStyle = NO;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == 0) {
            cell.AliLable.text = @"绑定微信";
        }else{
            cell.AliLable.text = @"绑定支付宝";
        }
        return cell;
    }else{
        OutShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:shopCell forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = NO;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _schoolTableView) {
        if (indexPath.row == 0) {
            self.hidesBottomBarWhenPushed = YES;
            BindingWXViewController * wxVC = [[BindingWXViewController alloc]init];
            [self.navigationController pushViewController:wxVC animated:YES];
        }else{
            self.hidesBottomBarWhenPushed = YES;
            BindingAliPayViewController *aliVC = [[BindingAliPayViewController alloc]init];
            [self.navigationController pushViewController:aliVC animated:YES];
        }
    }else{
        [self getDataFromNet];
    }
    
}

#pragma mark 跳转绑定或者编辑银行卡页面
- (void)getDataFromNet{
    MBProgressHUD *hud = [[MBProgressHUD alloc]init];
    hud.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth);
    hud.minSize = CGSizeMake(100, 100);
    hud.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:hud];
    [hud showAnimated:YES];
   
    NSDictionary *partner = @{
                              @"token": KUSERID
                              };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    [manager POST:[NSString stringWithFormat:@"%@/appcommercial/findBankAccount",HXECOMMEN] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
     //   NSLog(@"%@",responseObject);
        NSMutableArray *arr = [NSMutableArray array];
        if ([responseObject[@"status"] integerValue] == 200) {
            [self.dataArr removeAllObjects];
            arr = responseObject[@"data"];
            for (NSDictionary *dic in arr) {
                BindModel *model = [[BindModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArr addObject:model];
            }
            NSLog(@"%@",self.dataArr);
            if (self.dataArr.count == 0) {
                self.hidesBottomBarWhenPushed = YES;
                BindingBankViewController *bankVC = [[BindingBankViewController alloc]init];
                [self.navigationController pushViewController:bankVC animated:YES];
                [hud hideAnimated:YES afterDelay:0.5];
            }else{
                self.hidesBottomBarWhenPushed = YES;
                EditBankViewController *editVC = [[EditBankViewController alloc]init];
                editVC.model = self.dataArr.firstObject;
                [self.navigationController pushViewController:editVC animated:YES];
                [hud hideAnimated:YES afterDelay:0.5];
            }
        }else{
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    

    
    
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
