//
//  MBProgressHUD+JDLHUD.h
//  JdlFreight
//
//  Created by HYY on 16/10/26.
//  Copyright © 2016年 JDLiOS. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (JDLHUD)

/**  */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
/**  */
+ (void)showError:(NSString *)error toView:(UIView *)view;
/**  */
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;
/**  */
+ (void)showSuccess:(NSString *)success;
/**  */
+ (void)showError:(NSString *)error;
/**  */
+ (MBProgressHUD *)showMessage:(NSString *)message;
/**  */
+ (void)hideHUDForView:(UIView *)view;
/**  */
+ (void)hideHUD;

@end
