//
//  NoneDataTableViewCell.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/12/25.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "NoneDataTableViewCell.h"

@interface NoneDataTableViewCell ()

@property (nonatomic, strong) UIImageView *noneAddressImg;

@property (nonatomic, strong) UILabel *tipsLabel;

@end

@implementation NoneDataTableViewCell

- (void)showNoDataWithImgurl:(NSString *)imageName
                andTipString:(NSString *)tips {
    
    self.noneAddressImg.frame = CGRectMake(kScreenWidth / 4, 0, kScreenWidth / 2, kScreenWidth / 2);
    self.noneAddressImg.image = [UIImage imageNamed:imageName];
    
    self.tipsLabel.frame = CGRectMake(0, kScreenWidth / 2 + 20, self.bounds.size.width, 30);
    self.tipsLabel.text = tips;
}


- (UIImageView *)noneAddressImg {
    
    if (!_noneAddressImg) {
        self.noneAddressImg = [[UIImageView alloc] init];
        //        self.noneAddressImg.contentMode = UIViewContentModeScaleAspectFill;
        self.noneAddressImg.backgroundColor = kColor(240, 240, 240);
        self.noneAddressImg.alpha = 0.8f;
    }
    return _noneAddressImg;
}

- (UILabel *)tipsLabel {
    
    if (!_tipsLabel) {
        self.tipsLabel = [[UILabel alloc] init];
        self.tipsLabel.font = FontType_Text(15.f);
        self.tipsLabel.textColor = UIColorFromRGB(0x434343);
        self.tipsLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipsLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = kColor(240, 240, 240);
        [self.contentView addSubview:self.noneAddressImg];
        [self.contentView addSubview:self.tipsLabel];
    }
    return self;
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
