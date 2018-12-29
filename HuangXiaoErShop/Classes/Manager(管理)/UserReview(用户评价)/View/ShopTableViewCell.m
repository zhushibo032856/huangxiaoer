//
//  ShopTableViewCell.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/12/26.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "ShopTableViewCell.h"

@implementation ShopTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)setDataForCellWith:(UserReviewModel *)model{
    if (kStringIsEmpty(model.shopReply)) {
        self.shopReply.text = @"";
    }else{
        self.shopReply.text = [NSString stringWithFormat:@"%@",model.shopReply];
    }
    
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
