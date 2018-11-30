//
//  RightDataModel.h
//  HXEshop
//
//  Created by apple on 2018/3/4.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RightDataModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sellPrice;
@property (nonatomic, copy) NSString *activityPrice;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *packFee;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString *tb_category_categoryId;
@end
