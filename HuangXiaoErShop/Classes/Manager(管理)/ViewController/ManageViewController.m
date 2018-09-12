//
//  ManageViewController.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/8/3.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "ManageViewController.h"
#import "ManagerCollectionViewCell.h"
#import "ManagerTwoCollectionViewCell.h"
#import "DishesManagerViewController.h"
#import "UserReviewViewController.h"
#import "MessageCenterViewController.h"
#import "AvaBalanceViewController.h"
#import "TodayOrderViewController.h"
#import "TodayTurnoverViewController.h"
#import "ShopMessageViewController.h"
#import "ManagerModel.h"
#import "TodayDataModel.h"
#import "SettlementViewController.h"
#import "EditViewController.h"
#import "ScavengingreceiptsViewController.h"
#import "BusinessanalysisViewController.h"

@interface ManageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UIView *headView;//头视图
@property (nonatomic, strong) UIImageView *shopPhotoView;//店铺图片
@property (nonatomic, strong) UILabel *nameLable;//店铺名
@property (nonatomic, strong) UIButton *detailButton;//详情按钮
@property (nonatomic, strong) UIButton *arrowButton;//箭头按钮
@property (nonatomic, strong) UIButton *businessButton;//营业按钮

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataArray;//数据源

@property (nonatomic, assign) NSInteger shopStutas;//营业状态
@property (nonatomic, strong) NSString *userImageUrl;
@property (nonatomic, strong) NSString *userName;

@property (nonatomic, strong) NSMutableArray *collectionArray;

@property (nonatomic, assign) NSInteger thePage;

@end

static NSString * const managerCell = @"managerCollectionViewCell";
static NSString * const managerTwoCell = @"managerTwoCollectionViewCell";

@implementation ManageViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}

- (NSMutableArray *)collectionArray{
    
    if (!_collectionArray) {
        _collectionArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _collectionArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatHeadViewLayout];
    
    [self requestShopManager];
    
    [self creatCollectionView];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setRefresh) name:@"noti1" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setRefresh) name:@"notiEdit" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestShopManager) name:@"notiEdit" object:nil];
    [self setRefresh];
    // Do any additional setup after loading the view.
}

- (void)setRefresh{
    _thePage = 1;
    __block typeof(self)weakself = self;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakself.thePage = 1;
        [self requestDataForToday];
    }];
    [self.collectionView.mj_header beginRefreshing];
    
}

//请求主页信息
- (void)requestShopManager{

    
    NSDictionary *partner = @{
                              @"token": KUSERID
                              };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html", nil];
    
    [manager POST:[NSString stringWithFormat:@"%@/appcommercial/findbytoken",HXECOMMEN] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //   NSLog(@"%@",responseObject);
        if ([responseObject[@"status"] integerValue] == 200) {
            NSDictionary *dic = responseObject[@"data"];
            
            ManagerModel *model = [[ManagerModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
            
            _shopStutas = model.shopStutas;
            self.userName = model.shopSign;
            self.userImageUrl = model.logoImage;
            //请求完数据立马刷新按钮状态
            if (_shopStutas == 1) {
                [_businessButton setBackgroundImage:[UIImage imageNamed:@"openShop"] forState:UIControlStateNormal];
            }else{
                [_businessButton setBackgroundImage:[UIImage imageNamed:@"closedShop"] forState:UIControlStateNormal];
            }
            //     NSLog(@"======%ld",_shopStutas);
            
            [self creatHeadViewLayout];

        }else{
            [MBProgressHUD showError:responseObject[@"msg"]];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];
    
    
}

/** 头视图布局 */
- (void)creatHeadViewLayout{
    
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight / 5)];
    _headView.backgroundColor = [UIColor redColor];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"manageBack"]];
    imageView.frame = _headView.frame;
    [_headView addSubview:imageView];
    [self.view addSubview:_headView];
    
    
    
    _shopPhotoView = [[UIImageView alloc]initWithFrame:CGRectMake(25, CGRectGetHeight(_headView.frame) / 3 + 10, CGRectGetHeight(_headView.frame) / 3 + 20, CGRectGetHeight(_headView.frame) / 3 + 20)];
    _shopPhotoView.layer.masksToBounds = YES;
    _shopPhotoView.layer.cornerRadius = CGRectGetHeight(_shopPhotoView.frame) / 2;
    [_shopPhotoView sd_setImageWithURL:[NSURL URLWithString:self.userImageUrl] placeholderImage:[UIImage imageNamed:@"userName"]];
    [_headView addSubview:_shopPhotoView];
    
    _nameLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_shopPhotoView.frame) + 20, CGRectGetHeight(_headView.frame) / 3 + 10, kScreenWidth - _shopPhotoView.frame.size.width - 20 - _businessButton.frame.size.width - 30, 30)];
    _nameLable.text = self.userName;
    _nameLable.font = [UIFont systemFontOfSize:20];
    _nameLable.textAlignment = NSTextAlignmentLeft;
    [_headView addSubview:_nameLable];
    
    _detailButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _detailButton.frame = CGRectMake(CGRectGetMaxX(_shopPhotoView.frame) + 20, CGRectGetMaxY(_nameLable.frame) +10 , 80, 15);
    // [_detailButton setTitle:@"点击查看门店详情" forState:UIControlStateNormal];
    //    _detailButton.tintColor = [UIColor grayColor];
    //    _detailButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_detailButton setBackgroundImage:[UIImage imageNamed:@"shopDetailMessage"] forState:UIControlStateNormal];
    [_detailButton addTarget:self action:@selector(pushDetailShopView:) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:_detailButton];
    
    _businessButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _businessButton.frame = CGRectMake(kScreenWidth - CGRectGetHeight(_headView.frame) / 3 - 50, CGRectGetHeight(_headView.frame) / 3 + 20, kScreenWidth * 0.3, kScreenWidth * 0.09);
    
    if (_shopStutas == 1) {
        [_businessButton setBackgroundImage:[UIImage imageNamed:@"openShop"] forState:UIControlStateNormal];
    }else{
        [_businessButton setBackgroundImage:[UIImage imageNamed:@"closedShop"] forState:UIControlStateNormal];
    }
    
    [_businessButton addTarget:self action:@selector(changeShopBusiness:) forControlEvents:UIControlEventTouchUpInside];
    
    [_headView addSubview:_businessButton];
    
    
}


