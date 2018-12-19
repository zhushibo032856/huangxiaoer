//
//  NewCancelTableViewCell.h
//  HuangXiaoErShop
//
//  Created by apple on 2018/12/17.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellModel.h"

@interface NewCancelTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *TypeImage;
@property (weak, nonatomic) IBOutlet UILabel *TakeNum;
@property (weak, nonatomic) IBOutlet UILabel *TypeLable;

@property (weak, nonatomic) IBOutlet UIView *AddView;

@property (weak, nonatomic) IBOutlet UILabel *BeizhuLable;
@property (weak, nonatomic) IBOutlet UILabel *RefundReason;

- (void)cellViewsValueWithModel:(CellModel *)model;

@end
