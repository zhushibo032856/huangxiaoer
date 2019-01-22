//
//  ScavengingTableViewCell.m
//  HuangXiaoErShop
//
//  Created by apple on 2019/1/16.
//  Copyright © 2019年 aladdin. All rights reserved.
//

#import "ScavengingTableViewCell.h"

@implementation ScavengingTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)cellSetDataWith:(ScavengModel *)model{
    
    if ([model.payType integerValue] == 1) {
        [self.TypeImage setImage:[UIImage imageNamed:@"WeChat"]];
        self.TypeIncome.text = @"微信收款";
    }else{
        [self.TypeImage setImage:[UIImage imageNamed:@"AliPay"]];
        self.TypeIncome.text = @"支付宝收款";
    }
    
    self.IncomeLable.text = [NSString stringWithFormat:@"+%.2f",model.realFee];
    self.OrderNumber.text = [NSString stringWithFormat:@"%@",model.orderNum];
    self.OrderTime.text = [NSString stringWithFormat:@"%@",model.createTime];
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
