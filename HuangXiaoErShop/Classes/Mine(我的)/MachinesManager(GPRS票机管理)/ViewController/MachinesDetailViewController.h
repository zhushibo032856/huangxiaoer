//
//  MachinesDetailViewController.h
//  HuangXiaoErShop
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "BaseViewController.h"
@class MachinesModel;

@interface MachinesDetailViewController : BaseViewController

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) MachinesModel *model;

@end
