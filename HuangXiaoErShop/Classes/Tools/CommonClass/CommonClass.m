//
//  CommonClass.m
//  设置label行间距
//
//  Created by zaowuzhe12 on 2017/8/24.
//  Copyright © 2017年 HYY. All rights reserved.
//


#import "CommonClass.h"


@implementation CommonClass


#pragma mark -
#pragma mark --- 计算高度 ---

+ (CGFloat)calculateHeightWithText:(NSString *)string
                          withFont:(UIFont *)font
                       andTextSize:(CGSize)size {
    
    if (kStringIsEmpty(string)) {
        return 0;
    }
    NSDictionary *dic = @{
                          NSFontAttributeName : font
                          };
    CGRect rect = [string boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin) attributes:dic context:nil];
    return rect.size.height;
}


+ (CGFloat)calculateHeightWithLineBreakMode:(NSLineBreakMode)lineBreakMode
                                   withText:(NSString *)string
                                   withFont:(UIFont *)font
                                andTextSize:(CGSize)size {
    
    if (kStringIsEmpty(string)) {
        return 0;
    }
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = lineBreakMode;
    NSDictionary *dic = @{
                          NSFontAttributeName:font,
                          NSParagraphStyleAttributeName:style,
                          };
    CGRect rect = [string boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin) attributes:dic context:nil];
    return rect.size.height;
}


+ (NSDictionary *)setTextLineSpaceWithString:(NSString *)string
                           withLineBreakMode:(NSLineBreakMode)lineBreakMode withAlignment:(NSTextAlignment)alignment
                                    withFont:(UIFont *)font
                               withLineSpace:(CGFloat)lineSpace
                         withTextlengthSpace:(NSNumber *)textlengthSpace
                        andParagraphSpaceing:(CGFloat)paragraphSpacing {
    
    // 1. 创建样式对象
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    // 2. 每行容纳字符的宽度
    style.lineBreakMode = lineBreakMode;
    // 3. 对齐方式
    style.alignment = alignment;
    // 4. 设置行间距
    style.lineSpacing = lineSpace;
    // 5. 连字符号链接
    style.hyphenationFactor = 1.0f;
    // 6. 首行缩进
    style.firstLineHeadIndent = 0.f;
    // 7. 段间距
    style.paragraphSpacing = paragraphSpacing;
    // 8. 段前间距
    style.paragraphSpacingBefore = 0.0f;
    // 9. 除首行之外其他行缩进
    style.headIndent = 0.0f;
    // 10. 每行容纳字符的宽度
    style.tailIndent = 0.0f;
    NSDictionary *dict = @{NSFontAttributeName : font,
                           NSParagraphStyleAttributeName : style,
                           NSKernAttributeName : textlengthSpace,
                           };
    return dict;
}


+ (CGFloat)getSpaceLabelHeight:(NSString *)string
                      textSize:(CGSize)textSize
             withLineBreakMode:(NSLineBreakMode)lineBreakMode
                 withAlignment:(NSTextAlignment)alignment
                      withFont:(UIFont *)font
                 withLineSpace:(CGFloat)lineSpace
           withTextlengthSpace:(NSNumber *)textlengthSpace
          andParagraphSpaceing:(CGFloat)paragraphSpacing {
    
    if (kStringIsEmpty(string)) {
        return 0;
    }
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = lineBreakMode;
    style.alignment = alignment;
    style.lineSpacing = lineSpace;
    style.paragraphSpacing = paragraphSpacing;
    style.hyphenationFactor = 1.0;
    style.firstLineHeadIndent = 30.0;
    style.paragraphSpacingBefore = 0.0;
    style.headIndent = 0;
    style.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font,
                          NSParagraphStyleAttributeName:style,
                          NSKernAttributeName:textlengthSpace
                          };
    CGSize size = [string boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}


#pragma mark -
#pragma mark --- 图片链接转换 ---

+ (NSArray *)separateImageurl:(NSString *)imageurl accordingTo:(NSString *)boundary {
    
    if (kStringIsEmpty(imageurl)) {
        return [NSArray array];
    }
    
    NSArray <NSString *>*array = [imageurl componentsSeparatedByString:boundary];
    
    NSMutableArray *mutableArr = [NSMutableArray array];
    
    for (NSString *url in array) {
        
        if (!kStringIsEmpty(url)) {
            
            NSString *transformurl = [CommonClass transformImageurlPrefixAccordingTo:url];
            [mutableArr addObject:transformurl];
        }
    }
    
    return [mutableArr copy];
}


//+ (NSString *)transformImageurlPrefixAccordingTo:(NSString *)url {
//    
//    if ([url hasPrefix:@"|"]) {
//        
//        return [[[url mutableCopy] stringByReplacingOccurrencesOfString:@"|" withString:DoDao_Prefix] copy];
//    } else {
//        
//        return [NSString stringWithFormat:@"%@%@",DoDao_Prefix,url];
//    }
//}
//
//+ (NSString *)transformAudioUrlPrefixAccordingTo:(NSString *)url {
//    if ([url hasPrefix:@"|"]) {
//        
//        return [[[url mutableCopy] stringByReplacingOccurrencesOfString:@"|" withString:DoDao_P] copy];
//    } else {
//        
//        return [NSString stringWithFormat:@"%@%@",DoDao_P,url];
//    }
//}

#pragma mark -
#pragma mark  --- 压缩图片质量 ---

+ (UIImage *)reduceImage:(UIImage *)image percent:(float)percent {
    
    NSData *imageData = UIImageJPEGRepresentation(image, percent);
    UIImage *newImage = [UIImage imageWithData:imageData];
    return newImage;
}


