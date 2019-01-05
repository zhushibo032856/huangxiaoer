//
//  NewViewController.m
//  HuangXiaoErShop
//
//  Created by apple on 2019/1/4.
//  Copyright © 2019年 aladdin. All rights reserved.
//

#import "NewViewController.h"
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
#import "MessageTypeViewController.h"
#import "MemberCenterViewController.h"

@interface NewViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UIView *headView;//头视图
@property (nonatomic, strong) UIImageView *shopPhotoView;//店铺图片
@property (nonatomic, strong) UILabel *nameLable;//店铺名
@property (nonatomic, strong) UIButton *detailButton;//详情按钮
@property (nonatomic, strong) UIButton *businessButton;//营业按钮

@property (nonatomic, strong) UICollectionView *firstCollectionView;
@property (nonatomic, strong) UICollectionView *secondCollectionView;

@property (nonatomic, strong) NSMutableArray *dataArray;//数据源

@property (nonatomic, assign) NSInteger shopStutas;//营业状态
@property (nonatomic, strong) NSString *userImageUrl;
@property (nonatomic, strong) NSString *userName;

@property (nonatomic, strong) NSMutableArray *collectionArray;

@property (nonatomic, assign) NSInteger thePage;

@property (nonatomic, strong) NSString *ordercount;
@property (nonatomic, assign) CGFloat orderfeesum;
@property (nonatomic, assign) CGFloat orderqrfeesum;

@end

static NSString * const managerCell = @"managerCollectionViewCell";
static NSString * const managerTwoCell = @"managerTwoCollectionViewCell";

@implementation NewViewController

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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self requestShopManager];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setHeadView];
    [self setDetailView];
    [self setbusinessButton];
    [self setCollectionView];
    
    [self requestDataForToday];
    // Do any additional setup after loading the view.
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
            _userImageUrl = model.logoImage;
            _userName = model.userName;
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:dic[@"logoImage"] forKey:@"imageurl"];
            [user setObject:dic[@"shopSign"] forKey:@"shopName"];
            [user setObject:dic[@"address"] forKey:@"shopAddress"];
            [user setObject:dic[@"id"] forKey:@"shopId"];;
            [user setObject:dic[@"userName"] forKey:@"userName"];
            [user synchronize];
            //请求完数据立马刷新按钮状态
            if (_shopStutas == 1) {
                [_businessButton setBackgroundImage:[UIImage imageNamed:@"openShop"] forState:UIControlStateNormal];
                [UIApplication sharedApplication].idleTimerDisabled = YES;
                
            }else{
                [_businessButton setBackgroundImage:[UIImage imageNamed:@"closedShop"] forState:UIControlStateNormal];
                [UIApplication sharedApplication].idleTimerDisabled = NO;
            }
            //     NSLog(@"======%ld",_shopStutas);
 
            [self setDetailView];
        }else{
            [MBProgressHUD showError:responseObject[@"msg"]];
            
        }
        NSLog(@"%@%@",KUSERNAME,KUSERIMAGEURL);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];
    
    
}

- (void)setHeadView{
    
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight / 5 + 30)];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"manageBack"]];
    imageView.frame = _headView.frame;
    [_headView addSubview:imageView];
    [self.view addSubview:_headView];
    
}

- (void)setDetailView{
    _shopPhotoView = [[UIImageView alloc]initWithFrame:CGRectMake(20, CGRectGetHeight(_headView.frame) / 3 , CGRectGetHeight(_headView.frame) / 3 + 20, CGRectGetHeight(_headView.frame) / 4 + 15)];
    _shopPhotoView.layer.masksToBounds = YES;
    _shopPhotoView.layer.cornerRadius = 6;
    _shopPhotoView.backgroundColor = [UIColor redColor];
    [_shopPhotoView sd_setImageWithURL:KUSERIMAGEURL placeholderImage:[UIImage imageNamed:@"userName"]];
    [_headView addSubview:_shopPhotoView];
    
    _nameLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_shopPhotoView.frame) + 20, CGRectGetHeight(_headView.frame) / 3 , kScreenWidth - _shopPhotoView.frame.size.width - 20 - _businessButton.frame.size.width - 30, 30)];
    NSLog(@"%@%@",KUSERNAME,KUSERIMAGEURL);
    _nameLable.text = KUSERNAME;
    [_nameLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    _nameLable.textAlignment = NSTextAlignmentLeft;
    [_headView addSubview:_nameLable];
    
    _detailButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _detailButton.frame = CGRectMake(CGRectGetMaxX(_shopPhotoView.frame) + 20, CGRectGetMaxY(_nameLable.frame) +5 , 80, 15);
    [_detailButton setBackgroundImage:[UIImage imageNamed:@"shopDetailMessage"] forState:UIControlStateNormal];
    [_detailButton addTarget:self action:@selector(pushDetailShopView:) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:_detailButton];
}

