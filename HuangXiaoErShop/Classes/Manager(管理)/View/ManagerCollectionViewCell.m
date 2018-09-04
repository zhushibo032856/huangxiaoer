//
//  ManagerCollectionViewCell.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "ManagerCollectionViewCell.h"

@implementation ManagerCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.titleLableOne.frame = CGRectMake(10, 10, kScreenWidth / 3 - 20, 20);
        self.numberLable.frame = CGRectMake(20, 40, kScreenWidth / 3 - 40, 20);
        [self.contentView addSubview:self.titleLableOne];
        [self.contentView addSubview:self.numberLable];
    }
    return self;
}


- (UILabel *)numberLable {
    
    if (!_numberLable) {
        _numberLable = [UILabel new];
        _numberLable.textAlignment = NSTextAlignmentCenter;
        _numberLable.font = [UIFont systemFontOfSize:24];
        
    }
    return _numberLable;
}

- (UILabel *)titleLableOne {
    
    if (!_titleLableOne) {
        _titleLableOne = [UILabel new];
        _titleLableOne.textAlignment = NSTextAlignmentCenter;
        _titleLableOne.font = [UIFont systemFontOfSize:12];;
    }
    return _titleLableOne;
}


@end
