//
//  BirthdayView.h
//  TravelWithPetApp
//
//  Created by 吕亚斌 on 2018/4/10.
//  Copyright © 2018年 吕亚斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LVDatePickerView.h"
@interface BirthdayView : UIView

/**
 生日
 */
@property (nonatomic, strong) LVDatePickerModel *birthDay;
/**
 选择时间的回调
 */
@property (nonatomic, copy) void (^timeBlock)(LVDatePickerModel *birth);
- (void)showBirthView;
@end
