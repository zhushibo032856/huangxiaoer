//
//  NewOrderViewController.m
//  HXEshop
//
//  Created by apple on 2018/3/8.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "RefundViewController.h"
#import "TuiKuanCell.h"
#import "HeadView.h"
#import "CellModel.h"
#import "OrderLayoutModel.h"


@interface RefundViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) HeadView *currentSecHeadView;


@property (nonatomic, strong) NSMutableArray *layoutArr;

@property (nonatomic, strong) UISwitch *AutoSwitch;

@property (nonatomic, assign) NSInteger thePage;

@end

@implementation RefundViewController

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}


- (NSMutableArray *)layoutArr {
    if (!_layoutArr) {
        self.layoutArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _layoutArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    CGFloat commen = kNav_H + kTabbar_H;
    if (iPhoneX) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - commen - 120) style:(UITableViewStyleGrouped)];
    }else{
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 49) style:(UITableViewStyleGrouped)];
    }

  //  self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 0 -  64 - 49) style:(UITableViewStyleGrouped)];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"TuiKuanCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TuiKuanCell"];
    self.tableView.delaysContentTouches = YES;
    [self setRefresh];
}

- (void)setRefresh {
    _thePage = 1;
    __block typeof(self)weakself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.tableView.mj_footer resetNoMoreData];
        weakself.thePage = 1;
        [self getdata];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.thePage += 1;
        [self getdata];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CellModel *model = self.dataSource[section];
    if (model.isShow) {
        return 1;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderLayoutModel *model = self.layoutArr[indexPath.section];
    CellModel *cellmodel = self.dataSource[indexPath.section];
    if (4 == [cellmodel.isPay  integerValue]) {
        return model.cellHei  - 50;
    }
    //    else if (3 == [cellmodel.isPay  integerValue]) {
    //        return model.cellHei  - 50;
    //    } else
    {
        return model.cellHei;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CellModel *model = self.dataSource[indexPath.section];
    TuiKuanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TuiKuanCell" forIndexPath:indexPath];
    cell.index = indexPath.section;
    [cell cellViewsValueWithModel:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    __weak typeof(self)weakSelf = self;
    cell.block = ^(NSInteger index, NSInteger btnTag) {
        
        [weakSelf updatOrderStatusWithIndex:index BtnTag:btnTag];
       
    };

    return cell;
}
//退款功能
- (void)updatOrderStatusWithIndex:(NSInteger)index
                           BtnTag:(NSInteger)btnTag
{
   // CellModel *model = self.dataSource[index];
    if (btnTag == 400) {
      //  NSLog(@"拒绝");
        [MBProgressHUD showError:@"该功能暂未开放"];
       // return;
    } else {
      //  [self isTuiKuanWithOrderNum:model.orderNum index:index];
        [MBProgressHUD showError:@"该功能暂未开放"];
     //   return;
    }
    
}


- (void)isTuiKuanWithOrderNum:(NSString *)orderNum
                           index:(NSInteger)index
{
    
    NSDictionary *partner = @{
                              @"token":KUSERID,
                              @"orderNum":orderNum
                              };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html", nil];
    
    [manager POST:[NSString stringWithFormat:@"%@/apppay/refund",HXEORDER] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        if ([responseObject[@"status"] integerValue] == 200 ) {
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:(UITableViewRowAnimationBottom)];
            [MBProgressHUD showSuccess:@"退款成功"];
        }else{
            [MBProgressHUD showError:@"退款失败，请重新尝试"];
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.tableView.mj_header endRefreshing];
    }];
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CellModel *model = self.dataSource[section];
    HeadView *sectionHeadView = [HeadView SetHeadView];
    sectionHeadView.frame = CGRectMake(0, 0, self.view.frame.size.width, 50);
    sectionHeadView.Bt.tag = section + 1000;
    OrderCaiModel *caiModel = model.arr.firstObject;
    
    if ([model.orderType isEqualToString:@"APPOINTMENT"]) {
        [sectionHeadView.TypeImageView setImage:[UIImage imageNamed:@"APPOINTMENT"]];
    }else if ([model.orderType isEqualToString:@"ARRIVE"]){
        [sectionHeadView.TypeImageView setImage:[UIImage imageNamed:@"ARRIVE"]];
    }else if([model.orderType isEqualToString:@"PT"]){
        [sectionHeadView.TypeImageView setImage:[UIImage imageNamed:@"PT"]];
    }
    
    NSString *string = [model.useDate substringWithRange:NSMakeRange(6, 10)];
    
    sectionHeadView.timeLb.text = [NSString stringWithFormat:@"%@",string];
    
    sectionHeadView.xunxuLb.text = [NSString stringWithFormat:@"%@",model.takeNum];
    if (model.arr.count == 1) {
        sectionHeadView.nameLable.text = [NSString stringWithFormat:@"%@  1",caiModel.goodsName];
    }else{
        sectionHeadView.nameLable.text = [NSString stringWithFormat:@"%@  ···",caiModel.goodsName];
    }
    
    if (4 == [model.isPay integerValue]) {
        sectionHeadView.statusLb.text = @"已退款";
        sectionHeadView.statusLb.textColor = [UIColor darkGrayColor];
    } else {
        sectionHeadView.statusLb.text = @"等待退款";
        sectionHeadView.statusLb.textColor = [UIColor darkGrayColor];
    }
    
    
    [sectionHeadView.Bt addTarget:self action:@selector(BtAction:) forControlEvents:(UIControlEventTouchUpInside)];
    return sectionHeadView;
}
- (void)BtAction:(UIButton *)sender {
    CellModel *model = self.dataSource[sender.tag - 1000];
    model.isShow = !model.isShow;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag - 1000] withRowAnimation:(UITableViewRowAnimationBottom)];
}




- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return view;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"------------");
}


- (void)getdata{
    NSDate *date =[NSDate date];
    NSString *currentTime = [[NSString stringWithFormat:@"%@", date]substringWithRange:NSMakeRange(0, 10)];
    NSString *string = @" 00:00:00";
    NSString *createTime = [NSString stringWithFormat:@"%@""%@",currentTime,string];
    
    NSDictionary *partner = @{
                              @"createTime":createTime,
                              @"token":KUSERID,
                              @"isPay":@"2",
                              @"orderStatus":@"3",
                              @"page":@(_thePage),
                              @"size":@"20",
                              };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html", nil];
    
    [manager POST:[NSString stringWithFormat:@"%@/appordersr/findOrdersByDate",HXEORDER] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      //  NSLog(@"findallall---%@",responseObject);
        if ([responseObject[@"status"] integerValue] == 200){
            if (_thePage == 1) {
                [self.dataSource removeAllObjects];
                [self.layoutArr removeAllObjects];
            }
            NSDictionary *dataDic = responseObject[@"data"];
            NSArray *arr = dataDic[@"rows"];
            for (NSDictionary *xd in arr) {
                CellModel *model = [CellModel new];
                [model setValuesForKeysWithDictionary:xd];
                [self.dataSource addObject:model];
                
                OrderLayoutModel *layoutModel = [OrderLayoutModel new];
                [layoutModel getCellHitghtWithCellModel:model];
                [self.layoutArr addObject:layoutModel];
                
            }
            if (_thePage == 1) {
                [self.tableView.mj_header endRefreshing];
            }else{
                if (arr.count == 0) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [self.tableView.mj_footer endRefreshing];
                }
            }
            [self.tableView reloadData];
        }else if ([responseObject[@"status"] integerValue] == 301){
            [self.tableView.mj_header endRefreshing];
            [[AppDelegate mainAppDelegate] showLoginView];
        }else {
            [self.tableView.mj_header endRefreshing];
            [MBProgressHUD showMessage:responseObject[@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end



