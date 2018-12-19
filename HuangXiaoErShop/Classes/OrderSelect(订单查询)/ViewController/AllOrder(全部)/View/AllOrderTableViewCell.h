//
//  JieDanCell.h
//  zhedie
//
//  Created by Apple on 2018/3/4.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellModel.h"

@interface AllOrderTableViewCell : UITableViewCell

- (void)cellViewsValueWithModel:(CellModel *)model;


@property (weak, nonatomic) IBOutlet UIView *addView;
@property (weak, nonatomic) IBOutlet UILabel *BeiZhuLable;

@property (weak, nonatomic) IBOutlet UILabel *CouponsLable;

@property (weak, nonatomic) IBOutlet UILabel *OrderNumber;
@property (weak, nonatomic) IBOutlet UILabel *CreatTime;
@property (weak, nonatomic) IBOutlet UILabel *AchieveTime;

@end
