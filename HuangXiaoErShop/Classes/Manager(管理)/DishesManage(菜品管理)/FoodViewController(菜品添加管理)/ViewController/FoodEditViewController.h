
//  FoodEditViewController.h
//  HXEshop
//
//  Created by apple on 2018/3/28.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "BaseViewController.h"
@class RightDataModel;

@interface FoodEditViewController : BaseViewController

@property (nonatomic, strong) RightDataModel *model;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSMutableArray *cateDataArr;

@end
