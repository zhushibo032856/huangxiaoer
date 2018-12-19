//
//  NewRefundTableViewCell.h
//  HuangXiaoErShop
//
//  Created by apple on 2018/12/17.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellModel.h"

@interface NewRefundTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *typeImage;
@property (weak, nonatomic) IBOutlet UILabel *takeNumLable;
@property (weak, nonatomic) IBOutlet UILabel *typeLable;
@property (weak, nonatomic) IBOutlet UIView *addView;
@property (weak, nonatomic) IBOutlet UILabel *beizhuLable;
@property (weak, nonatomic) IBOutlet UILabel *refundLable;
- (void)cellViewsValueWithModel:(CellModel *)model;
@end
