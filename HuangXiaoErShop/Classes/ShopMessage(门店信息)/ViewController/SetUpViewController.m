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
#import "PhoneTableViewCell.h"

@interface SetUpViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *setupTableView;

@end

static NSString * const setupCell = @"setUpTableViewCell";
static NSString * const phoneCell = @"PhoneTableViewCell";

@implementation SetUpViewController

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

    self.navigationItem.title = @"修改商户信息";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
}
- (void)leftBarBtnClicked:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor(240, 240, 240);
    
    self.setupTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 120) style:UITableViewStyleGrouped];
    self.setupTableView.scrollEnabled = NO;
    self.setupTableView.separatorStyle = NO;
    [self.setupTableView registerClass:[SetUpTableViewCell class] forCellReuseIdentifier:setupCell];
    [self.setupTableView registerNib:[UINib nibWithNibName:@"PhoneTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:phoneCell];
    self.setupTableView.delegate = self;
    self.setupTableView.dataSource = self;
    [self.view addSubview:self.setupTableView];
    // Do any additional setup after loading the view.
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 60;
    }
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        PhoneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:phoneCell forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.PhoneLable.text = KUSERPHONE;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layer.masksToBounds = YES;
        cell.layer.cornerRadius = 8;
        return cell;
    }else{
        SetUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:setupCell forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.layer.masksToBounds = YES;
        cell.layer.cornerRadius = 8;
        cell.textLabel.text = @"修改密码";
        cell.textLabel.textColor = kColor(50, 50, 50);
        return cell;
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.hidesBottomBarWhenPushed = YES;
    if (indexPath.section == 0) {
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
