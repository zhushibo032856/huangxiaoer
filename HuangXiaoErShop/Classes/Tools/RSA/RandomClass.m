//
//  RandomClass.m
//  DoDao
//
//  Created by QF on 2017/4/5.
//  Copyright © 2017年 QF. All rights reserved.
//

#import "RandomClass.h"

@implementation RandomClass


+ (NSString *)shareRandomStringWithUUID {
    NSString *random = [[NSUUID UUID] UUIDString];
    return random;
}


+ (NSString *)shareRandomStringWith32 {
    NSString *random = [[NSString alloc]init];
    for (int i = 0; i < 32; i++) {
        int number = arc4random() % 36;
        if (number < 10) {
            int figure = arc4random() % 10;
            NSString *tempString = [NSString stringWithFormat:@"%d", figure];
            random = [random stringByAppendingString:tempString];
        }else {
            int figure = (arc4random() % 26) + 97;
            char character = figure;
            NSString *tempString = [NSString stringWithFormat:@"%c", character];
            random = [random stringByAppendingString:tempString];
        }
    }
    return random;
}
+ (NSString *)shareRandomStringWith10Number {
    NSString *random = [[NSString alloc]init];
    for (int i = 0; i < 10; i++) {
        int figure = arc4random() % 10;
        NSString *tempString = [NSString stringWithFormat:@"%d", figure];
        random = [random stringByAppendingString:tempString];
    }
    return random;
}

+ (BOOL)checkTelNumber:(NSString *) telNumber{
    NSString *pattern = @"^(13[0-9]|14[0-9]|15[0-9]|16[0-9]|17[0-9]|18[0-9]|19[0-9])\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    return isMatch;
}

+ (NSString *)getNowTime {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *DateTime = [formatter stringFromDate:date];
    return DateTime;
}


+ (NSUInteger)textLength: (NSString *) text{
    NSUInteger asciiLength = 0;
    for (NSUInteger i = 0; i < text.length; i++) {
        unichar uc = [text characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
    }
    NSUInteger unicodeLength = asciiLength;
    return unicodeLength;
}


@end
