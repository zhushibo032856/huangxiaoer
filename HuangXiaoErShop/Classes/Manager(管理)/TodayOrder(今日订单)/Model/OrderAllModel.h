//
//  OrderAllModel.h
//  HXEshop
//
//  Created by apple on 2018/3/7.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderAllModel : NSObject

@property (nonatomic, copy) NSString *orderNum;
@property (nonatomic, copy) NSString *useDate;
@property (nonatomic, assign) CGFloat realFee;
@property (nonatomic, assign) NSInteger isPay;
@property (nonatomic, assign) NSInteger orderStatus;

@end
