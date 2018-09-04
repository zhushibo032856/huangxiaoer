//
//  QRTableViewCell.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "QRTableViewCell.h"
#import "QRModel.h"

@implementation QRTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatAutoLayout];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (void)setDataForCellWithModel:(QRModel *)model{
    
    self.numLable.text = model.machineNum;
    
}

- (void)creatAutoLayout{
    
    [self.contentView addSubview:self.machImageView];
    [self.contentView addSubview:self.numLable];
    [self.contentView addSubview:self.nameLable];
    
    self.machImageView.frame = CGRectMake(20, 20, 20, 20);
    self.nameLable.frame = CGRectMake(CGRectGetMaxY(self.machImageView.frame) + 20, 20, 80, 20);
    self.numLable.frame = CGRectMake(kScreenWidth * 0.6, 20, kScreenWidth * 0.3, 20);
    
}

- (UIImageView *)machImageView{
    
    if (!_machImageView) {
        _machImageView = [UIImageView new];
        // _machImageView.backgroundColor = [UIColor redColor];
        [_machImageView setImage:[UIImage imageNamed:@"ShopImage-1"]];
    }
    return _machImageView;
}

- (UILabel *)nameLable{
    if (!_nameLable) {
        _nameLable = [UILabel new];
        _nameLable.text = @"机具号";
    }
    return _nameLable;
}

- (UILabel *)numLable{
    if (!_numLable) {
        _numLable = [UILabel new];
        _numLable.textAlignment = NSTextAlignmentRight;
    }
    return _numLable;
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
