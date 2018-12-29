//
//  SumTableViewCell.h
//  HuangXiaoErShop
//
//  Created by apple on 2018/12/26.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberModel.h"

@interface SumTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *todayNumberLable;
@property (nonatomic, strong) UILabel *sunNumberLable;

- (void)setdataForCellWith:(MemberModel *)model;

@end
