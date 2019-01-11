//
//  SumTableViewCell.h
//  HuangXiaoErShop
//
//  Created by apple on 2019/1/7.
//  Copyright © 2019年 aladdin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberModel.h"

@interface SumTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *NewCustomLable;

@property (weak, nonatomic) IBOutlet UILabel *CustomLable;



- (void)setdataForCellWith:(MemberModel *)model;

@end
