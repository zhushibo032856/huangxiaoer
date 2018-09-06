//
//  AppDelegate.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/7/30.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseTabBarController.h"
#import <AVFoundation/AVFoundation.h>
#import <UserNotifications/UserNotifications.h>

#import <Bugly/Bugly.h>


@interface AppDelegate ()<UIApplicationDelegate,UNUserNotificationCenterDelegate>

@property (strong, nonatomic)AVPlayer *myPlayer;//播放器
@property (strong, nonatomic)AVPlayerItem *item;//播放单元

@end

@implementation AppDelegate

//xcrun atos -arch arm64 -o HuangXiaoErShop.app/HuangXiaoErShop 0x100114000
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    
    [Bugly startWithAppId:@"db2d271985"];
    
    
    if(kStringIsEmpty(KUSERID)) {
        
        [self showLoginView];
    }else{
        [self showHomeView];
    }
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil]];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    
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
        //  [self playAutoVoice];
    }else if(application.applicationState == UIApplicationStateBackground){

        //其他两种情况，一种在后台程序没有被杀死，另一种是在程序已经杀死。用户点击推送的消息进入app的情况处理。
        //    NSLog(@"应用程序在后台");

    }else{
        //   NSLog(@"用用程序处于关闭状态");
    }
    completionHandler(UIBackgroundFetchResultNewData);
}
- (void)playVoice{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];

    NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"dd" ofType:@"mp3"];
    NSURL *audioUrl = [NSURL fileURLWithPath:audioPath];
    _myPlayer = [[AVPlayer alloc]initWithURL:audioUrl];
    if (_myPlayer == NULL)
    {
        return;
    }
    [_myPlayer setVolume:1];
    [_myPlayer play];
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
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
