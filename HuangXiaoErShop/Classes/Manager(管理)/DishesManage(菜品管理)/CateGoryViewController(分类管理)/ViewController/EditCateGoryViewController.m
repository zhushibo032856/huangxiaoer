//
//  EditCateGoryViewController.m
//  HXEshop
//
//  Created by apple on 2018/3/27.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "EditCateGoryViewController.h"
#import "LeftDataModel.h"
#import "DishesManagerViewController.h"

@interface EditCateGoryViewController ()

@property (nonatomic, strong) UIView *addView;
@property (nonatomic, strong) UIButton *keepButton;
@property (nonatomic, strong) UITextField *keepTF;

@end

@implementation EditCateGoryViewController

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
    
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    [rightBtn setTintColor:[UIColor whiteColor]];
    [rightBtn addTarget:self action:@selector(KeepButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    
    [self setNavigationController];
    
}
- (void)setNavigationController{
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"backcolor"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationItem.title = @"编辑";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
    
}
- (void)leftBarBtnClicked:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor(240, 240, 240);
    
    self.addView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 50)];
    self.addView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.addView];
    
    UILabel *nameLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 150, 30)];
    nameLable.text = @"品类名称";
    [self.addView addSubview:nameLable];
    
    LeftDataModel *model = self.dataSource[self.index];
    self.keepTF = [[UITextField alloc]initWithFrame:CGRectMake(kScreenWidth * 0.5, 10, kScreenWidth * 0.4, 30)];
    self.keepTF.text = model.name;
    [self.addView addSubview:self.keepTF];
    
    self.keepButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.keepButton.frame = CGRectMake(10, 70, kScreenWidth - 20, 40);
    [self.keepButton setTitle:@"删除" forState:UIControlStateNormal];
    [self.keepButton setBackgroundColor:[UIColor whiteColor]];
    [self.keepButton setTintColor:[UIColor redColor]];
    [self.keepButton addTarget:self action:@selector(delegateButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.keepButton];
    
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
    // Do any additional setup after loading the view.
}

-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer{
    [self.view endEditing:YES];
}

- (void)KeepButton:(UIButton *)sender{
    
    LeftDataModel *model = self.dataSource[self.index];
    
    if (kStringIsEmpty(self.keepTF.text)) {
        [MBProgressHUD showError:@"分类名不能为空"];
    }else{
        [self addCategory:self.keepTF.text CatagoryID:model.id];
    }
    
}

- (void)addCategory:(NSString *)categoryName
         CatagoryID:(NSString *)catagoryID
{
    
    
    
    NSDictionary *partner = @{
                              @"name": categoryName,
                              @"token": KUSERID,
                              @"id": catagoryID
                              };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    
    [manager POST:[NSString stringWithFormat:@"%@/appproduct/category/update",HXECOMMEN] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"status"] integerValue] == 200) {
            [MBProgressHUD showSuccess:@"修改成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"notiEdit" object:nil];
        }else
            [MBProgressHUD showError:@"修改失败"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    //提交之后置空输入框
    self.keepTF.text = @"";
    
}

- (void)delegateButton:(UIButton *)sender{
    
    LeftDataModel *model = [[LeftDataModel alloc]init];
    model = self.dataSource[self.index];
    [self deleteCategory:model.id];
}

/** 商品分类删除 */
- (void)deleteCategory: (NSString *)category{
    
    NSDictionary *partner = @{
                              @"id": category,
                              @"token": KUSERID
                              };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    
    [manager POST:[NSString stringWithFormat:@"%@/appproduct/category/delete",HXECOMMEN] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"%@",responseObject);
        if ([responseObject[@"status"] integerValue] == 200) {
            [MBProgressHUD showSuccess:@"删除成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"notiEdit" object:nil];
        }else
            [MBProgressHUD showError:@"删除失败,该分类下有菜品,无法删除!"];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    self.keepTF.text = @"";
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
