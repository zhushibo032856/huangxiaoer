//
//  ShopMessageLableTableViewCell.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "ShopMessageLableTableViewCell.h"

@implementation ShopMessageLableTableViewCell

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
    [self.contentView addSubview:self.shopImage];
    
    self.localLable.sd_layout.leftSpaceToView(self.contentView, 10).topSpaceToView(self.contentView, 10).widthIs(100).heightIs(30);
    self.shopImage.sd_layout.topSpaceToView(self.contentView, 5).rightSpaceToView(self.contentView, 10).widthIs(50).heightIs(50);
    
}

- (UILabel *)localLable{
    
    if (!_localLable) {
        _localLable = [[UILabel alloc]init];
        _localLable.font = [UIFont systemFontOfSize:13];
    }
    return _localLable;
}

- (UIImageView *)shopImage{
    
    if (!_shopImage) {
        _shopImage = [[UIImageView alloc]init];
        [_shopImage sd_setImageWithURL:[NSURL URLWithString:KUSERIMAGEURL] placeholderImage:[UIImage imageNamed:@"userName"]];
    }
    return _shopImage;
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
