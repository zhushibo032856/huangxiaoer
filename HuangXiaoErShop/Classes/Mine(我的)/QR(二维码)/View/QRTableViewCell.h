//
//  QRTableViewCell.h
//  HuangXiaoErShop
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QRModel;

@interface QRTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *machImageView;
@property (nonatomic, strong) UILabel *nameLable;
@property (nonatomic, strong) UILabel *numLable;

- (void)setDataForCellWithModel:(QRModel *)model;

@end
