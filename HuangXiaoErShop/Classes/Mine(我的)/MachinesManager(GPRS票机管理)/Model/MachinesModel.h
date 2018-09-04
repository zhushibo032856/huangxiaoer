//
//  MachinesModel.h
//  HuangXiaoErShop
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MachinesModel : NSObject

@property (nonatomic, strong) NSString *deviceNo;//打印机编号
@property (nonatomic, strong) NSString *name;//打印机名字
@property (nonatomic, assign) NSInteger status;//状态
@property (nonatomic, strong) NSString *type;//打印机类型
@property (nonatomic, strong) NSString *memberCode;//商家编号
@property (nonatomic, strong) NSString *printersStatus;//离线 \\在线状态
@property (nonatomic, strong) NSString *brand;

@end
