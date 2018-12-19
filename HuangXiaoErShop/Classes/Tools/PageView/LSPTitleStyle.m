//
//  XTitleStyle.m
//  PageViewDemo
//  https://github.com/MrLSPBoy/PageViewController
//  Created by Object on 17/7/11.
//  Copyright © 2017年 Object. All rights reserved.
//
#define kColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#import "LSPTitleStyle.h"

@implementation LSPTitleStyle

- (instancetype)init{
    if (self = [super init]) {
        
        self.isTitleViewScrollEnable = NO;
        self.isContentViewScrollEnable = YES;
        self.normalColor = kColor(102, 102, 102);
        self.selectedColor = kColor(255, 210, 0);
        self.font = [UIFont systemFontOfSize:13.0];
        self.titleMargin = 0.0;
        self.isShowBottomLine = YES;
        self.bottomLineColor = kColor(255, 210, 0);
        self.bottomLineH = 4.0;
        self.isNeedScale = YES;
        self.scaleRange = 1.2;
        self.isShowCover = YES;
        self.coverBgColor = [UIColor whiteColor];
        self.coverMargin = 0.0;
        self.coverH = 25.0;
        self.coverRadius = 5;
    }
    return self;
}

@end
