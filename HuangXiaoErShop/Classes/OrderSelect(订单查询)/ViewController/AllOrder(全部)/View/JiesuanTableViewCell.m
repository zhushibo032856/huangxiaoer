//
//  JiesuanTableViewCell.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/12/13.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "JiesuanTableViewCell.h"

@implementation JiesuanTableViewCell

- (void)setValueWith:(JiesuanModel *)model{
    self.orderNumberLable.text = [NSString stringWithFormat:@"共%@单",model.ordercount];
    self.incomeLable.text = [NSString stringWithFormat:@"收入%.2f元",model.orderfeesum];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
