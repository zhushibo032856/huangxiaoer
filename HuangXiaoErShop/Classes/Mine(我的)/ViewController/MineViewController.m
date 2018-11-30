//
//  MineViewController.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/8/3.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "MineViewController.h"
#import "MineTableViewCell.h"
#import "MineOneTableViewCell.h"
#import "MineTwoTableViewCell.h"
#import "ShopMessageViewController.h"
#import "ManagerModel.h"
#import "MachinesManagerViewController.h"
#import "SuggestionsViewController.h"
#import "EditShopMessageViewController.h"
#import "SetUpViewController.h"
#import "CreatQRViewController.h"
#import "QRViewController.h"
#import "AppointmentDateViewController.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *headView;//头视图
@property (nonatomic, strong) UIImageView *shopPhotoView;//店铺图片
@property (nonatomic, strong) UILabel *nameLable;//店铺名
@property (nonatomic, strong) UIButton *detailButton;//详情按钮
@property (nonatomic, strong) UIButton *arrowButton;//箭头按钮

@property (nonatomic, strong) UITableView *mineTableView;//

@property (nonatomic, strong) NSMutableArray *dataArray;//数据源

@property (nonatomic, strong) NSString *userImageUrl;
@property (nonatomic, strong) NSString *userName;

@property (nonatomic, strong) NSString *appId;


@end

static NSString * const mineCell = @"mineTableViewCell";
static NSString * const mineOneCell = @"mineOneTableViewCell";
static NSString * const mineTwoCell = @"mineTwoTableViewCell";

@implementation MineViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
     //  [self isUpdataApp:@"1367090731"];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}

