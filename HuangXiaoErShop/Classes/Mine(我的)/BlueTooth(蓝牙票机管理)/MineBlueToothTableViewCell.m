//
//  MineBlueToothTableViewCell.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/10/30.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "MineBlueToothTableViewCell.h"

@implementation MineBlueToothTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatAutoLayout];
    }
    return self;
}

- (void)creatAutoLayout{
    
    [self.contentView addSubview:self.printImage];
    [self.contentView addSubview:self.nameLable];
    
    self.printImage.frame = CGRectMake(20, 10, 30, 30);
    self.nameLable.frame = CGRectMake(CGRectGetMaxX(self.printImage.frame) + 10, 10, kScreenWidth * 0.7, 30);
}

- (UIImageView *)printImage{
    if (!_printImage) {
        _printImage = [[UIImageView alloc]init];
        [_printImage setImage:[UIImage imageNamed:@"bleMachines"]];
    }
    return _printImage;
}

- (UILabel *)nameLable{
    if (!_nameLable) {
        _nameLable = [[UILabel alloc]init];
    }
    return _nameLable;
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
