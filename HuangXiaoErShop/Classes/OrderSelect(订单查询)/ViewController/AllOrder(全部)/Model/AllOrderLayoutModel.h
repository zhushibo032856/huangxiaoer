//
//  AllOrderLayoutModel.h
//  HXEshop
//
//  Created by apple on 2018/4/28.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CellModel.h"

@interface AllOrderLayoutModel : NSObject

@property (nonatomic, assign) CGFloat cellHei;
- (void)getCellHitghtWithCellModel:(CellModel *)model;

@end
