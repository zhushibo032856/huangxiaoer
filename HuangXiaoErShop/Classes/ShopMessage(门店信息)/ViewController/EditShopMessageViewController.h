//
//  EditShopMessageViewController.h
//  HuangXiaoErShop
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "BaseViewController.h"
@class ManagerModel;

@interface EditShopMessageViewController : BaseViewController

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) ManagerModel *model;

@end
