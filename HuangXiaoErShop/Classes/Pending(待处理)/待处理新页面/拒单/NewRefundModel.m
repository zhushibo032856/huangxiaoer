//
//  NewRefundModel.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/12/17.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "NewRefundModel.h"

@implementation NewRefundModel
- (void)getCellHitghtWithCellModel:(CellModel *)model;{
    CGFloat nodataHei = 45 + 40 + 60;
    self.cellHei = nodataHei + 30 * model.arr.count;
}
@end