- (NSMutableArray*)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    
    _mineTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kScreenHeight / 5, kScreenWidth, kScreenHeight / 5 * 4) style:UITableViewStyleGrouped];
  //  _mineTableView.scrollEnabled = NO;
    [_mineTableView registerClass:[MineTableViewCell class] forCellReuseIdentifier:mineCell];
    [_mineTableView registerClass:[MineOneTableViewCell class] forCellReuseIdentifier:mineOneCell];
    [_mineTableView registerClass:[MineTwoTableViewCell class] forCellReuseIdentifier:mineTwoCell];
    
    _mineTableView.sectionHeaderHeight = 5;
    _mineTableView.sectionFooterHeight = 5;
    _mineTableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0.0f,0.0f,kScreenWidth,10)];
    
    [self.view addSubview:_mineTableView];
    
    _mineTableView.delegate = self;
    _mineTableView.dataSource = self;
    
    [self creatHeadViewLayout];
    
    [self requestShopManager];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestShopManager) name:@"notiEdit" object:nil];
    // Do any additional setup after loading the view.
}
- (void)submitTokenToSocket{

    if (kStringIsEmpty(KDEVICETOKEN)) {
     //   [MBProgressHUD showError:@"注册deviceToken失败"];
        return;
    }
  //  NSLog(@"%@",KDEVICETOKEN);
    NSString *string = [NSString stringWithFormat:@"%@",KUSERSHOPID];
    if (kStringIsEmpty(string)) {
        return;
    }
    if (kStringIsEmpty(KUSERID)) {
        return;
    }

    NSDictionary *partner = @{
                              @"phoneId": KDEVICETOKEN,
                              @"phoneType": @"IPHONE",
                              @"sys_user_id": KUSERSHOPID,
                              @"token": KUSERID
                              };
  //  NSLog(@"%@",partner);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];

    [manager POST:[NSString stringWithFormat:@"%@/appcommercial/addcommericalpush",HXECOMMEN] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
 //       NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    }];
}

/** 头视图布局 */
- (void)creatHeadViewLayout{
    
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight / 5)];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"manageBack"]];
    imageView.frame = _headView.frame;
    [_headView addSubview:imageView];
    [self.view addSubview:_headView];
    
    _shopPhotoView = [[UIImageView alloc]initWithFrame:CGRectMake(20, CGRectGetHeight(_headView.frame) / 3 + 10, CGRectGetHeight(_headView.frame) / 3 + 30, CGRectGetWidth(_shopPhotoView.frame) / 4 * 3)];
    _shopPhotoView.layer.masksToBounds = YES;
    _shopPhotoView.layer.cornerRadius = 6;
    [_shopPhotoView sd_setImageWithURL:[NSURL URLWithString:self.userImageUrl] placeholderImage:[UIImage imageNamed:@"userName"]];
    [_headView addSubview:_shopPhotoView];
    
    _nameLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_shopPhotoView.frame) + 20, CGRectGetHeight(_headView.frame) / 3 + 10, kScreenWidth - _shopPhotoView.frame.size.width - 20, 30)];
    _nameLable.text = self.userName;
    [_nameLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    _nameLable.textAlignment = NSTextAlignmentLeft;
    [_headView addSubview:_nameLable];
    
    _detailButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _detailButton.frame = CGRectMake(CGRectGetMaxX(_shopPhotoView.frame) + 20, CGRectGetMaxY(_nameLable.frame) + 10 , 80, 15);

    [_detailButton setBackgroundImage:[UIImage imageNamed:@"shopDetailMessage"] forState:UIControlStateNormal];
    [_detailButton addTarget:self action:@selector(pushDetailShopView:) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:_detailButton];
    
    
}
//请求主页信息
- (void)requestShopManager{
    
    NSDictionary *partner = @{
                              @"token":KUSERID
                              };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html", nil];
    
    [manager POST:[NSString stringWithFormat:@"%@/appcommercial/findbytoken",HXECOMMEN] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
      //     NSLog(@"%@",responseObject);
        
        if ([responseObject[@"status"] integerValue] == 200) {
            [self.dataArray removeAllObjects];
            NSDictionary *dic = responseObject[@"data"];
            
            ManagerModel *model = [[ManagerModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
            
            self.userName = model.shopSign;
            self.userImageUrl = model.logoImage;
            
            
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:dic[@"logoImage"] forKey:@"imageurl"];
            [user setObject:dic[@"shopSign"] forKey:@"shopName"];
            [user setObject:dic[@"address"] forKey:@"shopAddress"];
            //   [user setObject:dic[@"id"] forKey:@"shopId"];
            [user setValue:dic[@"id"] forKey:@"shopId"];
            [user setObject:dic[@"userName"] forKey:@"userName"];
            [user synchronize];
            
            [self submitTokenToSocket];
            
            [self creatHeadViewLayout];
            
        }else if ([responseObject[@"status"] integerValue] == 301){
            [[AppDelegate mainAppDelegate] showLoginView];
        }
        else{
            [MBProgressHUD showMessage:responseObject[@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}


/** 跳转店铺详情页面 */
- (void)pushDetailShopView :(UIButton *)sender{
    
    self.hidesBottomBarWhenPushed = YES;
    ShopMessageViewController *shopMessageVC = [[ShopMessageViewController alloc]init];
    [self.navigationController pushViewController:shopMessageVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    } else if (section == 1){
        return 5;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineCell forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        
        UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick1:)];
        [cell.imageViewTwo addGestureRecognizer:tapGestureRecognizer1];
        //让UIImageView和它的父类开启用户交互属性
    //    [cell.imageViewTwo setUserInteractionEnabled:YES];
        
        return cell;
    }else if (indexPath.section == 1){
        MineOneTableViewCell *cellOne = [tableView dequeueReusableCellWithIdentifier:mineOneCell forIndexPath:indexPath];
        cellOne.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        if (indexPath.row == 0) {
//            cellOne.voiceLable.text = @"语音播报";
//            cellOne.accessoryType = UITableViewCellAccessoryNone;
//            [cellOne.voiceimageView setImage:[UIImage imageNamed:@"voiceImage"]];
//        }else
            if(indexPath.row == 0){
            cellOne.voiceLable.text = @"商户信息";
            cellOne.voiceSwitch.hidden = YES;
            [cellOne.voiceimageView setImage:[UIImage imageNamed:@"shopMessage"]];
        }else if(indexPath.row == 1){
            cellOne.voiceLable.text = @"票机管理";
            cellOne.voiceSwitch.hidden = YES;
            [cellOne.voiceimageView setImage:[UIImage imageNamed:@"piaoji"]];
        }else if(indexPath.row == 2){
            cellOne.voiceLable.text = @"店铺收款码";
            cellOne.voiceSwitch.hidden = YES;
            [cellOne.voiceimageView setImage:[UIImage imageNamed:@"codeImage"]];
        }else if(indexPath.row == 3){
            cellOne.voiceLable.text = @"预约时间";
            cellOne.voiceSwitch.hidden = YES;
            [cellOne.voiceimageView setImage:[UIImage imageNamed:@"yuyueTime"]];
        }
        else{
            cellOne.voiceLable.text = @"意见反馈";
            cellOne.voiceSwitch.hidden = YES;
            [cellOne.voiceimageView setImage:[UIImage imageNamed:@"Suggestions"]];
        }
        
        return cellOne;
        
    }else{
        MineTwoTableViewCell *cellTwo = [tableView dequeueReusableCellWithIdentifier:mineTwoCell forIndexPath:indexPath];
        
        [cellTwo.quitLogin addTarget:self action:@selector(quitLogin) forControlEvents:UIControlEventTouchUpInside];
        return cellTwo;
    }
}

- (void)quitLogin{
    NSDictionary *partner = @{
                              @"token":KUSERID
                              };

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html", nil];
    
    [manager POST:[NSString stringWithFormat:@"%@/appcommercialUser/user/loginout",HXELOGIN] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //   NSLog(@"%@",responseObject);
        if ([responseObject[@"status"] integerValue] == 200) {
          //  [MBProgressHUD showSuccess:@"退出成功"];
   
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user removeObjectForKey:@"data"];
            [user removeObjectForKey:@"imageurl"];
            [user removeObjectForKey:@"shopName"];
            [user removeObjectForKey:@"shopAddress"];
            [user removeObjectForKey:@"shopId"];
            [user removeObjectForKey:@"userName"];
            [user removeObjectForKey:@"dateTime"];
 //           [user removeObjectForKey:@"blueTooth"];
//            [user removeObjectForKey:@"phone"];
//            [user removeObjectForKey:@"password"];
            [user synchronize];

        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    [[AppDelegate mainAppDelegate]showLoginView];
}

- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([animationID compare:@"exitApplication"] == 0)
    {
        exit(0);
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        self.hidesBottomBarWhenPushed=YES;
        
        EditShopMessageViewController *editShopMessageVC = [[EditShopMessageViewController alloc]init];
        editShopMessageVC.model = [self.dataArray firstObject];
        [self.navigationController pushViewController:editShopMessageVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0){
            self.hidesBottomBarWhenPushed = YES;
            SetUpViewController *setUpVC = [SetUpViewController new];
            [self.navigationController pushViewController:setUpVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }else if (indexPath.row == 1){
         //   self.hidesBottomBarWhenPushed=YES;
            MachinesManagerViewController *macVC = [[MachinesManagerViewController alloc]init];
            [self.navigationController pushViewController:macVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }else if (indexPath.row == 2){
            self.hidesBottomBarWhenPushed=YES;
            QRViewController *qrVC = [[QRViewController alloc]init];
            [self.navigationController pushViewController:qrVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }else if (indexPath.row == 3){
            self.hidesBottomBarWhenPushed=YES;
            AppointmentDateViewController *appointmentVC = [[AppointmentDateViewController alloc]init];
            [self.navigationController pushViewController:appointmentVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }else if (indexPath.row == 4){
            self.hidesBottomBarWhenPushed = YES;
            SuggestionsViewController *suggestVC = [[SuggestionsViewController alloc]init];
            [self.navigationController pushViewController:suggestVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
    }
}

- (void)isUpdataApp:(NSString *)appId{
    
    NSURL *appUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",appId]];
    NSString *appMsg = [NSString stringWithContentsOfURL:appUrl encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *appMsgDict = [self jsonStringToDictionary:appMsg];
    NSDictionary *appResultsDict = [appMsgDict[@"results"] lastObject];
    NSString *appStoreVersion = appResultsDict[@"version"];
    float newVersionFloat = [appStoreVersion floatValue];//新发布的版本号
    
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    float currentVersionFloat = [currentVersion floatValue];//使用中的版本号
    NSLog(@"APP Store版本号%f当前使用版本号%f",newVersionFloat,currentVersionFloat);
    //当前版本小于App Store上的版本&用户未点击不再提示
    if (currentVersionFloat - newVersionFloat > 0)
    {
        self.appId = appId;
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"版本过低，无法使用，请下载最新版本" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"查看新版本" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@?mt=8",self.appId]]];
        }];
        
//        UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//
//        }];
        
        //     UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"忽略更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //            [self isAlertUpdataAgain];
        //        }];
  //      [actionOne setValue:kColor(190, 190, 190) forKey:@"_titleTextColor"];
        
        [alertView addAction:action];
   //     [alertView addAction:actionOne];
        //     [alertView addAction:actionTwo];
        [self presentViewController:alertView animated:YES completion:nil];
    }
    
}

- (NSDictionary *)jsonStringToDictionary:(NSString *)jsonStr
{
    if (jsonStr == nil)
    {
        return nil;
    }
    
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&error];
    if (error)
    {
        //NSLog(@"json格式string解析失败:%@",error);
        return nil;
    }
    
    return dict;
}

- (BOOL)isAlertUpdataAgain
{
    BOOL res = [[NSUserDefaults standardUserDefaults] objectForKey:@"IS_ALERT_AGAIN"];
    return res;
}

-(void)scanBigImageClick1:(UITapGestureRecognizer *)tap{
    
    //   NSLog(@"******");
    self.hidesBottomBarWhenPushed = YES;
    CreatQRViewController *creatQRVc = [[CreatQRViewController alloc]init];
    [self.navigationController pushViewController:creatQRVc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
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
