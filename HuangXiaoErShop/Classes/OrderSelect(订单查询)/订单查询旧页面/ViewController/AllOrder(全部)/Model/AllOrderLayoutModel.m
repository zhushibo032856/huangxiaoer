//
//  AllOrderLayoutModel.m
//  HXEshop
//
//  Created by apple on 2018/4/28.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "AllOrderLayoutModel.h"

@implementation AllOrderLayoutModel

- (void)getCellHitghtWithCellModel:(CellModel *)model;{
    
    self.cellHei = 30 * model.arr.count + 130;
}
@end
