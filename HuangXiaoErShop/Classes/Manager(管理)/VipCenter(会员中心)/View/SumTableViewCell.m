//
//  SumTableViewCell.m
//  HuangXiaoErShop
//
//  Created by apple on 2019/1/7.
//  Copyright © 2019年 aladdin. All rights reserved.
//

#import "SumTableViewCell.h"

@implementation SumTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setdataForCellWith:(MemberModel *)model{
    
    self.NewCustomLable.text = [NSString stringWithFormat:@"%ld",(long)model.newCustomerCount];
    [self.NewCustomLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:25]];
    self.CustomLable.text = [NSString stringWithFormat:@"%ld",(long)model.customerCount];
    [self.CustomLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:25]];
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
