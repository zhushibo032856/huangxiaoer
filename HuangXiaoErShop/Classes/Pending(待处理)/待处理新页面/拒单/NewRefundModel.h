//
//  NewRefundModel.h
//  HuangXiaoErShop
//
//  Created by apple on 2018/12/17.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CellModel.h"

@interface NewRefundModel : NSObject

@property (nonatomic, assign) CGFloat cellHei;
- (void)getCellHitghtWithCellModel:(CellModel *)model;

@end