/** 跳转店铺详情页面 */
- (void)pushDetailShopView :(UIButton *)sender{
    
    self.hidesBottomBarWhenPushed = YES;
    ShopMessageViewController *shopMessageVC = [ShopMessageViewController new];
    [self.navigationController pushViewController:shopMessageVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

/** 改变店铺营业状态 */
- (void)changeShopBusiness :(UIButton *)sender{
    
    if (_shopStutas == 1) {
        
        [self requestDataWithStatus:2];
        
    }else if(_shopStutas == 2 ){
        
        [self requestDataWithStatus:1];
        
    }
}
/** 修改营业状态 */
- (void)requestDataWithStatus: (NSInteger )status{
    
    
    NSDictionary *partner = @{
                              @"shopStutas": @(status),
                              @"token": KUSERID
                              };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    [manager POST:[NSString stringWithFormat:@"%@/appcommercial/update",HXECOMMEN] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
    
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //       NSLog(@"*****%@",responseObject);
        
        if ([responseObject[@"status"] integerValue] == 200) {
            [MBProgressHUD showSuccess:responseObject[@"msg"]];
            [self requestShopManager];
        }else{
            [MBProgressHUD showSuccess:responseObject[@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

/** 九宫格视图布局 */
- (void)creatCollectionView{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(kScreenWidth / 3 - 2, 80);
    
    layout.minimumLineSpacing = 2.0;//设置最小行间距
    layout.minimumInteritemSpacing = 2;//item间距(最小值)
    layout.sectionInset = UIEdgeInsetsMake(1, 1, 10, 1);
    layout.minimumLineSpacing = 0.1;
    
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headView.frame), kScreenWidth, kScreenHeight - CGRectGetHeight(_headView.frame)) collectionViewLayout:layout];
    _collectionView.alwaysBounceVertical = YES;
    
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[ManagerCollectionViewCell class] forCellWithReuseIdentifier:managerCell];
    [_collectionView registerClass:[ManagerTwoCollectionViewCell class] forCellWithReuseIdentifier:managerTwoCell];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    [self.view addSubview:_collectionView];
    
    for (int i = 1; i < 3; i ++) {
        UILabel *lableOne = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth / 3 ) * i, 0, 1, 320)];
        lableOne.backgroundColor = kColor(240, 240, 240);
        [self.collectionView addSubview:lableOne];
        
    }
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 78, kScreenWidth - 0, 8)];
    lable.backgroundColor = kColor(240, 240, 240);
    [self.collectionView addSubview:lable];
    for (int a = 1; a < 4; a ++) {
        UILabel *lineLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 85 * a, kScreenWidth - 20, 1)];
        lineLable.backgroundColor = kColor(240, 240, 240);
        [self.collectionView addSubview:lineLable];
    }
    
    [self.collectionView reloadData];
}

/** 九宫格数据展示 */
- (void)requestDataForToday{
    
    NSDate *date =[NSDate date];
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *dateStr = [format stringFromDate:date];
    
    NSString *currentTime = [[NSString stringWithFormat:@"%@", dateStr]substringWithRange:NSMakeRange(0, 10)];
    NSString *string = @" 00:00:00";
    NSString *createTime = [NSString stringWithFormat:@"%@""%@",currentTime,string];
    
    NSDictionary *partner = @{
                              @"createTime": createTime,
                              @"isPay": @"0",
                              @"orderStatus": @"0",
                              @"page": @"1",
                              @"size": @"20",
                              @"token": KUSERID
                              };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    [manager POST:[NSString stringWithFormat:@"%@/appordersr/findtodayinfo",HXEORDER] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"status"] integerValue] == 200) {
            if (_thePage == 1) {
                [self.collectionArray removeAllObjects];
            }
            NSDictionary *dic = responseObject[@"data"];
            TodayDataModel *model = [[TodayDataModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.collectionArray addObject:model];
            
            if (_thePage == 1) {
                [self.collectionView.mj_header endRefreshing];
            }
            [_collectionView reloadData];
        }else if ([responseObject[@"status"] integerValue] == 301){
            [self.collectionView.mj_header endRefreshing];
            [[AppDelegate mainAppDelegate] showLoginView];
        }else{
            [self.collectionView.mj_header endRefreshing];
            [MBProgressHUD showMessage:responseObject[@"msg"]];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.collectionView.mj_header endRefreshing];
    }];
    
}


