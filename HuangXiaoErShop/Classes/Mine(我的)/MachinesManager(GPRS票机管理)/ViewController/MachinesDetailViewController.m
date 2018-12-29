//
//  MachinesDetailViewController.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "MachinesDetailViewController.h"
#import "MachinesModel.h"

@interface MachinesDetailViewController ()

@property (nonatomic, strong) UIView *backView;

@end

@implementation MachinesDetailViewController

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
    self.navigationItem.title = @"票机详情";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
    
}
- (void)leftBarBtnClicked:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = kColor(245, 245, 245);

    [self creatAutoLayout];
    // Do any additional setup after loading the view.
}

- (void)creatAutoLayout{
    
    MachinesModel *model = self.model;
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 150)];
    self.backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backView];
    
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 80, 20)];
    titleLable.text = @"票机信息";
    titleLable.textColor = [UIColor lightGrayColor];
    titleLable.font = [UIFont systemFontOfSize:14];
    [self.backView addSubview:titleLable];
    
    
    UILabel *categoryLable = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(titleLable.frame) + 5, 60, 30)];
    categoryLable.text = @"类型";
    categoryLable.font = [UIFont systemFontOfSize:17];
    [self.backView addSubview:categoryLable];
    
    UILabel *cateName = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth * 0.75, CGRectGetMaxY(titleLable.frame) + 5, kScreenWidth * 0.15, 30)];
    cateName.text = @"GPRS";
    cateName.textAlignment = NSTextAlignmentRight;
    cateName.font = [UIFont systemFontOfSize:17];
    [self.backView addSubview:cateName];
    
    UILabel *lineLable = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(categoryLable.frame) + 5, kScreenWidth - 30, 1)];
    lineLable.backgroundColor = kColor(240, 240, 240);
    [self.backView addSubview:lineLable];
    
    UILabel *nameLable = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(lineLable.frame) + 5, 60, 30)];
    nameLable.text = @"名称";
    nameLable.font = [UIFont systemFontOfSize:17];
    [self.backView addSubview:nameLable];
    
    UILabel *machinesName = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth * 0.75, CGRectGetMaxY(lineLable.frame) + 5, kScreenWidth * 0.15, 30)];
    if ([model.name isEqualToString:@"HC"]) {
        machinesName.text = @"后厨";
    }else{
        machinesName.text = @"收银";
    }
    
    machinesName.textAlignment = NSTextAlignmentRight;
    machinesName.font = [UIFont systemFontOfSize:17];
    [self.backView addSubview:machinesName];
    
    UILabel *lineLableTwo = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(nameLable.frame) + 5, kScreenWidth - 30, 1)];
    lineLableTwo.backgroundColor = kColor(240, 240, 240);
    [self.backView addSubview:lineLableTwo];
    
    UILabel *numberLable = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(lineLableTwo.frame) + 5, 60, 30)];
    numberLable.text = @"编号";
    numberLable.font = [UIFont systemFontOfSize:17];
    [self.backView addSubview:numberLable];
    
    UILabel *numLable = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth * 0.25, CGRectGetMaxY(lineLableTwo.frame) + 5, kScreenWidth * 0.65, 30)];
    numLable.font = [UIFont systemFontOfSize:17];
    numLable.textAlignment = NSTextAlignmentRight;
    numLable.text = model.deviceNo;
    [self.backView addSubview:numLable];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(kScreenWidth * 0.3, CGRectGetMaxY(self.backView.frame) + 10, kScreenWidth * 0.4, 40);
    button.backgroundColor = kColor(255, 230, 0);
    [button setTitle:@"解除绑定" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    [button setTintColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(delegateMachine) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
- (void)delegateMachine{
    MachinesModel *model = self.model;
    //   model = self.dataArray;
    [self requestDataMachineWithBrand:model.brand DeviceNo:model.deviceNo];
    
}

- (void)requestDataMachineWithBrand:(NSString *)brand
                           DeviceNo:(NSString *)deviceNo{
    NSDictionary *partner = @{
                              @"brand": brand,
                              @"deviceNo": deviceNo,
                              @"token": KUSERID
                              };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html", nil];
    [manager POST:[NSString stringWithFormat:@"%@/appprint/unbind",HXECOMMEN] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"status"] integerValue] == 200) {
            [MBProgressHUD showSuccess:responseObject[@"msg"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"notiEdit" object:nil];
        }else{
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
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
