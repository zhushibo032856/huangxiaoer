//
//  RecommendedGalleryViewController.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/12/24.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "RecommendedGalleryViewController.h"
#import "RecommendedCollectionViewCell.h"
#import "RecommendModel.h"

@interface RecommendedGalleryViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *serachBar;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSString *text;

@property (nonatomic, assign) NSInteger thePage;

@end

static NSString * const Cell = @"RecommendedCollectionViewCell";

@implementation RecommendedGalleryViewController

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
    
    self.navigationItem.title = @"图片选取";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
    
}
- (void)leftBarBtnClicked:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColor(240, 240, 240);
    
    _serachBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    _serachBar.placeholder = @"搜索内容";
    _serachBar.barStyle = UISearchBarStyleDefault;
    _serachBar.backgroundImage = [UIImage imageNamed:@"clear"];
    _serachBar.delegate = self;
    [self.view addSubview:_serachBar];
    
    [self initCollectionView];
    
    if (kStringIsEmpty(self.nameString)) {
        return;
    }else{
        [self setRefreshWith:self.nameString];
    }
    // Do any additional setup after loading the view.
}



- (void)initCollectionView{
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake((kScreenWidth - 45) / 3, (kScreenWidth - 45) / 3);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 60, kScreenWidth - 20, kScreenHeight - 50 - kNavHeight) collectionViewLayout:layout];
    _collectionView.backgroundColor = kColor(240, 240, 240);
    [_collectionView registerClass:[RecommendedCollectionViewCell class] forCellWithReuseIdentifier:Cell];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self setRefreshWith:_serachBar.text];
    [self.serachBar resignFirstResponder];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
    [self setRefreshWith:_serachBar.text];
    
}
- (void)setRefreshWith:(NSString *)text{
    
    _thePage = 1;
    __block typeof(self)weakself = self;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.collectionView.mj_footer resetNoMoreData];
        weakself.thePage = 1;
        [self requestDataWith:text];
    }];
    
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.thePage += 1;
        [self requestDataWith:text];
    }];
    [self.collectionView.mj_header beginRefreshing];
}
- (void)requestDataWith:(NSString *)text{
    
    if (kStringIsEmpty(text)) {
        return;
    }
    
    NSDictionary *partner = @{
                              @"name": text,
                              @"page": @(_thePage),
                              @"size": @20,
                              @"token": KUSERID
                              };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    
    [manager POST:[NSString stringWithFormat:@"%@/appimage/pageListImage",HXECOMMEN] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
            NSLog(@"%@",responseObject);
        NSDictionary *data = responseObject[@"data"];
        if ([responseObject[@"status"] integerValue] == 200) {
            
            if (_thePage == 1) {
                [_dataSource removeAllObjects];
            }
            NSArray *arr = data[@"rows"];
            for (NSDictionary *dic in arr) {
                RecommendModel *model = [[RecommendModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataSource addObject:model];
            }
            if (_thePage == 1) {
                [self.collectionView.mj_header endRefreshing];
            }else{
                if (arr.count == 0) {
                    [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [self.collectionView.mj_footer endRefreshing];
                }
            }
         [_collectionView reloadData];
        }else{
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RecommendModel *model = _dataSource[indexPath.row];
    RecommendedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Cell forIndexPath:indexPath];
    [cell setPictureImageWith:model];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    RecommendModel *model = _dataSource[indexPath.row];
    _block(model.imgUrl);
   // NSLog(@"%@",model.imgUrl);
    [self.navigationController popViewControllerAnimated:YES];
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
