
//
//  DishesManagerViewController.m
//  HXEshop
//
//  Created by apple on 2018/3/2.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "DishesManagerViewController.h"
#import "DishesManagerTableViewCell.h"
#import "DishesRightTableViewCell.h"
#import "LeftDataModel.h"
#import "RightDataModel.h"
//#import "CRNetBinaryDataClass.h"
#import "FoodViewController.h"
#import "CateGoryViewController.h"
#import "FoodViewController.h"
#import "FoodEditViewController.h"
#import "ScanImage.h"

@interface DishesManagerViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;


@property (nonatomic, strong) NSMutableArray *leftDataArr;
@property (nonatomic, strong) NSMutableArray *rightDataArr;
@property (nonatomic, strong) NSMutableArray *rightArr;
@property (nonatomic, assign) NSInteger length;
@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) NSString *foodID;

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, assign) NSInteger thePage;

@end

static NSString * const dishesCell = @"leftCellIdentifier";
static NSString * const dishesRightCell = @"rightCellIdentifier";

@implementation DishesManagerViewController

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

- (NSMutableArray *)leftDataArr{
    if (!_leftDataArr) {
        _leftDataArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _leftDataArr;
}

- (NSMutableArray *)rightDataArr{
    if (!_rightDataArr) {
        _rightDataArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _rightDataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor(240, 240, 240);
    self.rightArr = [NSMutableArray array];
    
    [self creatAutoLayout];
    
    [self setRefresh];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setRefresh) name:@"notiEdit" object:nil];
}

- (void)setRefresh {
    
    _thePage = 1;
    __block typeof(self)weakself = self;
    self.leftTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.leftTableView.mj_footer resetNoMoreData];
        weakself.thePage = 1;
        [self reloadRightData];
    }];
    self.rightTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.rightTableView.mj_footer resetNoMoreData];
        weakself.thePage = 1;
        [self reloadRightData];
    }];
    
    
    self.leftTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.thePage = 1;
        [self reloadRightData];
        [self.leftTableView.mj_footer endRefreshing];
    }];
    self.rightTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.thePage = 1;
        [self reloadRightData];
        [self.rightTableView.mj_footer endRefreshing];
    }];
    
    // 进入界面时刷新
    [self.leftTableView.mj_header beginRefreshing];
    [self.rightTableView.mj_header beginRefreshing];
}

- (void)creatAutoLayout{
    // MARK: - 左边的 tableView
    
    CGFloat commen = kNav_H + kTabbar_H;
    
    if (iPhoneX) {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth * 0.3, kScreenHeight - commen - 50)];
    }else{
    _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth * 0.3, kScreenHeight - 110)];
    }
    
    [_leftTableView setSeparatorColor:kColor(240, 240, 240)];
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    _leftTableView.backgroundColor = kColor(240, 240, 240);
    [_leftTableView registerClass:[DishesManagerTableViewCell class] forCellReuseIdentifier:dishesCell];
    _leftTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.leftTableView];
    
    // MARK: - 右边的 tableView
    
    if (iPhoneX) {
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth  * 0.3  , 0, kScreenWidth * 0.7, kScreenHeight - commen - 50)];
    }else{
    _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth  * 0.3  , 0, kScreenWidth * 0.7, kScreenHeight - 110)];
    }
    [_rightTableView setSeparatorColor:kColor(240, 240, 240)];
    _rightTableView.delegate = self;
    _rightTableView.dataSource = self;
    [_rightTableView registerClass:[DishesRightTableViewCell class] forCellReuseIdentifier:dishesRightCell];
    _rightTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.rightTableView];

    /** 分类管理 */
    _leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_leftButton setBackgroundColor:[UIColor whiteColor]];
    _leftButton.frame = CGRectMake(0, self.leftTableView.height, kScreenWidth * 0.3, 50);
    [_leftButton setTitle:@"品类管理" forState:UIControlStateNormal];
    [_leftButton setTintColor:[UIColor blackColor]];
    [_leftButton addTarget:self action:@selector(classMessage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_leftButton];
    
    /** 上架商品 */
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(CGRectGetMaxX(_leftButton.frame), CGRectGetMaxY(self.rightTableView.frame), kScreenWidth * 0.7, 50);
    [_rightButton setTitle:@" 添加商品" forState:UIControlStateNormal];
    [_rightButton setImage:[UIImage imageNamed:@"addShop"] forState:UIControlStateNormal];
    [_rightButton setTintColor:[UIColor whiteColor]];
    [_rightButton addTarget:self action:@selector(addCellForEdit) forControlEvents:UIControlEventTouchUpInside];
    [_rightButton setBackgroundImage:[UIImage imageNamed:@"backcolor"] forState:UIControlStateNormal];
    [self.view addSubview:_rightButton];
    
}
//上架商品
- (void)addCellForEdit{
    
    self.hidesBottomBarWhenPushed = YES;
    FoodViewController *foodVC = [[FoodViewController alloc]init];
    
    foodVC.dataSource = self.leftDataArr;
    [self.navigationController pushViewController:foodVC animated:YES];

}

