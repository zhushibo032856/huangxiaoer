//
//  RecommendedCollectionViewCell.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/12/24.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "RecommendedCollectionViewCell.h"

@implementation RecommendedCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self initImageView];
    }
    return self;
}

- (void)setPictureImageWith:(RecommendModel *)mode{
    
    [_pictureImage sd_setImageWithURL:[NSURL URLWithString:mode.imgUrl] placeholderImage:[UIImage imageNamed:@"userName"]];
    
}

- (void)initImageView{
    self.pictureImage.frame = self.contentView.frame;
    [self.contentView addSubview:self.pictureImage];
}
- (UIImageView *)pictureImage{
    if (!_pictureImage) {
        _pictureImage = [[UIImageView alloc]init];
    }
    return _pictureImage;
}

@end
