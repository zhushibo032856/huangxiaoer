//
//  LVDatePickerModel.h
//  TravelWithPetApp
//
//  Created by 吕亚斌 on 2018/4/10.
//  Copyright © 2018年 吕亚斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LVDatePickerModel : NSObject
@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *month;
@property (nonatomic, copy) NSString *day;
@property (nonatomic, copy) NSString *weekdayName;
- (instancetype)initWithLVDate:(NSDate *)date;
- (instancetype)initWithLVDate:(NSDate *)date formatter:(NSString *)matter;
@end
