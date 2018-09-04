//
//  CommonClass.h
//  设置label行间距
//
//  Created by zaowuzhe12 on 2017/8/24.
//  Copyright © 2017年 HYY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CommonClass : NSObject

#pragma mark -
#pragma mark --- 计算高度 ---

/**
 计算label高度
 
 @param string 文字
 @param font 字体描述
 @param size 控件大小,高度设置为0
 @return 计算出文字的高度
 */
+ (CGFloat)calculateHeightWithText:(NSString *)string
                          withFont:(UIFont *)font
                       andTextSize:(CGSize)size;


/**
 带lineBreakMode的计算高度
 
 @param lineBreakMode 每行容纳字符的宽度
 @param string 文字
 @param font 字体描述
 @param size 控件大小,高度设置为0
 @return 计算出的文字高度
 */
+ (CGFloat)calculateHeightWithLineBreakMode:(NSLineBreakMode)lineBreakMode
                                   withText:(NSString *)string
                                   withFont:(UIFont *)font
                                andTextSize:(CGSize)size;


/**
 设置label AttributedText 字体, 行间距, 字间距, 段间距
 
 @param string label上文字
 @param lineBreakMode 每行容纳字符的宽度
 @param alignment 对齐方式
 @param font 字体大小
 @param lineSpace 行间距
 @param textlengthSpace 字间距
 @param paragraphSpacing 段间距
 @return 存放属性的字典
 
 eg. 
 NSString *text = @"突然想要写点什么，来纪念自己即将逝去的大学四年时光，借机过度一下自己此时此刻莫可名状的心情；\n突然想要说点什么，来缅怀一下自己当初万丈豪情遗失的时光和所谓的青春年华。\n不知道是骨子里的性情使然，\n还是内心深处想要特意地煽情?";
 
 UIFont *font = [UIFont systemFontOfSize:14.f];
 CGFloat lineSpace = 5.f;
 CGFloat paragraphSpacing = 10.f;
 CGSize labelSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, 0);
 NSNumber *textLengthSpace = @1.5;
 
 NSDictionary *dict = [CommonClass setTextLineSpaceWithString:text withLineBreakMode:(NSLineBreakByCharWrapping) withAlignment:NSTextAlignmentLeft withFont:font withLineSpace:lineSpace withTextlengthSpace:textLengthSpace andParagraphSpaceing:paragraphSpacing];
 
 CGFloat height = [CommonClass getSpaceLabelHeight:text textSize:labelSize withLineBreakMode:(NSLineBreakByCharWrapping) withAlignment:(NSTextAlignmentLeft) withFont:font withLineSpace:lineSpace withTextlengthSpace:textLengthSpace andParagraphSpaceing:paragraphSpacing];
 
 UILabel *label = [[UILabel alloc] init];
 label.numberOfLines = 0;
 label.backgroundColor = [UIColor cyanColor];
 label.frame = CGRectMake(10, 50, labelSize.width, height);
 label.attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:dict];
 */
+ (NSDictionary *)setTextLineSpaceWithString:(NSString *)string
                           withLineBreakMode:(NSLineBreakMode)lineBreakMode withAlignment:(NSTextAlignment)alignment
                                    withFont:(UIFont *)font
                               withLineSpace:(CGFloat)lineSpace
                         withTextlengthSpace:(NSNumber *)textlengthSpace
                        andParagraphSpaceing:(CGFloat)paragraphSpacing;


/**
 计算label AttributedText 高度
 
 @param string label展示的文字
 @param textSize label的size,高度设置为0
 @param lineBreakMode 每行容纳字符的宽度
 @param alignment 对齐方式
 @param font 字体描述
 @param lineSpace 行间距
 @param textlengthSpace 字间距
 @param paragraphSpacing 段间距
 @return 计算出来的高度
 */
+ (CGFloat)getSpaceLabelHeight:(NSString *)string
                      textSize:(CGSize)textSize
             withLineBreakMode:(NSLineBreakMode)lineBreakMode
                 withAlignment:(NSTextAlignment)alignment
                      withFont:(UIFont *)font
                 withLineSpace:(CGFloat)lineSpace
           withTextlengthSpace:(NSNumber *)textlengthSpace
          andParagraphSpaceing:(CGFloat)paragraphSpacing;



#pragma mark -
#pragma mark --- 图片链接转换 ---

/**
 分割图片链接

 @param imageurl 原始图片链接
 @param boundary 分割依据
 @return 分割，转换后的图片链接数组
 */
+ (NSArray *)separateImageurl:(NSString *)imageurl accordingTo:(NSString *)boundary;


/**
 将图片链接前缀"|"转换为网址前缀

 @param url 原始的图片链接
 @return 转换后的图片链接
 */
+ (NSString *)transformImageurlPrefixAccordingTo:(NSString *)url;

/**
 将录音链接前缀"|"转换为网址前缀

 @param url 原始含|的链接
 @return 转换后带ip的链接
 */
+ (NSString *)transformAudioUrlPrefixAccordingTo:(NSString *)url;

#pragma mark -
#pragma mark  --- 压缩图片质量 ---

+ (UIImage *)reduceImage:(UIImage *)image percent:(float)percent;

+ (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;

+ (UIImage *)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;

+ (NSString *)getTheCurrentTime;


#pragma mark -
#pragma mark --- 判断输入的全是空格 ---

/** 判断输入的是否全是空格 */
+ (BOOL)isEmpty:(NSString *)str;



#pragma mark -
#pragma mark --- LoadMessage ---

+ (void)loadMessage:(NSString *)string;



#pragma mark -
#pragma mark --- 获取字符串，汉字首字母 ---

+ (NSString *)firstCharactorWithString:(NSString *)string;


#pragma mark -
#pragma mark --- 检测字符串 ---

/**
 检测字符串，如果是null，做处理，防止crash
 
 @param string 传入的字符串
 @return 检测后的字符串
 */
+ (NSString *)estimateStringIsEmpty:(NSString *)string;



#pragma mark -
#pragma mark --- 时间转换 ---

/**
 时间转换
 
 @param string 输入时间字符串 格式："yyyy-MM-dd HH:mm:ss"
 @return 输出转换后的时间格式
 */
+ (NSString *)format:(NSString *)string;


/**
 时间比较
 
 @param date 时间Date
 @param string 时间字符串
 @return 整理后的时间
 */
+ (NSString *)compareDate:(NSDate *)date
            andDateString:(NSString *)string;




@end
