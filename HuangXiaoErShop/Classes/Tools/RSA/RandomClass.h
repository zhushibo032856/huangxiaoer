//
//  RandomClass.h
//  DoDao
//
//  Created by QF on 2017/4/5.
//  Copyright © 2017年 QF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RandomClass : NSObject

+ (NSString *)shareRandomStringWithUUID;
+ (NSString *)shareRandomStringWith32;
+ (NSString *)shareRandomStringWith10Number;
+ (BOOL)checkTelNumber:(NSString *) telNumber;

+ (NSUInteger)textLength: (NSString *) text;

+ (NSString *)getNowTime;//获取当前时间

@end
