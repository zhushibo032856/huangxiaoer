//
//  XJWTextView.h
//  HuangXiaoErShop
//
//  Created by apple on 2018/12/27.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^XBTextViewBlcok)(NSString *text);
@interface XJWTextView : UIView
/* 唤醒 */
@property (nonatomic,strong) UITextView *textView;
/* 发送文本 */
@property (nonatomic,copy) XBTextViewBlcok TextBlcok;
/* 设置占位符 */
-(void)setPlaceholderText:(NSString *)text;

@end
