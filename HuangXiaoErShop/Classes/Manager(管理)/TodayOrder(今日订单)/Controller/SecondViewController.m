//
//  SecondViewController.m
//  HXEshop
//
//  Created by apple on 2018/3/7.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "SecondViewController.h"
#import "TodayCancelTableViewCell.h"
#import "OrderCancelModel.h"

@interface SecondViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *orderTableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger thePage;

@end

static NSString * const cancelCell = @"cancelTableViewCell";

@implementation SecondViewController

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _orderTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 110) style:UITableViewStylePlain];
    _orderTableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_orderTableView];
    
    [_orderTableView registerClass:[TodayCancelTableViewCell class] forCellReuseIdentifier:cancelCell];
    
    _orderTableView.delegate = self;
    _orderTableView.dataSource = self;
    
    [self setRefresh];
    // Do any additional setup after loading the view.
}

- (void)setRefresh {
    
    _thePage = 1;
    __block typeof(self)weakself = self;
    self.orderTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.orderTableView.mj_footer resetNoMoreData];
        weakself.thePage = 1;
        [self requestData];
    }];
    
    self.orderTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.thePage += 1;
        [self requestData];
    }];
    // 进入界面时刷新
    [self.orderTableView.mj_header beginRefreshing];
    
}

- (void)requestData{
    
    NSDate *date =[NSDate date];
    NSString *currentTime = [[NSString stringWithFormat:@"%@", date]substringWithRange:NSMakeRange(0, 10)];
    NSString *string = @" 00:00:00";
    NSString *createTime = [NSString stringWithFormat:@"%@""%@",currentTime,string];
    
    NSDictionary *partner = @{
                              @"createTime": createTime,
                              @"isPay": @"2",
                              @"orderStatus": @"3",
                              @"page": @(_thePage),
                              @"size": @"20",
                              @"token": KUSERID
                              };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    [manager POST:[NSString stringWithFormat:@"%@/appordersr/findOrdersByDate",HXEORDER] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      //  NSLog(@"%@",responseObject);
        
        if ([responseObject[@"status"] integerValue] == 200) {
            if (self->_thePage == 1) {
                [self.dataArray removeAllObjects];
            }
            NSDictionary *dataDic = responseObject[@"data"];
            NSArray *arr = dataDic[@"rows"];
            for (NSDictionary *dic in arr) {
                OrderCancelModel *model = [[OrderCancelModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
            }
            if (self->_thePage == 1) {
                [self.orderTableView.mj_header endRefreshing];
            }else{
                if (arr.count == 0) {
                    [self.orderTableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [self.orderTableView.mj_footer endRefreshing];
                }
            }
            [self.orderTableView reloadData];
        }else {
            [self.orderTableView.mj_header endRefreshing];
            [MBProgressHUD showMessage:responseObject[@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showError:@"服务器异常"];
    }];
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 65;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TodayCancelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cancelCell forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    OrderCancelModel *model = self.dataArray[indexPath.row];
    
    if (self.dataArray.count == 0) {
        self.orderTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    }else{
        cell.numberLanle.text = [NSString stringWithFormat:@"%@%@",@"订单号",model.orderNum];
        cell.timeLable.text = [NSString stringWithFormat:@"%@%@",@"今天 ",model.useDate];
    }

    return cell;
    
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
