//
//  HeadView.m
//  zhedie
//
//  Created by Apple on 2018/3/4.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "HeadView.h"

@implementation HeadView

+ (instancetype)SetHeadView {
    return [[[NSBundle mainBundle] loadNibNamed:@"HeadView" owner:nil options:nil] firstObject];
}

@end
