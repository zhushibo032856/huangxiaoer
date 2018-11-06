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

#import "PostOrderModel.h"

#import <Bugly/Bugly.h>
#import "ConnecterManager.h"

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
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES; // 控制整个功能是否启用。
    manager.shouldResignOnTouchOutside =YES; // 控制点击背景是否收起键盘
    manager.shouldToolbarUsesTextFieldTintColor =YES; // 控制键盘上的工具条文字颜色是否用户自定义
    manager.enableAutoToolbar =YES; // 控制是否显示键盘上的工具条
    manager.toolbarManageBehaviour =IQAutoToolbarByTag; // 最新版
    
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

 //   NSLog(@"didReceiveRemoteNotification:%@",userInfo);
    
    NSDictionary *dataDic = userInfo[@"data"];
    
  //  NSLog(@"%@",dataDic);
  //  NSString *status = dataDic[@"status"];
    
    NSString *orderNum = dataDic[@"orderNum"];
    
    
    if (!kStringIsEmpty(orderNum)) {
        
     [self requestDataWithOrderID:orderNum];
        
    }
    
    
    application.applicationIconBadgeNumber = 0;


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

    NSString *path = [[NSBundle mainBundle] pathForResource:@"dd" ofType:@"caf"];
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
#pragma mark  根据订单号查询订单信息
- (void)requestDataWithOrderID:(NSString *)orderID{
    
    NSDictionary *partner = @{
                              @"orderNum": orderID,
                              @"token": KUSERID
                              };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager POST:@"http://bei.51hxe.com:9007/appordersr/findOrderByOrderNums" parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"status"] integerValue] == 200) {
            
            NSDictionary *dic = responseObject[@"data"];
            NSLog(@"%@",dic);
            BOOL x = [responseObject[@"data"] isKindOfClass:[NSDictionary class]];
            
            if (x == 1) {
                [Manager write:[self escCommandWithOrderDic:dic] progress:^(NSUInteger total, NSUInteger progress) {
                    
                } receCallBack:^(NSData * _Nullable data) {
                    
                }];
            }else{
             //   NSString *data = responseObject[@"data"];
                [MBProgressHUD showError:@"订单数据为空"];
            }
            
            
        }else{
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}
#pragma mark
- (NSData *)escCommandWithOrderDic:(NSDictionary *)dic{
    
    
    EscCommand *command = [[EscCommand alloc]init];
    [command addInitializePrinter];
    
    NSInteger x = [dic[@"isPay"] integerValue];
    
    if (x == 2) {
        [command addPrintAndFeedLines:1];
        [command addPrintMode:0x0];
        [command addText:@"****"];
        
        [command addPrintMode:0x16 | 0x32];
        [command addText:@"  黄小二  "];
        [command addSetJustification:1];
        
        [command addPrintMode:0x0];
        [command addText:@"****\n\n"];
    }else if (x == 1){
        [command addPrintAndFeedLines:1];
        [command addPrintMode:0x16 | 0x32];
        [command addText:@"黄小二【未支付单】\n"];
    }else if(x == 3 || x ==4){
        
        NSString *refuse = dic[@""];
        
        
        
        
        [command addPrintAndFeedLines:1];
        [command addPrintMode:0x16 | 0x32];
        [command addText:@"黄小二【退款单】\n"];
        
        [command addPrintMode:0x0];
        [command addText:@"-------------------------------\n"];
        
        [command addPrintMode:0x16 | 0x32];
        [command addText:[NSString stringWithFormat:@"%@\n",refuse]];
        
        [command addPrintMode:0x0];
        [command addText:@"-------------------------------\n"];
    }
    
    
    NSString *shopSign = dic[@"shopSign"];
    NSString *diningName = dic[@"diningName"];
    [command addPrintMode:0x0];
    [command addText:[NSString stringWithFormat:@"%@(%@)\n",shopSign,diningName]];
    [command addSetJustification:0];
    
    [command addPrintMode:0x0];
    [command addText:@"-------------------------------\n"];
    [command addSetJustification:0];
    
    NSString *takeNum = dic[@"takeNum"];

    [command addText:@"叫号:"];
    [command addPrintMode:0x16 | 0x32];
    [command addText:[NSString stringWithFormat:@"%@\n",takeNum]];
    
    [command addPrintMode:0x0];
    [command addText:@"预约时间:\n"];
    
    NSString *useDate = dic[@"useDate"];
    if (kStringIsEmpty(useDate)) {
        NSLog(@"数据为空");
    }else{
        NSString *dateString = [useDate substringWithRange:NSMakeRange(5, 11)];
        [command addPrintMode:0x16 | 0x32];
        [command addText:[NSString stringWithFormat:@"%@\n",dateString]];
    }
    
    
    [command addPrintMode:0x0];
    [command addText:@"-------------------------------\n"];
    
    NSArray *orderArr = dic[@"goodsList"];
    NSMutableArray *orderDetailArr = [NSMutableArray arrayWithCapacity:0];
    [command addPrintMode:0x16];
    for (NSDictionary *dic in orderArr) {
        PostOrderModel *model = [[PostOrderModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [orderDetailArr addObject:model];
    }
    
    for (int i = 0; i < orderDetailArr.count; i ++) {
        PostOrderModel *model = orderDetailArr[i];
        [command addText:[NSString stringWithFormat:@"%@    X%@\n",model.goodsName,model.goodsNum]];
    }
    
    [command addPrintMode:0x0];
    [command addText:@"-------------------------------\n"];
    
    
    NSString *des = dic[@"des"];
    [command addText:[NSString stringWithFormat:@"备注:%@",des]];
    [command addText:@"\n-------------------------------\n"];
    
    
    NSString *totalFee = dic[@"totalFee"];
    [command addText:[NSString stringWithFormat:@"订单价格:%@元",totalFee]];
    [command addText:@"\n-------------------------------\n"];
    
    NSString *nickName = dic[@"nickName"];
    [command addText:[NSString stringWithFormat:@"%@\n",nickName]];
    
    NSString *phone = dic[@"phone"];
    [command addText:[NSString stringWithFormat:@"%@\n",phone]];
    
    NSString *orderNum = dic[@"orderNum"];
    [command addText:[NSString stringWithFormat:@"订单号:%@\n\n\n\n",orderNum]];
    
    
    return [command getCommand];
    
  

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
