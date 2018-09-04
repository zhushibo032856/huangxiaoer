//
//  ShopMessageViewController.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "ShopMessageViewController.h"
#import "BaseNavigationController.h"
#import "ShopMessageTableViewCell.h"
#import "ShopMessageLableTableViewCell.h"
#import "FirstTableViewCell.h"
#import "SecondTableViewCell.h"
#import "ThreeTableViewCell.h"

@interface ShopMessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *messageTableView;

@end

static NSString * const shopMessageCell = @"shopMessageTableViewCell";
static NSString * const shopMessageImageCell = @"shopMessageImageTableViewCell";
static NSString * const firstCells = @"firstTableViewCell";
static NSString * const secondeCell = @"secondTableViewCell";
static NSString * const sthreeCell = @"threeTableViewCell";

@implementation ShopMessageViewController

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
    
    self.navigationItem.title = @"门店信息";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
    
}

- (void)leftBarBtnClicked:(UIButton *)btn{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _messageTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    _messageTableView.sectionHeaderHeight = 5;
    _messageTableView.sectionFooterHeight = 5;
    _messageTableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0.0f,0.0f,kScreenWidth,10)];
    
    _messageTableView.scrollEnabled = NO;
    
    [_messageTableView registerClass:[ShopMessageTableViewCell class] forCellReuseIdentifier:shopMessageCell];
    [_messageTableView registerClass:[ShopMessageLableTableViewCell class] forCellReuseIdentifier:shopMessageImageCell];
    [_messageTableView registerClass:[FirstTableViewCell class] forCellReuseIdentifier:firstCells];
    [_messageTableView registerClass:[SecondTableViewCell class] forCellReuseIdentifier:secondeCell];
    [_messageTableView registerClass:[ThreeTableViewCell class] forCellReuseIdentifier:sthreeCell];
    
    _messageTableView.delegate = self;
    _messageTableView.dataSource = self;
    
    [self.view addSubview:_messageTableView];
    // Do any additional setup after loading the view.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 60;
        }else{
            
            return 50;
        }
    }else {
        
        return 50;
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 2;
    }
    
    return 3;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            ShopMessageLableTableViewCell *cells = [tableView dequeueReusableCellWithIdentifier:shopMessageImageCell forIndexPath:indexPath];
            cells.localLable.text = @"店铺图像";
            
            return cells;
        }else{
            ShopMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:shopMessageCell forIndexPath:indexPath];
            cell.localLable.text = @"店铺名";
            cell.requestLable.text = KUSERNAME;
            return cell;
        }
    }else{
        if (indexPath.row == 0) {
            FirstTableViewCell *firstCell = [tableView dequeueReusableCellWithIdentifier:firstCells forIndexPath:indexPath];
            firstCell.localLable.text = @"地址";
            firstCell.requestLable.text = KUSERADDRESS;
            return firstCell;
        }else if(indexPath.row == 1){
            SecondTableViewCell *secondCell = [tableView dequeueReusableCellWithIdentifier:secondeCell forIndexPath:indexPath];
            secondCell.localLable.text = @"商家电话";
            secondCell.requestLable.text = KUSERPHONE;
            return secondCell;
            
        }else{
            
            ThreeTableViewCell *threeCEll = [tableView dequeueReusableCellWithIdentifier:sthreeCell forIndexPath:indexPath];
            threeCEll.localLable.text = @"公告";
            return threeCEll;
        }
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
