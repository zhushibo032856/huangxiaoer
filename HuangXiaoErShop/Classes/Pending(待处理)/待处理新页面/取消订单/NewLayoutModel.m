//
//  NewLayoutModel.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/12/17.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "NewLayoutModel.h"

@implementation NewLayoutModel

- (void)getCellHitghtWithCellModel:(CellModel *)model;{
    CGFloat nodataHei = 45 + 40 + 70;
    self.cellHei = nodataHei + 30 * model.arr.count;
}

@end
