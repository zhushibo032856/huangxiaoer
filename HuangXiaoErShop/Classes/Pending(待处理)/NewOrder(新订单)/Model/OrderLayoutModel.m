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
    
    CGFloat nodataHei = 44 + 30 + 20 + 44 + 20 + 10 + 44 + 60 +2;
    self.cellHei = nodataHei + 30 * model.arr.count + 20 + 10;
    
}

@end
