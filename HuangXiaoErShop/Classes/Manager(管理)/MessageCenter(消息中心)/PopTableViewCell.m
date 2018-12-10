//
//  PopTableViewCell.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/12/5.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "PopTableViewCell.h"

@implementation PopTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatAutoLayout];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)creatAutoLayout{
    
    self.typeLable.frame = CGRectMake(10, 10, 200, 30);
    self.sureImage.frame = CGRectMake(kScreenWidth - 50, 10, 30, 30);
    [self.contentView addSubview:self.typeLable];
    [self.contentView addSubview:self.sureImage];
}

- (UILabel *)typeLable{
    if (!_typeLable) {
        _typeLable = [[UILabel alloc]init];
    }
    return _typeLable;
}
- (UIImageView *)sureImage{
    if (!_sureImage) {
        _sureImage = [[UIImageView alloc]init];
        [_sureImage setImage:[UIImage imageNamed:@"selectimage"]];
    }
    return _sureImage;
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
