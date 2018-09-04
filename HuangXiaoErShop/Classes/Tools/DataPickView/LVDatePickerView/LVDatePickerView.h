//
//  LVDatePickerView.h
//  TravelWithPetApp
//
//  Created by 吕亚斌 on 2018/4/10.
//  Copyright © 2018年 吕亚斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LVDatePickerModel.h"
#import "LVDateHelper.h"
@interface LVDatePickerView : UIView

//注意 这里请使用LVDateHelper 来初始化时间 内部处理了时区的问题

/**
 注意 这里请使用LVDateHelper来初始化时间
 */
@property (nonatomic, strong) NSDate *minLimitedDate; ///< 最小限制时间 即显示的最小时间；默认值为当前时间的前一百年 格式为@"1970-01-01 00:00"

/**
 注意 这里请使用LVDateHelper来初始化时间
 */
@property (nonatomic, strong) NSDate *maxLimitedDate; ///< 最大限制时间 即显示的最大时间；默认值为当前时间的后一百年 格式为@"2060-12-31 23:59"

/**
 注意 这里请使用LVDateHelper来初始化时间
 */
@property (nonatomic, strong) NSDate *defaultLimitedminDate; ///< 默认限制时间；默认值为最小限制时间，当选择时间不在指定范围 格式依然为：@"2018-04-10 23:59"

/**
 注意 这里请使用LVDateHelper来初始化时间
 */
@property (nonatomic, strong) NSDate *defailtLimitedMaxDate;//能滚动到的最大时间 默认为最大时间

/**
 注意 这里请使用LVDateHelper来初始化时间
 */
@property (nonatomic, strong) NSDate *scrollToDate; ///< 滚动到指定时间；默认值为当前时间 （其实就是为了记录上次选择的时间）
//回调选择时间
@property (nonatomic, copy) void (^timeBlock)(LVDatePickerModel *timeModel);

//更新数据 更新完了上面的时间属性之后 记得调用这个方法 刷新数据
- (void)loadDataSouce;
@end