- (void)setNavigationController{
    
  //  [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"backcolor"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationItem.title = @"菜品管理";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
    
}
- (void)leftBarBtnClicked:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

/** 分类管理 */
- (void)classMessage:(UIButton *)sender{
    
    self.hidesBottomBarWhenPushed = YES;
    CateGoryViewController *cateVC = [[CateGoryViewController alloc]init];
    cateVC.count = self.leftDataArr.count;
    [self.navigationController pushViewController:cateVC animated:YES];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.leftTableView) {
        
        return 50;
        
    }else {
        
        return 100;
        
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.leftTableView) {
        
        return _leftDataArr.count;
        
    }else {
        
        return self.rightArr.count;
        
        
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    // 左边的
    if (tableView == self.leftTableView) {
        
        LeftDataModel *model = self.leftDataArr[indexPath.row];
        DishesManagerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dishesCell forIndexPath:indexPath];
 
        cell.backgroundColor = kColor(240, 240, 240);
        cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = kColor(255, 255, 255);
        cell.dishesLable.text = model.name;
        NSInteger selectedIndex = 0;
        NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        [tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        return cell;
        // 右边的
    } else {
      
        RightDataModel *model = self.rightArr[indexPath.row];
        DishesRightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dishesRightCell forIndexPath:indexPath];
    //    NSLog(@"%ld=====%@",model.id,model.tb_category_categoryId);
        cell.index = indexPath.row;
        [cell cellViewsValueWithModel:model];
        
        UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick1:)];
        [cell.foodImageView addGestureRecognizer:tapGestureRecognizer1];
        //让UIImageView和它的父类开启用户交互属性
        [cell.foodImageView setUserInteractionEnabled:YES];
        __weak typeof(self)weakSelf = self;
        
        cell.block = ^(NSInteger index, NSInteger buttonTag) {
            
            [weakSelf didChanggeButtonWithIndex:index ButtonTag:buttonTag];
        };
        
        return cell;
    }
    
}
-(void)scanBigImageClick1:(UITapGestureRecognizer *)tap{
   // NSLog(@"点击图片");
    UIImageView *clickedImageView = (UIImageView *)tap.view;
    [ScanImage scanBigImageWithImageView:clickedImageView];
}
- (void)didChanggeButtonWithIndex:(NSInteger)index
                        ButtonTag:(NSInteger)buttonTag{
    RightDataModel *model = self.rightArr[index];
    NSString *status;
    if (buttonTag == 500) {
        self.hidesBottomBarWhenPushed = YES;
        FoodEditViewController *foodVC = [[FoodEditViewController alloc]init];
        foodVC.dataSource = self.rightArr;
        foodVC.cateDataArr = self.leftDataArr;
        foodVC.index = index;
        foodVC.model = model;
        [self.navigationController pushViewController:foodVC animated:YES];
        
    }else if (buttonTag == 600){
        status = @"2";
        [self shangJiaWithStatus:status ShopID:model.id Index:index];
        
    }else if (buttonTag == 700){
        status = @"3";
        [self shangJiaWithStatus:status ShopID:model.id Index:index];
    }
    
}


