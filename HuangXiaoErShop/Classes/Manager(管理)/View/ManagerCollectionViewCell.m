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
        self.titleLableOne.frame = CGRectMake(0, 20, kScreenWidth / 3 - 10, 20);
        self.numberLable.frame = CGRectMake(0, 50, kScreenWidth / 3 - 10, 30);
        [self.contentView addSubview:self.titleLableOne];
        [self.contentView addSubview:self.numberLable];
    }
    return self;
}


- (UILabel *)numberLable {
    
    if (!_numberLable) {
        _numberLable = [UILabel new];
        _numberLable.textAlignment = NSTextAlignmentCenter;
        _numberLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
        
    }
    return _numberLable;
}

- (UILabel *)titleLableOne {
    
    if (!_titleLableOne) {
        _titleLableOne = [UILabel new];
        _titleLableOne.textAlignment = NSTextAlignmentCenter;
        _titleLableOne.font = [UIFont systemFontOfSize:15];;
    }
    return _titleLableOne;
}


@end
