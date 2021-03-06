//
//  XPageView.h
//  PageViewDemo
//  https://github.com/MrLSPBoy/PageViewController
//  Created by Object on 17/7/11.
//  Copyright © 2017年 Object. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSPTitleStyle.h"
#import "LSPTitleView.h"
#import "LSPContentView.h"
@interface LSPPageView : UIView

/**
 直接在需要PageView的控制器中，一句代码实例化(调用此方法),如需更改TitleView和ContentView的Frame在XTitleStyle.m中重新设置Frame即可

 @param frame PageView的Frame
 @param titles 标题数组
 @param style 设置PageView的多个属性
 @param childVcs 子控制器数组
 @param parentVc 父控制器
 @return pageView
 */
- (LSPPageView *)initWithFrame:(CGRect)frame titles:(NSArray <NSString *>*)titles style:(LSPTitleStyle *)style childVcs:(NSArray <UIViewController *>*)childVcs parentVc:(UIViewController *)parentVc;

@end
