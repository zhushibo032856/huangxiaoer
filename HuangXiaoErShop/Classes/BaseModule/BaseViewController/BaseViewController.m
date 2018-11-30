//
//  BaseViewController.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/7/31.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
 //   [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notifi:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    // Do any additional setup after loading the view.
}
- (void)notifi:(NSNotification *)noti{
    NSLog(@"***s%@",noti.userInfo);
    NSDictionary *dic = noti.userInfo;
    NSInteger status = [dic[@"AFNetworkingReachabilityNotificationStatusItem"] integerValue];
    switch (status) {
        case 2:
            [MBProgressHUD showError:@"wif网络"];
            [self setNoNetwork];
            break;
        case 1:
            [MBProgressHUD showError:@"移动网络"];
            break;
        case 0:
            [MBProgressHUD showError:@"无网络"];
            
            
            
            break;
        case -1:
            [MBProgressHUD showError:@"未知网络"];
            break;
            
        default:
            break;
    }
    
}

- (void)setNoNetwork{
    
    self.view.backgroundColor = [UIColor cyanColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
