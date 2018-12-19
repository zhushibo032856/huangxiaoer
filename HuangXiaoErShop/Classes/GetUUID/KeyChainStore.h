//
//  KeyChainStore.h
//  HuangXiaoErShop
//
//  Created by apple on 2018/12/18.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainStore : NSObject

+ (void)save:(NSString *)service data:(id)data;

+ (id)load:(NSString *)service;

+ (void)deleteKeyData:(NSString *)service;

@end
