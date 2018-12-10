//
//  CateGoryViewController.m
//  HXEshop
//
//  Created by apple on 2018/3/27.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "CateGoryViewController.h"
#import "CateGoryTableViewCell.h"
#import "AddCateGoryViewController.h"
#import "EditCateGoryViewController.h"

static NSString * const cateGoryCell = @"CateGoryTableViewCell";

@interface CateGoryViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger thePage;

@property (nonatomic, strong) UIButton *addCategoryBT;

@end

@implementation CateGoryViewController

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
    leftBtn.frame = CGRectMake(0, 0, 30, 30);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"itemBack"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBarBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    [self setNavigationController];
    
}
- (void)setNavigationController{
    
  //  [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"backcolor"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationItem.title = @"分类管理";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
    
}
- (void)leftBarBtnClicked:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
     CGFloat commen = kNav_H + kTabbar_H;
    if (iPhoneX) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - commen - 50) style:UITableViewStylePlain];
    }else{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 110) style:UITableViewStylePlain];
    }
    self.tableView.backgroundColor = kColor(240, 240, 240);
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView registerClass:[CateGoryTableViewCell class] forCellReuseIdentifier:cateGoryCell];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    self.addCategoryBT = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.addCategoryBT setTitle:@"添加分类" forState:UIControlStateNormal];
    self.addCategoryBT.frame = CGRectMake(0, CGRectGetMaxY(self.tableView.frame), kScreenWidth, 50);
 //   [self.addCategoryBT setImage:[UIImage imageNamed:@"addButton"] forState:UIControlStateNormal];
      [self.addCategoryBT setImage:[[UIImage imageNamed:@"addButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.addCategoryBT setBackgroundColor:[UIColor whiteColor]];
    [self.addCategoryBT setTintColor:[UIColor blackColor]];
    [self.addCategoryBT addTarget:self action:@selector(addCategoryBT:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addCategoryBT];
    
    [self setRefresh];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setRefresh) name:@"notiEdit" object:nil];
    
    // Do any additional setup after loading the view.
}

- (void)setRefresh {
    
    _thePage = 1;
    __block typeof(self)weakself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.tableView.mj_footer resetNoMoreData];
        weakself.thePage = 1;
        [self requestData];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.thePage = 1;
        [self.tableView.mj_footer endRefreshing];
    }];
    // 进入界面时刷新
    [self.tableView.mj_header beginRefreshing];
    
}


- (void)requestData{
    NSDictionary *partner = @{
                              @"token":KUSERID
                              };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    
    [manager POST:[NSString stringWithFormat:@"%@/appproduct/category/findallall",HXECOMMEN] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //    NSLog(@"%@",responseObject);
        
        if ([responseObject[@"status"] integerValue] == 200) {
            if (self->_thePage == 1) {
                [self.dataArray removeAllObjects];
            }
            NSArray *arr = responseObject[@"data"];
            
            for (NSDictionary *dic in arr) {
                LeftDataModel *model = [LeftDataModel new];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
            }
            if (self->_thePage == 1) {
                [self.tableView.mj_header endRefreshing];
            }else{
                if (arr.count == 0) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [self.tableView.mj_footer endRefreshing];
                }
            }
            [self.tableView reloadData];
        }else {
            [self.tableView.mj_header endRefreshing];
            [MBProgressHUD showMessage:responseObject[@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LeftDataModel *model = self.dataArray[indexPath.row];
    CateGoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cateGoryCell forIndexPath:indexPath];
    
    cell.index = indexPath.row;
    [cell cellDataFromModel:model];
    
    __weak typeof(self)weakSelf = self;
    cell.block = ^(NSInteger index, NSInteger buttonTag) {
        [weakSelf editCateGoryWith:index ButtonTag:buttonTag];
    };
    
    return cell;
    
}
/** 编辑按钮操作事件 */
- (void)editCateGoryWith:(NSInteger)index
               ButtonTag:(NSInteger)buttonTag{
    
  //  NSLog(@"编辑");
   
    EditCateGoryViewController *editVC = [[EditCateGoryViewController alloc]init];
    editVC.dataSource = self.dataArray;
    editVC.index = index;
    [self.navigationController pushViewController:editVC animated:YES];
    
}
/** 添加分类按钮事件 */
- (void)addCategoryBT:(UIButton *)sender{
    
    UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"添加分类" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *add = [UIAlertAction actionWithTitle:@"添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        AddCateGoryViewController *addVC = [AddCateGoryViewController new];
        [self.navigationController pushViewController:addVC animated:YES];
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [aler addAction:add];
    [aler addAction:cancel];
    [self presentViewController:aler animated:YES completion:nil];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
