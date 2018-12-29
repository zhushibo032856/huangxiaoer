//
//  UserReviewModel.h
//  HXEshop
//
//  Created by apple on 2018/3/5.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserReviewModel : NSObject

@property (nonatomic, copy) NSString *userImage;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *shopscore;
@property (nonatomic, copy) NSString *sumscore;
@property (nonatomic, copy) NSString *productscore;
@property (nonatomic, copy) NSString *shopReply;
@property (nonatomic, copy) NSString *id;

@end
