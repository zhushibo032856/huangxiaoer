//
//  MemberTableViewCell.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/12/25.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "MemberTableViewCell.h"

@implementation MemberTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setDataForCellWith:(MemberModel *)model{
    if (kStringIsEmpty(model.nickName)) {
        self.NameLable.text = [NSString stringWithFormat:@"黄小二用户"];
    }else{
        self.NameLable.text = [NSString stringWithFormat:@"%@",model.nickName];
    }
    
    self.TotalNumberLable.text = [NSString stringWithFormat:@"近半年下单%@次",model.orderCount];
    
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