- (void)setbusinessButton{
    
    _businessButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _businessButton.frame = CGRectMake(kScreenWidth - CGRectGetHeight(_headView.frame) / 3 - 50, CGRectGetHeight(_headView.frame) / 3 + 10, kScreenWidth * 0.3, kScreenWidth * 0.1);
    
    if (_shopStutas == 1) {
        [_businessButton setBackgroundImage:[UIImage imageNamed:@"openShop"] forState:UIControlStateNormal];
    }else{
        [_businessButton setBackgroundImage:[UIImage imageNamed:@"closedShop"] forState:UIControlStateNormal];
    }
    
    [_businessButton addTarget:self action:@selector(changeShopBusiness:) forControlEvents:UIControlEventTouchUpInside];
    
    [_headView addSubview:_businessButton];
}

- (void)setCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(kScreenWidth / 3 - 12, 100);
    
    layout.minimumLineSpacing = 2.0;//设置最小行间距
    layout.minimumInteritemSpacing = 2;//item间距(最小值)
    layout.sectionInset = UIEdgeInsetsMake(1, 1, 10, 1);
    
    _firstCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(_headView.frame) - 40, kScreenWidth - 30, 90) collectionViewLayout:layout];
    _firstCollectionView.backgroundColor = [UIColor whiteColor];
    _firstCollectionView.scrollEnabled = NO;
    _firstCollectionView.layer.cornerRadius = 10;
    _firstCollectionView.layer.masksToBounds = NO;
    _firstCollectionView.layer.shadowColor = [UIColor blackColor].CGColor;
    _firstCollectionView.layer.shadowOffset = CGSizeMake(0, 0);
    _firstCollectionView.layer.shadowOpacity = 0.5;
    _firstCollectionView.layer.shadowRadius = 5;
    _firstCollectionView.delegate = self;
    _firstCollectionView.dataSource = self;
    [_firstCollectionView registerClass:[ManagerCollectionViewCell class] forCellWithReuseIdentifier:managerCell];
    for (int i = 1; i < 3; i ++) {
        UILabel *lableFirst = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth - 30 - 4) / 3 * i, 10, 1, 80)];
        lableFirst.backgroundColor = kColor(240, 240, 240);
        [_firstCollectionView addSubview:lableFirst];
        
    }
    [_firstCollectionView reloadData];
    [self.view addSubview:_firstCollectionView];
    
    
    UICollectionViewFlowLayout *secondLayout = [[UICollectionViewFlowLayout alloc]init];
    secondLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    secondLayout.itemSize = CGSizeMake(kScreenWidth / 3 - 12, kScreenWidth / 3 - 12);
    
    secondLayout.minimumLineSpacing = 2.0;//设置最小行间距
    secondLayout.minimumInteritemSpacing = 2;//item间距(最小值)
    secondLayout.sectionInset = UIEdgeInsetsMake(1, 1, 10, 1);
    
    _secondCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(_firstCollectionView.frame) + 20, kScreenWidth - 30, kScreenWidth - 30) collectionViewLayout:secondLayout];
    _secondCollectionView.backgroundColor = [UIColor whiteColor];
    _secondCollectionView.layer.cornerRadius = 10;
    _secondCollectionView.layer.masksToBounds = NO;
    _secondCollectionView.layer.shadowColor = [UIColor blackColor].CGColor;
    _secondCollectionView.layer.shadowOffset = CGSizeMake(0, -3);
    _secondCollectionView.layer.shadowOpacity = 0.5;
    _secondCollectionView.layer.shadowRadius = 10;
    _secondCollectionView.delegate = self;
    _secondCollectionView.dataSource = self;
    _secondCollectionView.scrollEnabled = NO;
    [_secondCollectionView registerClass:[ManagerTwoCollectionViewCell class] forCellWithReuseIdentifier:managerTwoCell];
    [self.view addSubview:_secondCollectionView];
    
    for (int i = 1; i < 3; i ++) {
        UILabel *lableOne = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth - 30 - 4) / 3 * i, 0, 1, kScreenWidth - 30)];
        lableOne.backgroundColor = kColor(240, 240, 240);
        [_secondCollectionView addSubview:lableOne];
        
    }
    
    for (int a = 1; a < 3; a ++) {
        UILabel *lineLable = [[UILabel alloc]initWithFrame:CGRectMake(0, (kScreenWidth - 30 - 4) / 3 * a, kScreenWidth - 30, 1)];
        lineLable.backgroundColor = kColor(240, 240, 240);
        [_secondCollectionView addSubview:lineLable];
    }
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
                              @"page": @(_thePage),
                              @"size": @"20",
                              @"token": KUSERID
                              };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    [manager POST:[NSString stringWithFormat:@"%@/appordersr/findtodayinfo",HXEORDER] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     //   NSLog(@"%@",responseObject);
        if ([responseObject[@"status"] integerValue] == 200) {
            
            [_collectionArray removeAllObjects];
            NSDictionary *dic = responseObject[@"data"];
            TodayDataModel *model = [[TodayDataModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.collectionArray addObject:model];
            
            [_firstCollectionView reloadData];
        }else if ([responseObject[@"status"] integerValue] == 301){
            [[AppDelegate mainAppDelegate] showLoginView];
        }else{
            [MBProgressHUD showMessage:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
    
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_firstCollectionView == collectionView) {
        return 3;
    }else{
        return 9;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_firstCollectionView == collectionView) {
        ManagerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:managerCell forIndexPath:indexPath];
        TodayDataModel *model = _collectionArray.firstObject;
        NSArray *titleArr = @[@"有效订单",@"预计收入",@"扫码收款"];
        cell.titleLableOne.text = titleArr[indexPath.row];
        if (indexPath.row == 0) {
            cell.numberLable.text = [NSString stringWithFormat:@"%@",model.ordercount];
        }else if (indexPath.row == 1){
            cell.numberLable.text = [NSString stringWithFormat:@"%.2f",model.orderfeesum];
        }else{
            cell.numberLable.text = [NSString stringWithFormat:@"%.2f",model.orderqrfeesum];
        }
        
        return cell;
    }else{
        NSArray *titleTwoArr = @[@"会员中心",@"菜品管理",@"消息中心",@"结算管理",@"营销活动",@"用户评价",@"营业分析",@"经营数据",@"敬请期待"];
        NSArray *nameArr = @[@"MemberCenter",@"foodmanagement",@"messagecenter",@"settlement",@"activesite",@"userevaluation",@"businessanalysis",@"businessdata",@"comingsoon"];
        ManagerTwoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:managerTwoCell forIndexPath:indexPath];
        [cell.imageView setImage:[UIImage imageNamed:nameArr[indexPath.row]]];
        cell.titleLableTwo.text = titleTwoArr[indexPath.row];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //  TodayOrderViewController *todayOrderVC = [TodayOrderViewController new];
    //  TodayTurnoverViewController * todayTurnoverVC = [TodayTurnoverViewController new];
    
    if (_firstCollectionView == collectionView) {
        if (indexPath.row == 2) {
            ScavengingreceiptsViewController *scavengVC = [ScavengingreceiptsViewController new];
            scavengVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:scavengVC animated:YES];
            scavengVC.hidesBottomBarWhenPushed = NO;
        }
    }else{
        UserReviewViewController *userReviewVC = [UserReviewViewController new];
        MessageTypeViewController *messageTypeVC = [MessageTypeViewController new];
        DishesManagerViewController *dishesManagerVC = [DishesManagerViewController new];
        self.hidesBottomBarWhenPushed = YES;
        if (indexPath.row == 0) {
            
            MemberCenterViewController *memberVC = [MemberCenterViewController new];
            memberVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:memberVC animated:YES];
            memberVC.hidesBottomBarWhenPushed = NO;
            
        }else if (indexPath.row == 1){
            
            [self.navigationController pushViewController:dishesManagerVC animated:YES];
            
        }else if (indexPath.row == 5){
            
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
            
            
        }else if (indexPath.row == 2){
            // self.hidesBottomBarWhenPushed = YES;
            messageTypeVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:messageTypeVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }else if (indexPath.row == 6){
            self.hidesBottomBarWhenPushed = YES;
            BusinessanalysisViewController *businessVC = [BusinessanalysisViewController new];
            [self.navigationController pushViewController:businessVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
            //        [MBProgressHUD showError:@"该功能暂未开放"];
        }else if (indexPath.row == 8){
            [MBProgressHUD showError:@"该功能暂未开放"];
            
        }else{
            
            [MBProgressHUD showError:@"该功能暂未开放"];
            
        }
        self.hidesBottomBarWhenPushed = NO;
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
