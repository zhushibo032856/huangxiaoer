//
//  MessageTypeViewController.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/12/4.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "MessageTypeViewController.h"
#import "XXPageTabView.h"
#import "SQMenuShowView.h"


#import "PopTableViewCell.h"

#import "MessageOneViewController.h"
#import "MessageTwoViewController.h"
#import "MessageThreeViewController.h"
#import "MessageFourViewController.h"
#import "MessageFiveViewController.h"
#import "MessageCenterViewController.h"

#import "TitleModel.h"

@interface MessageTypeViewController ()<XXPageTabViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    XXPageTabView *_pageTabView;
    
}

@property (nonatomic,strong) UIView * maskTheView;
@property (nonatomic,strong) UIView * shareView;

@property (nonatomic, strong) UITableView *tableView;

@property (strong, nonatomic)  SQMenuShowView *showView;
@property (assign, nonatomic)  BOOL  isShow;

@property (nonatomic, strong) NSMutableArray *indexArray;//保存选中的indexPath

@property (nonatomic, strong) UIButton *titleButton;

@property (nonatomic, strong) NSMutableArray *titleArray;//保存button的标题

@end

@implementation MessageTypeViewController
- (UIView *)maskTheView{
    if (!_maskTheView) {
        _maskTheView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth)];
        _maskTheView.backgroundColor = [UIColor clearColor];
        //添加一个点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskClickGesture)];
        [_maskTheView addGestureRecognizer:tap];//让header去检测点击手势
    }
    return _maskTheView;
}

- (UIView *)shareView{
    if (!_shareView) {
        _shareView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
      //  _shareView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
        _shareView.backgroundColor = [UIColor redColor];
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 150) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[PopTableViewCell class] forCellReuseIdentifier:@"CELL"];
        _tableView.backgroundColor = [UIColor cyanColor];
        _tableView.scrollEnabled = NO;
        [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        [_indexArray addObject:[NSIndexPath indexPathForRow:0 inSection:0]];
        [_shareView addSubview:_tableView];
    }
    return _shareView;
}

