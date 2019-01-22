//
//  QRViewController.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "QRViewController.h"
#import "QRModel.h"
#import "ImageModel.h"
#import "QRTableViewCell.h"
#import "HeadTableViewCell.h"
#import "BindingViewController.h"
#import "QRImageViewController.h"
#import "BindQRViewController.h"

@interface QRViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *HeadTableView;
@property (nonatomic, strong) UITableView *QRTableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *imageDataArray;

@end

static NSString * const headCell = @"HeadTableViewCell";
static NSString * const QRcell = @"QRTableViewCell";

@implementation QRViewController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}

- (NSMutableArray *)imageDataArray{
    if (!_imageDataArray) {
        _imageDataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _imageDataArray;
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
    
    self.navigationItem.title = @"店铺收款码";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
    
}
- (void)leftBarBtnClicked:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColor(240, 240, 240);
    [self requestData];
    [self creatAutoLauout];
    
 //   [self requestAllImageData];
    // Do any additional setup after loading the view.
}
- (void)creatAutoLauout{
    
    self.HeadTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 100) style:UITableViewStylePlain];
    self.HeadTableView.layer.masksToBounds = YES;
    self.HeadTableView.layer.cornerRadius = 8;
    self.HeadTableView.delegate = self;
    self.HeadTableView.dataSource = self;
    [self.HeadTableView registerNib:[UINib nibWithNibName:@"HeadTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:headCell];
    [self.view addSubview:self.HeadTableView];
    
    _QRTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 120, kScreenWidth - 20, kScreenHeight - 120 - kNavHeight) style:UITableViewStyleGrouped];
    _QRTableView.backgroundColor = kColor(240, 240, 240);
    [_QRTableView registerNib:[UINib nibWithNibName:@"QRTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:QRcell];
    _QRTableView.delegate = self;
    _QRTableView.dataSource = self;
    [self.view addSubview:_QRTableView];
}

- (void)pushToBindingViewController{
    
    self.hidesBottomBarWhenPushed=YES;
    BindingViewController *bindingVC = [[BindingViewController alloc]init];
    [self.navigationController pushViewController:bindingVC animated:YES];
    
    
}

- (void)requestData{
    
    NSDictionary *partner = @{
                              @"token": KUSERID
                              };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html", nil];
    
    [manager POST:[NSString stringWithFormat:@"%@/appcommercial/findmachineall",HXECOMMEN] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //  NSLog(@"*****%@",responseObject);
        if ([responseObject[@"status"] integerValue] == 200) {
            NSMutableArray *array = responseObject[@"data"];
            for (NSDictionary *dic in array) {
                QRModel *model = [[QRModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
            }
           
        }else{
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
        
        [self.QRTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView == self.HeadTableView) {
        return 0;
    }else{
        return 10;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.HeadTableView) {
        return 2;
    }
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView == self.HeadTableView) {
        return 1;
    }
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.HeadTableView) {
        HeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:headCell forIndexPath:indexPath];
        cell.selectionStyle = NO;
        if (indexPath.row == 0) {
            [cell.TypeImage setImage:[UIImage imageNamed:@"ShopImage-1"]];
            cell.NameLable.text = @"店铺名称";
            cell.HeadLable.text = KUSERNAME;
        }else{
            [cell.TypeImage setImage:[UIImage imageNamed:@"machImage"]];
            cell.NameLable.text = @"机具号";
            cell.HeadLable.text = @"点击绑定机具号";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return cell;
    }else{
        QRTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:QRcell forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = NO;
        cell.layer.masksToBounds = YES;
        cell.layer.cornerRadius = 8;
        QRModel *model = self.dataArray[indexPath.section];
        [cell setDataForCellWithModel:model];
        return cell;
    }
    
}

- (void)requestAllImageData{
    
    NSDictionary *partner = @{
                              @"id": KUSERSHOPID,
                              @"token": KUSERID
                              };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html", nil];
    
    [manager POST:[NSString stringWithFormat:@"%@/appcommercial/findMachineNum_QrCodeById",HXECOMMEN] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      //  NSLog(@"%@",responseObject);
        if ([responseObject[@"status"] integerValue] == 200) {
            NSMutableArray *arr = responseObject[@"data"];
            for (NSDictionary *dic in arr) {
                ImageModel *model = [[ImageModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.imageDataArray addObject:model];
            }
        //    NSLog(@"%@",self.imageDataArray);
        }else{
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.hidesBottomBarWhenPushed = YES;
    if (tableView == self.HeadTableView) {
        if (indexPath.row == 1) {
            BindQRViewController *bindvc = [BindQRViewController new];
            [self.navigationController pushViewController:bindvc animated:YES];
        }
    }else{
        QRImageViewController *imageVC = [[QRImageViewController alloc]init];
        imageVC.model = self.dataArray[indexPath.section];
        [self.navigationController pushViewController:imageVC animated:YES];
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
