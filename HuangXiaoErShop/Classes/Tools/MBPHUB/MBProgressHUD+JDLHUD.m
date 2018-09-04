
//
//  MBProgressHUD+JDLHUD.m
//  JdlFreight
//
//  Created by HYY on 16/10/26.
//  Copyright © 2016年 JDLiOS. All rights reserved.
//

#import "MBProgressHUD+JDLHUD.h"

@implementation MBProgressHUD (JDLHUD)
#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    hud.label.font = FontType_Text(15.5f);
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 设置内容颜色
    hud.contentColor = [UIColor whiteColor];
    
    // 设置蒙层颜色
    hud.bezelView.color = [UIColor blackColor];
    
    // 设置遮罩颜色
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1.5秒之后再消失
    [hud hideAnimated:YES afterDelay:1.5f];
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error.png" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    hud.label.font = FontType_Text(15.5f);
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 设置内容颜色
    hud.contentColor = [UIColor whiteColor];
    // 设置蒙层颜色
    hud.bezelView.color = [UIColor blackColor];
    // 设置遮罩颜色
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    return hud;
}

+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

+ (void)hideHUDForView:(UIView *)view
{
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    [self hideHUDForView:nil];
}
@end
