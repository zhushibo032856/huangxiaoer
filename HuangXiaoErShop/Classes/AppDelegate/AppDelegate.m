//
//  AppDelegate.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/7/30.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseTabBarController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <UserNotifications/UserNotifications.h>
#import <AVFoundation/AVFoundation.h>
#import <IQKeyboardManager.h>

#import <Bugly/Bugly.h>


@interface AppDelegate ()<UIApplicationDelegate,UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

//xcrun atos -arch arm64 -o HuangXiaoErShop.app/HuangXiaoErShop 0x100114000
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    application.applicationIconBadgeNumber = 0;
    
    [Bugly startWithAppId:@"db2d271985"];
    
    
    if(kStringIsEmpty(KUSERID)) {
        
        [self showLoginView];
    }else{
        [self showHomeView];
    }
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil]];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
//    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
//    manager.enable = YES; // 控制整个功能是否启用。
//    manager.shouldResignOnTouchOutside =YES; // 控制点击背景是否收起键盘
//    manager.shouldToolbarUsesTextFieldTintColor =YES; // 控制键盘上的工具条文字颜色是否用户自定义
//    manager.enableAutoToolbar =YES; // 控制是否显示键盘上的工具条
//    manager.toolbarManageBehaviour =IQAutoToolbarByTag; // 最新版
    
    
    return YES;
}


+ (AppDelegate *)mainAppDelegate{
    return (AppDelegate *) [UIApplication sharedApplication].delegate;
}

- (void)showLoginView{
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    loginVC.view.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = loginVC;
    [self.window makeKeyAndVisible];
    
}
- (void)showHomeView{
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    BaseTabBarController *baseVC = [[BaseTabBarController alloc]init];
    self.window.rootViewController = baseVC;
    [self.window makeKeyAndVisible];
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

    NSString *deviceTokenStr = [[[[deviceToken description]

                                  stringByReplacingOccurrencesOfString:@"<" withString:@""]

                                 stringByReplacingOccurrencesOfString:@">" withString:@""]

                                stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"%@",deviceTokenStr);

    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setValue:deviceTokenStr forKey:@"deviceToken"];
    [user synchronize];

}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    NSLog(@"Failed to get token, error:%@", error_str);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo{
    NSLog(@"******%@",userInfo);
}
//
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary * _Nonnull)userInfo fetchCompletionHandler:(void (^ _Nonnull)(UIBackgroundFetchResult))completionHandler{

    NSLog(@"didReceiveRemoteNotification:%@",userInfo);
//    NSDictionary *extrasDic = userInfo[@"extras"];
    
//    NSLog(@"%@",extrasDic);
//    NSString *shopID = extrasDic[@"shopid"];
//    NSString *customer = extrasDic[@"customerid"];
//    NSString *status = extrasDic[@"status"];
//    NSString *msgData = extrasDic[@"msgData"];
//    //    NSLog(@"%@",status);
//    NSString *userID = [NSString stringWithFormat:@"%@", KUSERSHOPID];
//    if ([userID isEqualToString:shopID]) {
//        if (customer == nil || [customer isEqual: @""]) {
//            if ([status integerValue] == 10000 || [status integerValue] == 10001) {
//                [self playVoice];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"noti1" object:nil];
//            }else if ([status integerValue] == 10005){
//                [self playVoice];
//            }else if ([status integerValue] == 10012){
//                [self playAutoVoice:msgData];
//                //  [self playVoice];
//            }
//        }
//    }

    application.applicationIconBadgeNumber = 0;

    

    /*
     UIApplicationStateActive 应用程序处于前台
     UIApplicationStateBackground 应用程序在后台，用户从通知中心点击消息将程序从后台调至前台
     UIApplicationStateInactive 用用程序处于关闭状态(不在前台也不在后台)，用户通过点击通知中心的消息将客户端从关闭状态调至前台
     */

    //应用程序在前台给一个提示特别消息
    if (application.applicationState == UIApplicationStateActive) {

        //应用程序在前台
         [self playVoice];
        //[self playAutoVoice];
    }else if(application.applicationState == UIApplicationStateBackground){

        //其他两种情况，一种在后台程序没有被杀死，另一种是在程序已经杀死。用户点击推送的消息进入app的情况处理。


    }else{
        //   NSLog(@"用用程序处于关闭状态");

    }
    completionHandler(UIBackgroundFetchResultNewData);
}
- (void)playVoice{

    NSString *path = [[NSBundle mainBundle] pathForResource:@"dd" ofType:@"mp3"];
    //定义一个SystemSoundID
    SystemSoundID soundID;
    //判断路径是否存在
    {
        //创建一个音频文件的播放系统声音服务器
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)([NSURL fileURLWithPath:path]), &soundID);
        //判断是否有错误
        if (error != kAudioServicesNoError) {
            NSLog(@"%d",(int)error);
        }
    }
    //播放声音和振动
    AudioServicesPlayAlertSoundWithCompletion(soundID, ^{
        //播放成功回调
    });
}
- (void)playAutoVoice:(NSString *)msgData{
    //初始化语音播报
    AVSpeechSynthesizer * av = [[AVSpeechSynthesizer alloc]init];
    //设置播报的内容
    NSString *dataString = [NSString stringWithFormat:@"黄小二收款%@元",msgData];
    AVSpeechUtterance * utterance = [[AVSpeechUtterance alloc]initWithString:dataString];
    //设置语言类别
    AVSpeechSynthesisVoice * voiceType = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-TW"];
    utterance.voice = voiceType;
    //设置播报语速
    utterance.rate = 0.5;
    utterance.volume = 1;
    [av speakUtterance:utterance];
}





- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    application.applicationIconBadgeNumber = 0;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
