//
//  UserReviewViewController.m
//  HXEshop
//
//  Created by apple on 2018/3/4.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "UserReviewViewController.h"
#import "UserReviewTableViewCell.h"
#import "UserReviewModel.h"
#import "UserAssessModel.h"
#import "HYBStarEvaluationView.h"

@interface UserReviewViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableviewReview;

@property (nonatomic, strong) HYBStarEvaluationView *starViewOne;
@property (nonatomic, strong) HYBStarEvaluationView *starViewTwo;

@property (nonatomic, strong) UserAssessModel *assessModel;

@property (nonatomic, assign) BOOL isRefresh;

@property (nonatomic, assign) NSInteger thePage;

@end

static NSString * const reviewCell = @"reviewTableviewCell";

@implementation UserReviewViewController

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
    self.navigationItem.title = @"用户评价";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
    
}

- (void)leftBarBtnClicked:(UIButton *)btn{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
 
    [self creatHeadViewAndTableView];
    
    [self setRefresh];
    // Do any additional setup after loading the view.
}



- (void)creatHeadViewAndTableView{
    
    _headView = [[UIView alloc]initWithFrame:CGRectMake(5, 5, kScreenWidth - 10, 80)];
    _headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_headView];
    
    UILabel *lableOne = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, kScreenWidth / 2 - 40, 20)];
    lableOne.textAlignment = NSTextAlignmentCenter;
    lableOne.textColor = [UIColor redColor];
    lableOne.text = @"4.25";
    UILabel *lableTwo = [[UILabel alloc]initWithFrame:CGRectMake(20, 45, kScreenWidth / 2 - 40, 20)];
    lableTwo.font = [UIFont systemFontOfSize:13];
    lableTwo.textAlignment = NSTextAlignmentCenter;
    lableTwo.text = @"综合评分";
    
    [self.headView addSubview:lableOne];
    [self.headView addSubview:lableTwo];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 5, 10, 1, 60)];
    [lineView setBackgroundColor:[UIColor lightGrayColor]];
    [self.headView addSubview:lineView];
    
    UILabel *lableThree = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth / 2 + 15, 15, 60, 20)];
    lableThree.font = [UIFont systemFontOfSize:13];
    lableThree.text = @"店铺评分";
    UILabel *lableFour = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth / 2 + 15, 45, 60, 20)];
    lableFour.font = [UIFont systemFontOfSize:13];
    lableFour.text = @"菜品评分";
    
    
    _starViewOne = [[HYBStarEvaluationView alloc]initWithFrame:CGRectMake(kScreenWidth / 2 +80, 15, 80, 20) numberOfStars:5 isVariable:NO];
    
//    _starViewOne.actualScore = [self.assessModel.shopscore floatValue];
    _starViewOne.actualScore = 4.00;
    _starViewOne.fullScore = 5;
    _starViewOne.isContrainsHalfStar = YES;

    _starViewTwo = [[HYBStarEvaluationView alloc]initWithFrame:CGRectMake(kScreenWidth / 2 +80, 45, 80, 20) numberOfStars:5 isVariable:NO];
    _starViewTwo.actualScore = 4.50;
    _starViewTwo.fullScore = 5;
    _starViewTwo.isContrainsHalfStar = YES;
    
    
    
    [self.headView addSubview:_starViewOne];
    [self.headView addSubview:_starViewTwo];
    [self.headView addSubview:lableThree];
    [self.headView addSubview:lableFour];
    
    
    _tableviewReview = [[UITableView alloc]initWithFrame:CGRectMake(0, 80, kScreenWidth, kScreenHeight - 140)];
    [_tableviewReview registerClass:[UserReviewTableViewCell class] forCellReuseIdentifier:reviewCell];
    
    _tableviewReview.sectionHeaderHeight = 5;
    _tableviewReview.sectionFooterHeight = 5;
    _tableviewReview.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0.0f,0.0f,kScreenWidth,5)];
    _tableviewReview.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0.0f,0.0f,kScreenWidth,5)];
    
    
    [self.view addSubview:_tableviewReview];
    
    _tableviewReview.delegate = self;
    _tableviewReview.dataSource = self;
    
}
- (void)setRefresh {
    _thePage = 1;
    __block typeof(self)weakself = self;
    self.tableviewReview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.tableviewReview.mj_footer resetNoMoreData];
        weakself.thePage = 1;
        [self requsetDataWithReview];
    }];
    
    self.tableviewReview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.thePage = 1;
        [self.tableviewReview.mj_footer endRefreshing];
    }];
    // 进入界面时刷新
    [self.tableviewReview.mj_header beginRefreshing];
    
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
            self.assessModel = [[UserAssessModel alloc]init];
            [self.assessModel setValuesForKeysWithDictionary:dicData];
            
            NSDictionary *dicEva = dicData[@"evaluationlist"];
            NSArray *arr = dicEva[@"rows"];
            for (NSDictionary *dic in arr) {
                UserReviewModel *model = [[UserReviewModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
            }
            if (_thePage == 1) {
                [self.tableviewReview.mj_header endRefreshing];
            }else{
                if (arr.count == 0) {
                    [self.tableviewReview.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [self.tableviewReview.mj_footer endRefreshing];
                }
            }
            [self.tableviewReview reloadData];
        }else {
            [self.tableviewReview.mj_header endRefreshing];
            [MBProgressHUD showMessage:responseObject[@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
   //     NSLog(@"%@", error);
        [MBProgressHUD showError:@"连接不到服务器"];
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 110;
    
}

- (NSInteger)numberOfSectio0nsInTableView:(UITableView *)tableView{
    
    return 1;
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
         return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UserReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reviewCell forIndexPath:indexPath];
    
    UserReviewModel *model = self.dataArray[indexPath.row];
    NSString *string = [NSString stringWithFormat:@"%@",model.images];
    NSLog(@"%@",model.images);
    [cell.userImage sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:[UIImage imageNamed:@"userName"]];
    
    cell.userNameLable.text = model.nickName;
    cell.userNumberLable.text = [[NSString stringWithFormat:@"%@",model.phone]stringByReplacingCharactersInRange:NSMakeRange(3, 5) withString:@"*****"];
    cell.timeLable.text = [[NSString stringWithFormat:@"%@",model.createTime]substringWithRange:NSMakeRange(0, 10)];
    cell.assessLable.text = model.content;
    
    return cell;
    
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
