//
//  UserReviewViewController.m
//  HXEshop
//
//  Created by apple on 2018/3/4.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "UserReviewViewController.h"
#import "ShopTableViewCell.h"
#import "UserReviewModel.h"
#import "HYBStarEvaluationView.h"
#import "UserHeadView.h"
#import "UesrView.h"
#import "XJWTextView.h"

@interface UserReviewViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UILabel *lableOne;
@property (nonatomic, strong) UILabel *numberLable;

@property (nonatomic, strong) HYBStarEvaluationView *shopscoreView;//店铺评分
@property (nonatomic, strong) HYBStarEvaluationView *productscoreView;//菜品评分
@property (nonatomic, strong) HYBStarEvaluationView *sumscoreView;//综合评分

@property (nonatomic, assign) NSInteger thePage;

/*
 评论按钮
 */
@property (nonatomic, strong) XJWTextView *xjwTextView;
@end

static NSString * const reviewCell = @"shopTableviewCell";

@implementation UserReviewViewController
- (NSMutableArray *)dataArray{
    
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
    self.navigationItem.title = @"用户评价";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
    
}

- (void)leftBarBtnClicked:(UIButton *)btn{
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor(240, 240, 240);
 
    [self creatHeadView];
    [self initTableView];
    [self setRefresh];
    // Do any additional setup after loading the view.
}

