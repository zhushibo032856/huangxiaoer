//
//  MyBlueViewController.h
//  HuangXiaoErShop
//
//  Created by apple on 2018/11/14.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^blueNameBlock)(CBPeripheral *peripheral);

@interface MyBlueViewController : UIViewController

@property(nonatomic,copy)ConnectDeviceState state;
@property(nonatomic, strong) CBPeripheral *peripheral;

@property (nonatomic, strong) blueNameBlock block;

@end
