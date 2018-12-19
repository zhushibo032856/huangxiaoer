//
//  SimpleMasonryViewController.m
//  cell高度自适应内容
//
//  Created by 蔡强 on 2017/5/23.
//  Copyright © 2017年 kuaijiankang. All rights reserved.
//

#import "SimpleMasonryViewController.h"
#import "SimpleMasonryCell.h"
#import "UIView+frameAdjust.h"

NSString * const MasonryCellReuseID = @"CellReuseID";

@interface SimpleMasonryViewController () <UITableViewDataSource>

/** 数据源数组 */
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation SimpleMasonryViewController

#pragma mark - Lazy Load

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        NSString *text = @"内容越来越多";
        for (int i = 0; i < 100; i ++) {
            text = [text stringByAppendingString:@"越来越多"];
            SimpleMasonryModel *model = [[SimpleMasonryModel alloc] init];
            model.text = text;
            [_dataArray addObject:model];
        }
    }
    return _dataArray;
}

#pragma mark - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //------- tableView -------//
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:tableView];
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 175;
    [tableView registerClass:[SimpleMasonryCell class] forCellReuseIdentifier:MasonryCellReuseID];
}

#pragma mark - UITableView DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SimpleMasonryCell *cell = [tableView dequeueReusableCellWithIdentifier:MasonryCellReuseID];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

//------- 自动布局不实现此方法 -------//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 200;
//}

@end
