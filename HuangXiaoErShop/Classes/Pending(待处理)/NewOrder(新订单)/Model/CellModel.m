//
//  CellModel.m
//  HXEshop
//
//  Created by apple on 2018/3/8.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "CellModel.h"

@implementation OrderCaiModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end

@implementation CellModel

- (NSMutableArray *)arr {
    if (!_arr) {
        self.arr = [NSMutableArray arrayWithCapacity:0];
    }
    return _arr;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"ordersProducts"]) {
        NSArray *arr = value;
        for (NSDictionary *xd in arr) {
            OrderCaiModel *model = [OrderCaiModel new];
            [model setValuesForKeysWithDictionary:xd];
            [self.arr addObject:model];
        }
    }
    
    if ([key isEqualToString:@"id"]) {
        self.order_id  = value;
    }
}

@end
