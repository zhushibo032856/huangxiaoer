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
#import "BindingViewController.h"
#import "QRImageViewController.h"

@interface QRViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *QRTableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *imageDataArray;

@end

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
    leftBtn.frame = CGRectMake(0, 0, 30, 30);
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
    
    UIView *heaadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    heaadView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:heaadView];
    
    UIImageView *shopImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 20, 20)];
    [shopImage setImage:[UIImage imageNamed:@"ShopImage-1"]];
    [heaadView addSubview:shopImage];
    
    UILabel *nameLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxY(shopImage.frame) + 20, 20, 80, 20)];
    nameLable.text = @"店铺名称";
    nameLable.font = [UIFont systemFontOfSize:15];
    [heaadView addSubview:nameLable];
    
    UILabel *shopNameLable = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth * 0.4, 20, kScreenWidth * 0.56, 20)];
    shopNameLable.text = KUSERNAME;
    shopNameLable.font = [UIFont systemFontOfSize:15];
    shopNameLable.textAlignment = NSTextAlignmentRight;
    shopNameLable.textColor = kColor(210, 210, 210);
    [heaadView addSubview:shopNameLable];
    
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeSystem];
    if (iPhoneX) {
        addButton.frame = CGRectMake(0, self.view.bottom - 50 - 86, kScreenWidth, 50);
    } else {
        addButton.frame = CGRectMake(0, self.view.bottom - 50 - 64, kScreenWidth, 50);
    }
    [addButton setBackgroundColor:kColor(255, 210, 0)];
    [addButton setTitle:@"绑定机具号" forState:UIControlStateNormal];
    [addButton setTintColor:[UIColor whiteColor]];
    [addButton addTarget:self action:@selector(pushToBindingViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addButton];
    
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
            _QRTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 60, kScreenWidth, kScreenHeight - 120 - 64) style:UITableViewStylePlain];
            _QRTableView.backgroundColor = kColor(240, 240, 240);
            [_QRTableView registerClass:[QRTableViewCell class] forCellReuseIdentifier:QRcell];
            _QRTableView.delegate = self;
            _QRTableView.dataSource = self;
            [self.view addSubview:_QRTableView];
        }else{
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
        
        [self.QRTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    QRTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:QRcell forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    QRModel *model = self.dataArray[indexPath.row];
    [cell setDataForCellWithModel:model];
    return cell;
    
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
        NSLog(@"%@",responseObject);
        if ([responseObject[@"status"] integerValue] == 200) {
            NSMutableArray *arr = responseObject[@"data"];
            for (NSDictionary *dic in arr) {
                ImageModel *model = [[ImageModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.imageDataArray addObject:model];
            }
            NSLog(@"%@",self.imageDataArray);
        }else{
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        self.hidesBottomBarWhenPushed = YES;
        QRImageViewController *imageVC = [[QRImageViewController alloc]init];
        imageVC.model = self.dataArray[indexPath.row];
    //    imageVC.imageModel = self.imageDataArray[indexPath.row];
        [self.navigationController pushViewController:imageVC animated:YES];
//    [MBProgressHUD showError:@"该功能暂未开放"];
    
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
