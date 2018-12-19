//
//  OrderLayoutModel.m
//  HXEshop
//
//  Created by apple on 2018/3/10.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "OrderLayoutModel.h"

@implementation OrderLayoutModel


- (void)getCellHitghtWithCellModel:(CellModel *)model;{
    
    CGFloat nodataHei = 40 + 30 + 60;
    if ([model.orderType isEqualToString:@"APPOINTMENT"] ||[model.orderType isEqualToString:@"SECKILL"]) {
        self.cellHei = nodataHei + 30 * model.arr.count + 10 + 40;
    }else{
    self.cellHei = nodataHei + 30 * model.arr.count + 10;
    }
}

@end
