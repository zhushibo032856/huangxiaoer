//
//  MemberTableViewCell.h
//  HuangXiaoErShop
//
//  Created by apple on 2018/12/25.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberModel.h"

@interface MemberTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *NumberLable;
@property (weak, nonatomic) IBOutlet UILabel *NameLable;
@property (weak, nonatomic) IBOutlet UILabel *TotalNumberLable;

- (void)setDataForCellWith:(MemberModel *)model;

@end
