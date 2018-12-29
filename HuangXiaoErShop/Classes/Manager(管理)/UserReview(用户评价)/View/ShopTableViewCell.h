//
//  ShopTableViewCell.h
//  HuangXiaoErShop
//
//  Created by apple on 2018/12/26.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserReviewModel.h"

@interface ShopTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *shopReply;

- (void)setDataForCellWith:(UserReviewModel *)model;

@end
