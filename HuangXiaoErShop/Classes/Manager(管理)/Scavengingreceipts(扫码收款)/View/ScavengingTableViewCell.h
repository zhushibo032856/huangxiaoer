//
//  ScavengingTableViewCell.h
//  HXEshop
//
//  Created by apple on 2018/5/4.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScavengModel.h"
@interface ScavengingTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *payImageView;
@property (nonatomic, strong) UILabel *timeLable;
@property (nonatomic, strong) UILabel *moneyLable;
@property (nonatomic, strong) UILabel *orderNumberLable;
- (void)cellSetDataWith:(ScavengModel *)model;
@end
