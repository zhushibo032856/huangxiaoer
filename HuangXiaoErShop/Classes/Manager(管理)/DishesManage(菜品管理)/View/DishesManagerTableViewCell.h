//
//  DishesManagerTableViewCell.h
//  HXEshop
//
//  Created by apple on 2018/3/2.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LeftDataModel;

@interface DishesManagerTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *dishesLable;
@property (nonatomic, strong) LeftDataModel *leftDataModel;

@end