+ (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth {
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth, targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


+ (UIImage *)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize {
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (NSString *)getTheCurrentTime {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *dateTime = [formatter stringFromDate:date];
    return dateTime;
}


#pragma mark -
#pragma mark --- 判断输入的全是空格 ---

/** 判断输入的是否全是空格 */
+ (BOOL)isEmpty:(NSString *)str {
    
    if (!str) {
        return YES;
    }
    else {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        if ([trimedString length] == 0) {
            return YES;
        } else {
            return NO;
        }
    }
}


#pragma mark -
#pragma mark --- LoadMessage ---

+ (void)loadMessage:(NSString *)string
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:string delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    });
}


#pragma mark -
#pragma mark --- 获取字符串，汉字首字母 ---

+ (NSString *)firstCharactorWithString:(NSString *)string {
    
    NSMutableString *str = [NSMutableString stringWithString:string];
    CFStringTransform((CFMutableStringRef) str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    NSString *pinYin = [str capitalizedString];
    return [pinYin substringToIndex:1];
}


#pragma mark -
#pragma mark --- 检测字符串 ---

/**
 检测字符串，如果是null，做处理，防止crash
 
 @param string 传入的字符串
 @return 检测后的字符串
 */
+ (NSString *)estimateStringIsEmpty:(NSString *)string {
    
    NSString *estimateString = kStringIsEmpty(string) ? @"" : string;
    return estimateString;
}


#pragma mark -
#pragma mark --- 时间转换 ---

/**
 时间转换
 
 @param string 输入时间字符串 格式："yyyy-MM-dd HH:mm:ss"
 @return 输出转换后的时间格式
 */
+ (NSString *)format:(NSString *)string {
    
    //    // 输入格式 "xxxx年x月xx日 xx时xx分xx秒"，需要多一步格式转换
    //    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
    //    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] ];
    //    [inputFormatter setDateFormat:@"yyyy年MM月dd日 HH时mm分ss秒"];
    //    NSDate*inputDate = [inputFormatter dateFromString:string];
    //
    //    NSDateFormatter *outputFormatter= [[NSDateFormatter alloc] init];
    //    [outputFormatter setLocale:[NSLocale currentLocale]];
    //    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //
    //    // get date str
    //    NSString *str= [outputFormatter stringFromDate:inputDate];
    //    // str to nsdate
    //    NSDate *strDate = [outputFormatter dateFromString:str];
    //
    //    // 修正8小时的差时
    //    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    //    NSInteger interval = [zone secondsFromGMTForDate: strDate];
    //    NSDate *endDate = [strDate dateByAddingTimeInterval: interval];
    //    NSString *lastTime = [self compareDate:endDate and:string];
    //    NSLog(@"lastTime = %@",lastTime);
    //
    //    return lastTime;
    
    // 输入格式"yyyy-MM-dd HH:mm:ss"，不需要转换
    NSDateFormatter *outputFormatter= [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *strDate = [outputFormatter dateFromString:string];
    
    // 修正8小时的差时
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: strDate];
    NSDate *endDate = [strDate dateByAddingTimeInterval: interval];
    NSString *lastTime = [self compareDate:endDate andDateString:string];
    
    return lastTime;
}


/**
 时间比较
 
 @param date 时间Date
 @param string 时间字符串
 @return 整理后的时间
 */
+ (NSString *)compareDate:(NSDate *)date
            andDateString:(NSString *)string {
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    
    // 修正8小时之差
    NSDate *date1 = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date1];
    NSDate *localeDate = [date1  dateByAddingTimeInterval: interval];
    
    NSDate *today = localeDate;
    NSDate *yesterday,*beforeOfYesterday;
    // 今年
    NSString *toYears;
    toYears = [[today description] substringToIndex:4];
    
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    beforeOfYesterday = [yesterday dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString *todayString = [[today description] substringToIndex:10];
    NSString *yesterdayString = [[yesterday description] substringToIndex:10];
    NSString *beforeOfYesterdayString = [[beforeOfYesterday description] substringToIndex:10];
    
    NSString *dateString = [[date description] substringToIndex:10];
    NSString *dateYears = [[date description] substringToIndex:4];
    
    NSString *dateContent;
    
    if ([dateYears isEqualToString:toYears]) {  //同一年
        
        // 今、昨、前天的时间
        NSString *time = [[date description] substringWithRange:(NSRange){11,5}];
        
        // 其他时间
        // 输入格式
        NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
        [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] ];
        [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate*inputDate = [inputFormatter dateFromString:string];
        
        // 输出格式
        NSDateFormatter *outputFormatter= [[NSDateFormatter alloc] init];
        [outputFormatter setLocale:[NSLocale currentLocale]];
        [outputFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
        
        //get date str
        NSString *str= [outputFormatter stringFromDate:inputDate];
        NSString *time2 = [str substringWithRange:(NSRange){5,12}];
        
        if ([dateString isEqualToString:todayString]) {
            dateContent = [NSString stringWithFormat:@"今天 %@",time];
            return dateContent;
        }
        else if ([dateString isEqualToString:yesterdayString]){
            dateContent = [NSString stringWithFormat:@"昨天 %@",time];
            return dateContent;
        }
        else if ([dateString isEqualToString:beforeOfYesterdayString]){
            dateContent = [NSString stringWithFormat:@"前天 %@",time];
            return dateContent;
        }
        else {
            return time2;
        }
    }
    else {
        return dateString;
    }
}




@end
