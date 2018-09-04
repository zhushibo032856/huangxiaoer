//
//  UIColor+LVAdd.h
//  LVDatePickerView
//
//  Created by 吕亚斌 on 2018/4/10.
//  Copyright © 2018年 吕亚斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (LVAdd)
+ (UIColor *)colorWithHexString:(NSString *)color;
+ (UIColor *)alphaColorWithHexString:(NSString *)color colorAlpha:(CGFloat)alpha;
@end
