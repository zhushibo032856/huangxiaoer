//
//  UIPickerView+LVPickerView.h
//  TravelWithPetApp
//
//  Created by 吕亚斌 on 2018/4/10.
//  Copyright © 2018年 吕亚斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPickerView (LVPickerView)

/**
 清除中间的横线
 */
- (void)clearSpearatorLine;

/**
 设置中间的横线颜色 上面的方法可以直接调用下面的方法，设为clearColor
 */
- (void)setSpearatorLine:(UIColor *)lineColor;
- (void)setDefaultsSpearatorLine;
@end