- (NSMutableArray *)indexArray{
    if (!_indexArray) {
        _indexArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _indexArray;
}

- (NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _titleArray;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    leftBtn.frame = CGRectMake(0, 0, 30, 30);;
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"itemBack"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBarBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 40, 30);
    [rightButton setTitle:@"· · ·" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
    [rightButton addTarget:self action:@selector(show) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    __weak typeof(self) weakSelf = self;
    [self.showView selectBlock:^(SQMenuShowView *view, NSInteger index) {
        weakSelf.isShow = NO;
        NSLog(@"123");
        [self alreadyReadToUnread];
    }];
    
    [self setNavigationController];
    
}
- (void)setNavigationController{
    
//    self.navigationItem.title = @"消息中心";
    
    _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _titleButton.frame = CGRectMake(20, 10, 100, 30);
    [_titleButton setTitle:@"全部消息" forState:UIControlStateNormal];
    [_titleButton setImage:[UIImage imageNamed:@"zhankai"] forState:UIControlStateNormal];
    [_titleButton setTag:100];
    _titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, -_titleButton.imageView.bounds.size.width + 2, 0, _titleButton.imageView.bounds.size.width);
    _titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, _titleButton.titleLabel.bounds.size.width, 0, -_titleButton.titleLabel.bounds.size.width);

    [_titleButton addTarget:self action:@selector(messageSelectWtih:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = _titleButton;
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
    
}
- (void)leftBarBtnClicked:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 右边按钮操作
- (void)rightBarButClicked:(UIButton *)btn{
    NSLog(@"123");


}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _isShow = NO;
    [self.showView dismissView];
}

- (SQMenuShowView *)showView{
    
    if (_showView) {
        return _showView;
    }
    
    _showView = [[SQMenuShowView alloc]initWithFrame:(CGRect){kScreenWidth - 110, 0, 100, 0}
                                               items:@[@"一键已读"]
                                           showPoint:(CGPoint){kScreenWidth - 25,10}];
    _showView.sq_backGroundColor = kColor(0, 0, 0);
    _showView.itemTextColor = kColor(255, 255, 255);
    [self.view addSubview:_showView];
    return _showView;
}


- (void)show{
    _isShow = !_isShow;
    
    if (_isShow) {
        [self.showView showView];
        
    }else{
        [self.showView dismissView];
    }
    
}

- (void)alreadyReadToUnread{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html", nil];
    
    [manager GET:[NSString stringWithFormat:@"%@/webMessage/updateCommercialAllMsgStatus/%@/%@",HXECOMMEN,KUSERSHOPID,KUSERID] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        
        if ([responseObject[@"status"] integerValue] == 200) {
            [MBProgressHUD showSuccess:responseObject[@"msg"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReadAlreadyToUnread" object:nil];
        }else{
            [MBProgressHUD showSuccess:responseObject[@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

#pragma mark  创建遮罩图和cell
- (void)messageSelectWtih:(UIButton *)sender{

        [self.view addSubview:self.maskTheView];
        [self.view addSubview:self.shareView];
        [self.shareView addSubview:_tableView];
        [_titleButton setImage:[UIImage imageNamed:@"shouqi"] forState:UIControlStateNormal];
    
    [_titleButton setTitle:@"全部消息" forState:UIControlStateNormal];
    
}




- (void)maskClickGesture{
    [self.maskTheView removeFromSuperview];
    [self.shareView removeFromSuperview];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *titleArr = @[@"全部消息",@"已读消息",@"未读消息"];
    
    PopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    cell.typeLable.text = titleArr[indexPath.row];

    [_indexArray addObject:[NSIndexPath indexPathForRow:0 inSection:0]];
    if ([_indexArray containsObject:indexPath]) {
        cell.typeLable.textColor = [UIColor blackColor];
        cell.sureImage.hidden = NO;
    }else{
        cell.typeLable.textColor = kColor(150, 150, 150);
        cell.sureImage.hidden = YES;
    }
    if (indexPath.row == 0) {
        cell.typeLable.textColor = [UIColor blackColor];
        cell.sureImage.hidden = NO;

    }

    

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PopTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.typeLable.textColor = [UIColor blackColor];
    cell.sureImage.hidden = NO;
    [_indexArray addObject:indexPath];
    NSString *indexStr = [NSString string];
    NSLog(@"%ld",indexPath.row);
    switch (indexPath.row) {
        case 0:
            indexStr = [NSString stringWithFormat:@"0"];
            break;
        case 1:
            indexStr = [NSString stringWithFormat:@"2"];
            break;
        case 2:
            indexStr = [NSString stringWithFormat:@"1"];
            break;
            
        default:
            break;
    }
    NSLog(@"%@",indexStr);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PostSelectIndex" object:nil userInfo:@{@"PostIndex":indexStr}];
    
    _titleButton.titleLabel.text = cell.typeLable.text;

    [self maskClickGesture];
    
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    PopTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.typeLable.textColor = kColor(150, 150, 150);
    cell.sureImage.hidden = YES;
    if ([_indexArray containsObject:indexPath]) {
        [_indexArray removeObject:indexPath];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor(210, 210, 210);
    
    [self creatSegmernt];
    // Do any additional setup after loading the view.
}

- (void)creatSegmernt{
    
    MessageCenterViewController *centerVC = [[MessageCenterViewController alloc]init];
    centerVC.tabBarController.tabBar.hidden = YES;
    
    MessageOneViewController *oneVC = [[MessageOneViewController alloc]init];
    oneVC.view.backgroundColor = kColor(230, 230, 230);
    oneVC.tabBarController.tabBar.hidden = YES;
    
    MessageTwoViewController *twoVC = [[MessageTwoViewController alloc]init];
    twoVC.view.backgroundColor = kColor(230, 230, 230);
    twoVC.tabBarController.tabBar.hidden = YES;
    
    MessageThreeViewController *threeVC = [[MessageThreeViewController alloc]init];
    threeVC.view.backgroundColor = kColor(230, 230, 230);
    threeVC.tabBarController.tabBar.hidden = YES;
    
    MessageFourViewController *fourVC = [[MessageFourViewController alloc]init];
    fourVC.view.backgroundColor = kColor(230, 230, 230);
    fourVC.tabBarController.tabBar.hidden = YES;
    
    MessageFiveViewController *fiveVC = [[MessageFiveViewController alloc]init];
    fiveVC.view.backgroundColor = kColor(230, 230, 230);
    fiveVC.tabBarController.tabBar.hidden = YES;
    
    [self addChildViewController:centerVC];
    [self addChildViewController:oneVC];
    [self addChildViewController:twoVC];
    [self addChildViewController:threeVC];
    [self addChildViewController:fourVC];
    [self addChildViewController:fiveVC];
    
    _pageTabView = [[XXPageTabView alloc]initWithChildControllers:self.childViewControllers childTitles:@[@"全部",@"订单",@"财务",@"审核",@"系统",@"活动"]];
    _pageTabView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavHeight);
    _pageTabView.tabSize = CGSizeMake(kScreenWidth, 44);
    _pageTabView.tabItemFont = [UIFont systemFontOfSize:15];
    _pageTabView.unSelectedColor = kColor(0, 0, 0);
    _pageTabView.selectedColor = kColor(255, 210, 0);
    
    _pageTabView.bodyBounces = NO;
    _pageTabView.titleStyle = XXPageTabTitleStyleDefault;
    _pageTabView.indicatorStyle = XXPageTabIndicatorStyleFollowText;
    _pageTabView.delegate = self;
    [self.view addSubview:_pageTabView];

}

- (void)pageTabViewDidEndChange{
    
    
    
    
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
