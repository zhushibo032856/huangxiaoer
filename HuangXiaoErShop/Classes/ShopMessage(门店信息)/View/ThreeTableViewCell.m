//
//  ThreeTableViewCell.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "ThreeTableViewCell.h"

@implementation ThreeTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatAutoLayout];
    }
    return self;
}

- (void)creatAutoLayout{
    
    [self.contentView addSubview:self.localLable];
    
    self.localLable.sd_layout.topSpaceToView(self.contentView, 10).leftSpaceToView(self.contentView, 10).widthIs(100).heightIs(30);
    
}

- (UILabel *)localLable{
    
    if (!_localLable) {
        _localLable = [UILabel new];
        _localLable.font = [UIFont systemFontOfSize:13];
    }
    return _localLable;
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
