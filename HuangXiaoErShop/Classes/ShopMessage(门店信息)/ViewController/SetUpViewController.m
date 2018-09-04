//
//  SetUpViewController.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "SetUpViewController.h"
#import "SetUpTableViewCell.h"
#import "ChangePhoneViewController.h"
#import "ChangePasswordViewController.h"

@interface SetUpViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *setupTableView;

@end

static NSString * const setupCell = @"setUpTableViewCell";

@implementation SetUpViewController

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

    self.navigationItem.title = @"修改商户信息";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
}
- (void)leftBarBtnClicked:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor(250, 250, 250);
    
    self.setupTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 118) style:UITableViewStylePlain];
    self.setupTableView.scrollEnabled = NO;
    [self.setupTableView registerClass:[SetUpTableViewCell class] forCellReuseIdentifier:setupCell];
    self.setupTableView.delegate = self;
    self.setupTableView.dataSource = self;
    [self.view addSubview:self.setupTableView];
    // Do any additional setup after loading the view.
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SetUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:setupCell forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == 0) {
        cell.textLabel.text = @"修改手机号";
    }else{
        cell.textLabel.text = @"修改密码";
    }
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.hidesBottomBarWhenPushed = YES;
    if (indexPath.row == 0) {
        ChangePhoneViewController *phoneVC = [ChangePhoneViewController new];
        [self.navigationController pushViewController:phoneVC animated:YES];
    }else{
        ChangePasswordViewController *passwordVC = [ChangePasswordViewController new];
        [self.navigationController pushViewController:passwordVC animated:YES];
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
