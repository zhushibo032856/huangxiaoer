//
//  UuidObject.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/12/18.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "UuidObject.h"
#import "KeyChainStore.h"

@implementation UuidObject

+(NSString *)getUUID
{
    NSString * strUUID = (NSString *)[KeyChainStore load:@"com.cloud.app"];
    
    //首次执行该方法时，uuid为空
            if ([strUUID isEqualToString:@""] || !strUUID)
        
    {
        
        //生成一个uuid的方法
        
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        
        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
        
        //将该uuid保存到keychain
        
        [KeyChainStore save:KEY_USERNAME_PASSWORD data:strUUID];
        
    }
    
    return strUUID;
}

@end
