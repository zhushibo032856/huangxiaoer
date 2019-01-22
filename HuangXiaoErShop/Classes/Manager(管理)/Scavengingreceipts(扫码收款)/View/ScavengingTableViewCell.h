//
//  ScavengingTableViewCell.h
//  HuangXiaoErShop
//
//  Created by apple on 2019/1/16.
//  Copyright © 2019年 aladdin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScavengModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScavengingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *TypeImage;
@property (weak, nonatomic) IBOutlet UILabel *TypeIncome;
@property (weak, nonatomic) IBOutlet UILabel *IncomeLable;
@property (weak, nonatomic) IBOutlet UILabel *OrderNumber;
@property (weak, nonatomic) IBOutlet UILabel *OrderTime;

- (void)cellSetDataWith:(ScavengModel *)model;

@end

NS_ASSUME_NONNULL_END
