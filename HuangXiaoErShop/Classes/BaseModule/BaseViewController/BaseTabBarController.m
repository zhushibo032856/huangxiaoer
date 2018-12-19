//
//  BaseTabBarController.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/7/31.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "BaseTabBarController.h"
#import "BaseNavigationController.h"
#import "PendingViewController.h"
#import "OrderSelectViewController.h"
#import "ManageViewController.h"
#import "MineViewController.h"
#import "NewPendingViewController.h"

@interface BaseTabBarController ()<UITabBarControllerDelegate>

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    
    [self setColor];
    
    [self addChildViewControllers];
    // Do any additional setup after loading the view.
}

- (void)setColor {
    
    
    
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    
    // delete Top Line
    UIImage * tabBarShadow = [UIImage imageNamed:@"clear"];
    [[UITabBar appearance] setShadowImage:tabBarShadow];
    [[UITabBar appearance] setBackgroundImage:tabBarShadow];
}

/** Add tabBarControllers */
- (void)addChildViewControllers {
    
//    PendingViewController *pendingVC = [PendingViewController new];
//    [self addChildViewController:pendingVC image:@"pending" selectedImage:@"pending2" title:@"待处理"];
    
    NewPendingViewController *newPendingVC = [NewPendingViewController new];
    [self addChildViewController:newPendingVC image:@"pending" selectedImage:@"pending2" title:@"待处理"];
    
    OrderSelectViewController *orderSelectVC = [OrderSelectViewController new];
    [self addChildViewController:orderSelectVC image:@"orderselect" selectedImage:@"orderselect1" title:@"订单查询"];
    
    ManageViewController *managerVC = [ManageViewController new];
    [self addChildViewController:managerVC image:@"manager" selectedImage:@"manager2" title:@"管理"];
    
    MineViewController *mineVC = [MineViewController new];
    [self addChildViewController:mineVC image:@"mine" selectedImage:@"mine2" title:@"设置"];
    
}
/**
 * 添加子控制器
 * @param childController 子控制器
 * @param imageName tabBarItem正常状态图片
 * @param selectedImageName tabBarItem选中状态图片
 * @param title 标题
 */
- (void)addChildViewController:(UIViewController *)childController image:(NSString *)imageName selectedImage:(NSString *)selectedImageName title:(NSString *)title {
    
    BaseNavigationController *navigationVC = [[BaseNavigationController alloc] initWithRootViewController:childController];
    
    childController.title = title;
    
    childController.view.backgroundColor = [UIColor whiteColor];
    
    childController.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    childController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //
    // childController.tabBarItem.imageInsets = UIEdgeInsetsMake(1.7f, 0.f, 1.5f, 0.f);
    [childController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0.5f, -4.3f)];
    
    // Normarl
    NSMutableDictionary *normalText = [NSMutableDictionary dictionary];
    normalText[NSForegroundColorAttributeName] = kColor(204, 204, 204);
    [childController.tabBarItem setTitleTextAttributes:normalText forState:UIControlStateNormal];
    
    // Selected
    NSMutableDictionary *selectedText = [NSMutableDictionary dictionary];
    selectedText[NSForegroundColorAttributeName] = kColor(255, 210, 0);
    [childController.tabBarItem setTitleTextAttributes:selectedText forState:UIControlStateSelected];
    
    [self addChildViewController:navigationVC];
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
