//
//  MineTableViewCell.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/8/6.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "MineTableViewCell.h"

@implementation MineTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatAutoLayout];
    }
    return self;
}

- (void)creatAutoLayout{
    
    [self.contentView addSubview:self.imageViewOne];
    [self.contentView addSubview:self.shopDetailLable];
    [self.contentView addSubview:self.imageViewTwo];
    
    self.imageViewOne.sd_layout.topSpaceToView(self.contentView, 13).leftSpaceToView(self.contentView, 13).widthIs(24).heightIs(24);
    
    self.shopDetailLable.sd_layout.topSpaceToView(self.contentView, 10).leftSpaceToView(self.imageViewOne, 10).widthIs(100).heightIs(30);
    
    self.imageViewTwo.sd_layout.topSpaceToView(self.contentView, 5).rightSpaceToView(self.contentView, 5).widthIs(40).heightIs(40);
}

- (UIImageView *)imageViewOne{
    
    if (!_imageViewOne) {
        
        _imageViewOne = [[UIImageView alloc]init];
        [_imageViewOne setImage:[UIImage imageNamed:@"shopImage"]];
        
    }
    return _imageViewOne;
}

- (UILabel *)shopDetailLable{
    
    if (!_shopDetailLable) {
        _shopDetailLable = [[UILabel alloc]init];
        _shopDetailLable.font = [UIFont systemFontOfSize:16];
        _shopDetailLable.text = @"门店信息";
    }
    return _shopDetailLable;
}

- (UIImageView *)imageViewTwo{
    
    if (!_imageViewTwo) {
        _imageViewTwo = [[UIImageView alloc]init];
   //     [_imageViewTwo setImage:[UIImage imageNamed:@"codeImage"]];
    }
    return _imageViewTwo;
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