/** 视图操作  */

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 2;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.collectionArray.count == 0) {
        return 0;
    } else {
        if (section == 0) {
            return 3;
        } else {
            return 9;
        }
    }
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TodayDataModel *model = self.collectionArray[0];
    
    //    NSLog(@"%@",model);
    NSArray *titleArr = @[@"今日订单",@"今日营业额",@"扫码收款"];
    
    NSArray *titleTwoArr = @[@"配菜助手",@"菜品管理",@"用户评价",@"结算管理",@"营销活动",@"消息中心",@"营业分析",@"经营数据",@"敬请期待"];
    NSArray *nameArr = @[@"sidedish",@"foodmanagement",@"userevaluation",@"settlement",@"activesite",@"messagecenter",@"businessanalysis",@"businessdata",@"comingsoon"];
    if (indexPath.section == 0) {
        
        ManagerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:managerCell forIndexPath:indexPath];
        
        cell.titleLableOne.text = titleArr[indexPath.row];
        
        if (indexPath.row == 0) {
            if (model.ordercount == nil) {
                cell.numberLable.text = @"0";
            }else{
                
                cell.numberLable.text = [NSString stringWithFormat:@"%@",model.ordercount];
                
            }
            
        }else if (indexPath.row == 1){
            
            cell.numberLable.text = [NSString stringWithFormat:@"%.2f",model.orderfeesum];
            
        }else{
            
            cell.numberLable.text = [NSString stringWithFormat:@"%.2f",model.orderqrfeesum];
            
        }
        return cell;
    }else{
        
        ManagerTwoCollectionViewCell *cellTwo = [collectionView dequeueReusableCellWithReuseIdentifier:managerTwoCell forIndexPath:indexPath];
        [cellTwo.imageView setImage:[UIImage imageNamed:nameArr[indexPath.row]]];
        cellTwo.titleLableTwo.text = titleTwoArr[indexPath.row];
        return cellTwo;
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //  TodayOrderViewController *todayOrderVC = [TodayOrderViewController new];
    //  TodayTurnoverViewController * todayTurnoverVC = [TodayTurnoverViewController new];
    ScavengingreceiptsViewController *scavengVC = [ScavengingreceiptsViewController new];
    
    UserReviewViewController *userReviewVC = [UserReviewViewController new];
    //  MessageCenterViewController *messageCenterVC = [MessageCenterViewController new];
    DishesManagerViewController *dishesManagerVC = [DishesManagerViewController new];
    self.hidesBottomBarWhenPushed = YES;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            //     [self.navigationController pushViewController:todayOrderVC animated:YES];
            
        }else if (indexPath.row == 1){
            
            //    [self.navigationController pushViewController:todayTurnoverVC animated:YES];
            
        }else {
            [self.navigationController pushViewController:scavengVC animated:YES];
        }
    }else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            [MBProgressHUD showError:@"该功能暂未开放"];
            //  [self.navigationController pushViewController:messageCenterVC animated:YES];
            
        }else if (indexPath.row == 1){
            
            [self.navigationController pushViewController:dishesManagerVC animated:YES];
            
        }else if (indexPath.row == 2){
            
            [self.navigationController pushViewController:userReviewVC animated:YES];
            
        }else if (indexPath.row == 3){
            //   [MBProgressHUD showError:@"该功能暂未开放"];
            SettlementViewController *settlementVC = [[SettlementViewController alloc]init];
            
            EditViewController *editVC = [EditViewController new];
            NSDictionary *partner = @{
                                      @"token": KUSERID
                                      };
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
            [manager POST:[NSString stringWithFormat:@"%@/appcommercial/findBankAccount",HXECOMMEN] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSLog(@"%@",responseObject);
                NSMutableArray *arr = [NSMutableArray array];
                if ([responseObject[@"status"] integerValue] == 200) {
                    arr = responseObject[@"data"];
                }
                if (arr.count == 0) {
                    self.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:settlementVC animated:YES];
                    editVC.datArray = arr;
                    self.hidesBottomBarWhenPushed = NO;
                    
                }else{
                    self.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:editVC animated:YES];
                    self.hidesBottomBarWhenPushed = NO;
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
            
            
        }else if (indexPath.row == 6){
            self.hidesBottomBarWhenPushed = YES;
            BusinessanalysisViewController *businessVC = [BusinessanalysisViewController new];
            [self.navigationController pushViewController:businessVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
    //        [MBProgressHUD showError:@"该功能暂未开放"];
        }else{
            
            [MBProgressHUD showError:@"该功能暂未开放"];
            
        }
        
    }
    self.hidesBottomBarWhenPushed = NO;
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
