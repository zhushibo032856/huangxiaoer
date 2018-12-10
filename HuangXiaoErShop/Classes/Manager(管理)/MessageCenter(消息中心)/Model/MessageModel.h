//
//  MessageModel.h
//  HuangXiaoErShop
//
//  Created by apple on 2018/12/4.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *sendTime;
@property (nonatomic, strong) NSString *id;

// 该Model对应的Cell高度
@property (nonatomic, assign) CGFloat cellHeight;

@end
