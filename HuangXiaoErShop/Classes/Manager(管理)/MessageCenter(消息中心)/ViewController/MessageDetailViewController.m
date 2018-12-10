//
//  MessageDetailViewController.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/12/4.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "MessageDetailViewController.h"
#import "MessageTwoTableViewCell.h"

@interface MessageDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UILabel *lable;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) MessageTwoTableViewCell *tempCell;

@end

static NSString * const MessageTwo = @"MessageTwoTableViewCell";

@implementation MessageDetailViewController



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
    
    self.navigationItem.title = @"消息详情";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
    
}
- (void)leftBarBtnClicked:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    _dataArr = [[NSMutableArray alloc] init];
//    MessageModel *model = self.model;
//    [_dataArr addObject:model];
//    NSLog(@"%@",_dataArr);
    self.view.backgroundColor = kColor(230, 230, 230);
    [self uploadDataReadAlreadyToUnread];
    
    [self creatAutoLayout];
  //  [self setTableView];
    // Do any additional setup after loading the view.
}

- (void)creatAutoLayout{
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 200)];
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 6;
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth - 40, 30)];
    if ([self.model.type isEqualToString:@"ORDERMSG"]) {
        titleLable.text = @"订单消息";
    }else if ([self.model.type isEqualToString:@"VERIFYMSG"]){
        titleLable.text = @"审核信息";
    }else if ([self.model.type isEqualToString:@"SYSMSG"]){
        titleLable.text = @"系统通知";
    }else if ([self.model.type isEqualToString:@"PAYMSG"]){
        titleLable.text = @"财务信息";
    }else if ([self.model.type isEqualToString:@"ACTIVEITYMSG"]){
        titleLable.text = @"活动消息";
    }
    titleLable.font = [UIFont systemFontOfSize:21];
    [backView addSubview:titleLable];
    
    UILabel *contextLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, kScreenWidth - 40, 100)];
    contextLable.textColor = kColor(204, 204, 204);
    contextLable.numberOfLines = 0;
    contextLable.text = self.model.content;
    [backView addSubview:contextLable];
    
    UILabel *timeLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 160, kScreenWidth - 40, 30)];
    timeLable.textColor = kColor(204, 204, 204);
    timeLable.text = self.model.sendTime;
    timeLable.textAlignment = NSTextAlignmentRight;
    [backView addSubview:timeLable];
}


- (void)setTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    [_tableView registerClass:[MessageTwoTableViewCell class] forCellReuseIdentifier:MessageTwo];
    [self.view addSubview:_tableView];
    
    self.tempCell = [[MessageTwoTableViewCell alloc]initWithStyle:0 reuseIdentifier:MessageTwo];
}


- (void)uploadDataReadAlreadyToUnread{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html", nil];
    
    [manager GET:[NSString stringWithFormat:@"%@/webMessage/updateCommercialMsgStatus/%@/%@",HXECOMMEN,_model.id,KUSERID] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
     //   NSLog(@"%@",responseObject);
        if ([responseObject[@"status"] integerValue] == 200) {

            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReadAlreadyToUnread" object:nil];
        }else{
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 0.000001;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//
//    UIView *view = [[UIView alloc]init];
//    return view;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 1;
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return _dataArr.count;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    MessageModel *model = _dataArr[indexPath.section];
//    if (model.cellHeight == 0) {
//        CGFloat cellHeight = [self.tempCell heightForModel:_dataArr[indexPath.section]];
//
//        // 缓存给model
//        model.cellHeight = cellHeight;
//
//        return cellHeight;
//    } else {
//        return model.cellHeight;
//    }
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    MessageTwoTableViewCell *twoCell = [tableView dequeueReusableCellWithIdentifier:MessageTwo forIndexPath:indexPath];
//
//    twoCell.layer.masksToBounds = YES;
//    twoCell.layer.cornerRadius = 6;
//
//    [twoCell setMessageWith:_dataArr[indexPath.section]];
//
//    return twoCell;
//}



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
