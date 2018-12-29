//
//  MemberModel.h
//  HuangXiaoErShop
//
//  Created by apple on 2018/12/25.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemberModel : NSObject

@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *orderCount;
@property (nonatomic, assign) NSInteger newCustomerCount;
@property (nonatomic, assign) NSInteger customerCount;

@end
