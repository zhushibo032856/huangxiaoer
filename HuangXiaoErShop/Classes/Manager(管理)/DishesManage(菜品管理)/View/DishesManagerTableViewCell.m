//
//  DishesManagerTableViewCell.m
//  HXEshop
//
//  Created by apple on 2018/3/2.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "DishesManagerTableViewCell.h"

@implementation DishesManagerTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    //    self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatAutoLayout];
    }
    return self;
}

- (void)creatAutoLayout{
    
    [self.contentView addSubview:self.dishesLable];
    
    self.dishesLable.sd_layout.topSpaceToView(self.contentView, 5).leftSpaceToView(self.contentView, 5).rightSpaceToView(self.contentView, 5).bottomSpaceToView(self.contentView, 5);
    
}

- (UILabel *)dishesLable{
    
    if (!_dishesLable) {
        _dishesLable = [UILabel new];
        _dishesLable.textAlignment = NSTextAlignmentCenter;
        _dishesLable.font = [UIFont systemFontOfSize:15];
    }
    return _dishesLable;
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
