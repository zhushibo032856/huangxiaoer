//
//  UIPickerView+LVPickerView.m
//  TravelWithPetApp
//
//  Created by 吕亚斌 on 2018/4/10.
//  Copyright © 2018年 吕亚斌. All rights reserved.
//

#import "UIPickerView+LVPickerView.h"

@implementation UIPickerView (LVPickerView)
- (void)clearSpearatorLine{
    [self setSpearatorLine:[UIColor clearColor]];
}
- (void)setSpearatorLine:(UIColor *)lineColor{
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.frame.size.height < 1)
        {
            [obj setBackgroundColor:lineColor];
        }
    }];
}
- (void)setDefaultsSpearatorLine{
    [self setSpearatorLine:[UIColor colorWithHexString:@"#FFD200"]];
}
@end
