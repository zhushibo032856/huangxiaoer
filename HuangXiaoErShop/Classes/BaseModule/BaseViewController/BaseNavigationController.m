//
//  BaseNavigationController.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/8/2.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"backcolor"] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
 //   [[UINavigationBar appearance] setBackgroundColor:kColor(0, 0, 0)];
    [[UINavigationBar appearance] setShadowImage:[UIImage imageNamed:@"clearImage"]];
    // Do any additional setup after loading the view.
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