- (void)shangJiaWithStatus:(NSString *)status
                    ShopID:(NSInteger)shopID
                    Index:(NSInteger)index{
    
    NSDictionary *partner = @{
                              @"id": @(shopID),
                              @"status": status,
                              @"token": KUSERID
                              };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html", nil];
    
    [manager POST:[NSString stringWithFormat:@"%@/appproduct/update",HXECOMMEN] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      //  NSLog(@"%@",responseObject);
        
        if ([responseObject[@"status"] integerValue] == 200) {
            if ([status integerValue] == 2) {
                [MBProgressHUD showSuccess:@"上架成功"];
            }else if([status integerValue] == 3){
                [MBProgressHUD showSuccess:@"下架成功"];
            }
            RightDataModel *model = self.rightArr[index];
            model.status = status;
            //1.当前所要刷新的cell，传入要刷新的 行数 和 组数
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            //2.将indexPath添加到数组
            NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
            [self.rightTableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
        }else{
            [MBProgressHUD showError:@"操作失败，请重新尝试"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 如果是 左侧的 tableView 直接return
    if (scrollView == self.leftTableView) return;
    
    // 取出显示在 视图 且最靠上 的 cell 的 indexPath
    NSIndexPath *topHeaderViewIndexpath = [[self.rightTableView indexPathsForVisibleRows] firstObject];
    
    // 左侧 talbelView 移动的 indexPath
    NSIndexPath *moveToIndexpath = [NSIndexPath indexPathForRow:topHeaderViewIndexpath.section inSection:0];
    
    // 移动 左侧 tableView 到 指定 indexPath 居中显示
 //   [self.leftTableView selectRowAtIndexPath:moveToIndexpath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    
}

// 当拖动右边 TableView 的时候，处理左边 TableView
- (void)selectRowAtIndexPath:(NSInteger)index
{
    [_leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
}

//MARK: - 点击 cell 的代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 选中 左侧 的 tableView
    if (tableView == self.leftTableView) {
        
        [self.rightArr removeAllObjects];
        NSMutableArray *arr = self.rightDataArr[indexPath.row];
        for (RightDataModel *model in arr) {
            [self.rightArr addObject:model];
        }
        [self.rightTableView reloadData];
        
    }
}



/** 商品详情信息请求 */
- (void)reloadRightData{
    
    NSDictionary *partner = @{
                              @"token":KUSERID
                              };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    
    [manager POST:[NSString stringWithFormat:@"%@/appproduct/category/findallall",HXECOMMEN] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"status"] integerValue] == 200) {
            if (_thePage == 1) {
                [self.leftDataArr removeAllObjects];
                [self.rightDataArr removeAllObjects];
                [self.rightArr removeAllObjects];
            }
            NSArray *dataArr = responseObject[@"data"];
            for (NSDictionary *dict in dataArr) {
                NSArray *productArray = dict[@"product"];
                LeftDataModel *model = [[LeftDataModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [self.leftDataArr addObject:model];
                NSMutableArray *productMutableArray = [NSMutableArray array];
                for (NSDictionary *productDict in productArray) {
                    RightDataModel *model = [[RightDataModel alloc]init];
                    [model setValuesForKeysWithDictionary:productDict];
                    [productMutableArray addObject:model];
                }
                [self.rightDataArr addObject:productMutableArray];
            }
            
            NSMutableArray *arr = [self.rightDataArr firstObject];
            for (RightDataModel *model in arr) {
                [self.rightArr addObject:model];
            }
            if (_thePage == 1) {
                [self.leftTableView.mj_header endRefreshing];
                [self.rightTableView.mj_header endRefreshing];
            }else{
                if (arr.count == 0) {
                    [self.rightTableView.mj_footer endRefreshingWithNoMoreData];
            //        [self.leftTableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [self.rightTableView.mj_footer endRefreshing];
              //      [self.leftTableView.mj_footer endRefreshing];
                }
            }
           [self.rightTableView reloadData];
             [self.leftTableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

