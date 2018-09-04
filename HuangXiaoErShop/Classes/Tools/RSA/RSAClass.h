//
//  RSAClass.h
//  YoungCreators
//
//  Created by QF on 2016/9/22.
//  Copyright © 2016年 zaowuzhe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSAClass : NSObject
+ (RSAClass *)shareRSAWith:(NSString *)string;
@property (nonatomic, copy) NSString *RSAString;
@end