- (void)setRefresh {
    _thePage = 1;
    __block typeof(self)weakself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.tableView.mj_footer resetNoMoreData];
        weakself.thePage = 1;
        [self requsetDataWithReview];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.thePage += 1;
        [self requsetDataWithReview];
        [self.tableView.mj_footer endRefreshing];
    }];
    // 进入界面时刷新
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)creatHeadView{
    
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth , 85)];
    _headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_headView];
    
    _lableOne = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 75, 55)];
    _lableOne.textColor = kColor(255, 210, 0);
    [_lableOne setFont:[UIFont fontWithName:@"Helvetica-Bold" size:35]];
    
    _sumscoreView = [[HYBStarEvaluationView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_lableOne.frame), 10, kScreenWidth / 2 - 85, 20) numberOfStars:5 isVariable:NO];
    _sumscoreView.fullScore = 5.0;
    [_headView addSubview:_sumscoreView];
    
    _numberLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_lableOne.frame), 35, kScreenWidth / 2 - 80, 20)];
    _numberLable.font = [UIFont systemFontOfSize:12];
    _numberLable.textColor = kColor(210, 210, 210);
    [_headView addSubview:_numberLable];
    
    UILabel *lableTwo = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, kScreenWidth / 2 - 15, 20)];
    lableTwo.font = [UIFont systemFontOfSize:13];
    lableTwo.text = @"快来看看有什么神评论!";
    
    [self.headView addSubview:_lableOne];
    [self.headView addSubview:lableTwo];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 , 10, 1, 70)];
    [lineView setBackgroundColor:[UIColor lightGrayColor]];
    [self.headView addSubview:lineView];
    
    UILabel *lableThree = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth / 2 + 7.5, 17.5, 55, 20)];
    lableThree.font = [UIFont systemFontOfSize:13];
    lableThree.text = @"店铺评分";
    UILabel *lableFour = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth / 2 + 7.5, 47.5, 55, 20)];
    lableFour.font = [UIFont systemFontOfSize:13];
    lableFour.text = @"菜品评分";
    
    _shopscoreView = [[HYBStarEvaluationView alloc]initWithFrame:CGRectMake(kScreenWidth / 2 + 65, 16.5, 80, 20) numberOfStars:5 isVariable:NO];
    _shopscoreView.fullScore = 5;
    _shopscoreView.isContrainsHalfStar = YES;

    _productscoreView = [[HYBStarEvaluationView alloc]initWithFrame:CGRectMake(kScreenWidth / 2 + 65, 47.5, 80, 20) numberOfStars:5 isVariable:NO];
    _productscoreView.fullScore = 5;
    _productscoreView.isContrainsHalfStar = YES;
    
    [self.headView addSubview:_shopscoreView];
    [self.headView addSubview:_productscoreView];
    [self.headView addSubview:lableThree];
    [self.headView addSubview:lableFour];
}
- (void)initTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 90, kScreenWidth - 20, kScreenHeight - kNavHeight - 85) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = kColor(240, 240, 240);
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = NO;
    _tableView.estimatedRowHeight = 100;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    
    _tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    _tableView.estimatedSectionHeaderHeight = 100;
    [_tableView registerNib:[UINib nibWithNibName:@"ShopTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:reviewCell];
    [self.view addSubview:_tableView];
}

- (void)requsetDataWithReview{
    
    NSDictionary *partner = @{
                              @"page": @(_thePage),
                              @"size": @"20",
                              @"token": KUSERID
                              };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    [manager POST:[NSString stringWithFormat:@"%@/appcommercial/findallevaluation",HXECOMMEN] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        if ([responseObject[@"status"] integerValue] == 200) {
            if (_thePage == 1) {
                [self.dataArray removeAllObjects];
            }
            NSDictionary *dicData = responseObject[@"data"];
            _lableOne.text = [NSString stringWithFormat:@"%@",dicData[@"sumscore"]];
            _sumscoreView.actualScore = [dicData[@"sumscore"] integerValue];
            _shopscoreView.actualScore = [dicData[@"shopscore"] integerValue];
            _productscoreView.actualScore = [dicData[@"productscore"] integerValue];
            
            NSDictionary *dicEva = dicData[@"evaluationlist"];
            _numberLable.text = [NSString stringWithFormat:@"%@人参与评分",dicEva[@"total"]];
            NSArray *arr = dicEva[@"rows"];
            for (NSDictionary *dic in arr) {
                UserReviewModel *model = [[UserReviewModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
            }
            if (_thePage == 1) {
                [_tableView.mj_header endRefreshing];
            }else{
                if (arr.count == 0) {
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [_tableView.mj_footer endRefreshing];
                }
            }
            [_tableView reloadData];
        }else {
            [_tableView.mj_header endRefreshing];
            [MBProgressHUD showMessage:responseObject[@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
   //     NSLog(@"%@", error);
        [MBProgressHUD showError:@"连接不到服务器"];
    }];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UserReviewModel *model = self.dataArray[section];
    if (kStringIsEmpty(model.shopReply)) {
        UserHeadView *headView = [UserHeadView SetHeadView];
        [headView.reviewButton addTarget:self action:@selector(shopReviewWith:) forControlEvents:UIControlEventTouchUpInside];
        [headView.reviewButton setTag:100 + section];
        [headView headViewSetDataWith:model];
        return headView;
    }else{
        UesrView *headView = [UesrView SetHeadView];
        [headView headViewSetDataWith:model];
        return headView;
    }

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    UserReviewModel *model = self.dataArray[section];
    if (kStringIsEmpty(model.shopReply)) {
        return 0;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserReviewModel *model = self.dataArray[indexPath.section];
    ShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reviewCell forIndexPath:indexPath];
    [cell setDataForCellWith:model];
    cell.selectionStyle = NO;
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark  评论操作
- (XJWTextView *)xjwTextView{
    
    if (!_xjwTextView) {
        _xjwTextView = [[XJWTextView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenHeight, 49)];
        _xjwTextView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        [_xjwTextView setPlaceholderText:@"请输入文字"];
        [self.view addSubview:_xjwTextView];
       
    }
    return _xjwTextView;
}

- (void)shopReviewWith:(UIButton *)sender{
    
    UserReviewModel *model = self.dataArray[sender.tag - 100];
    [self.xjwTextView.textView becomeFirstResponder];
    __block typeof(self)weakself = self;
    
    _xjwTextView.TextBlcok = ^(NSString *text) {
        [weakself uploadDataWithShopReview:text evaluationId:model.id index:sender.tag - 100];
    };
    
}

- (void)uploadDataWithShopReview:(NSString *)review
                    evaluationId:(NSString *)evaluationId
                           index:(NSInteger)index
{
    
    NSDictionary *partner = @{
                              @"evaluationId": evaluationId,
                              @"shopReply": review,
                              @"token": KUSERID
                              };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    [manager POST:[NSString stringWithFormat:@"%@/appcommercial/addshopre",HXECOMMEN] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     //   NSLog(@"%@",responseObject);
        if ([responseObject[@"status"] integerValue] == 200) {
            [MBProgressHUD showSuccess:@"回复成功"];
           
            [self setRefresh];
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
