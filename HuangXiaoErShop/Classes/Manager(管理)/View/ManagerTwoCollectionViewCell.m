//
//  ManagerTwoCollectionViewCell.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "ManagerTwoCollectionViewCell.h"

@implementation ManagerTwoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.imageView.frame = CGRectMake((kScreenWidth / 3 - 30) / 2, 10, 30, 30);
        self.titleLableTwo.frame = CGRectMake(10, 45, kScreenWidth / 3 - 20, 20);
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.titleLableTwo];
    }
    return self;
}



- (UIImageView *)imageView {
    
    if (!_imageView) {
        _imageView = [UIImageView new];
        //        _imageView.backgroundColor = [UIColor yellowColor];
    }
    return _imageView;
}

- (UILabel *)titleLableTwo {
    
    if (!_titleLableTwo) {
        _titleLableTwo = [UILabel new];
        //        _titleLableTwo.backgroundColor = [UIColor yellowColor];
        _titleLableTwo.textAlignment = NSTextAlignmentCenter;
        _titleLableTwo.font = [UIFont systemFontOfSize:12];
    }
    return _titleLableTwo;
}

@end
