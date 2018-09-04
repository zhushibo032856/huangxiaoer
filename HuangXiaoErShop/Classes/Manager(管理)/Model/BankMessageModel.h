//
//  BankMessageModel.h
//  HuangXiaoErShop
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BankMessageModel : NSObject

@property (nonatomic, strong) NSString *accountType;
@property (nonatomic, strong) NSString *openBank;
@property (nonatomic, strong) NSString *settlementAccountName;
@property (nonatomic, strong) NSString *settlementAccount;
@property (nonatomic, strong) NSString *subBranch;

@end
