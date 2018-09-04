//
//  LVDatePickerModel.m
//  TravelWithPetApp
//
//  Created by 吕亚斌 on 2018/4/10.
//  Copyright © 2018年 吕亚斌. All rights reserved.
//

#import "LVDatePickerModel.h"
#import "NSDate+LVDatePicker.h"
@implementation LVDatePickerModel
- (instancetype)initWithLVDate:(NSDate *)date {
    return [self initWithLVDate:date formatter:@"yyyyMMddHHmm"];
}
- (instancetype)initWithLVDate:(NSDate *)date formatter:(NSString *)matter{
    if (self = [super init]) {
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        formatter.dateFormat = matter;
        NSString *dateStr = [formatter stringFromDate:date];
        
        _year = [dateStr substringWithRange:NSMakeRange(0, 4)];
        _month = [dateStr substringWithRange:NSMakeRange(4, 2)];
        _day = [dateStr substringWithRange:NSMakeRange(6, 2)];
        _weekdayName = [date fetchWeekdayNameCN:YES];
        
    }
    return self;
}
@end
