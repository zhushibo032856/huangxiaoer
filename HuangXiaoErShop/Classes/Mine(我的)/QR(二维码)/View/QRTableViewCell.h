//
//  QRTableViewCell.h
//  HuangXiaoErShop
//
//  Created by apple on 2019/1/21.
//  Copyright © 2019年 aladdin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QRTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *NumberLable;
- (void)setDataForCellWithModel:(QRModel *)model;

@end

NS_ASSUME_NONNULL_END
