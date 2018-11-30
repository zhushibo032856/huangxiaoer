//
//  BlueModel.h
//  HuangXiaoErShop
//
//  Created by apple on 2018/11/14.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlueModel : NSObject

@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, strong) ConnectDeviceState state;

@end
