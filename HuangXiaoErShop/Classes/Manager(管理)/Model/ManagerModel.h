//
//  ManagerModel.h
//  HuangXiaoErShop
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ManagerModel : NSObject

@property (nonatomic, copy) NSString *logoImage;
@property (nonatomic, copy) NSString *shopSign;
@property (nonatomic, assign) NSInteger shopStutas;
@property (nonatomic, copy) NSString *address;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, assign) NSInteger isAuto;
@property (nonatomic, copy) NSString *data3;
@property (nonatomic, copy) NSString *userName;

@end
