//
//  CellModel.h
//  HXEshop
//
//  Created by apple on 2018/3/8.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellModel : NSObject

@property (nonatomic, assign) BOOL isShow;

@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *orderStatus;
@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) NSString *realFee;
@property (nonatomic, strong) NSString *totalFee;
@property (nonatomic, strong) NSString *couponsFee;
@property (nonatomic, strong) NSString *isCoupons;
@property (nonatomic, strong) NSString *useDate;
@property (nonatomic, strong) NSString *des;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *orderNum;
@property (nonatomic, strong) NSString *isPay;
@property (nonatomic, strong) NSString *takeNum;
@property (nonatomic, strong) NSString *id;//订单ID
@property (nonatomic, strong) NSString *tb_customer_id;//用户ID
@property (nonatomic, strong) NSString *updateTime;
@property (nonatomic, strong) NSString *orderType;
@property (nonatomic, strong) NSMutableArray *arr;

@end



@interface OrderCaiModel : NSObject
@property (nonatomic, strong) NSString *goodsNum;
@property (nonatomic, strong) NSString *goodsPrice;
@property (nonatomic, strong) NSString *goodsName;

@end
