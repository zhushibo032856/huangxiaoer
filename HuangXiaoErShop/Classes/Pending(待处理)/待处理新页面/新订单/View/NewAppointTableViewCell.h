//
//  NewAppointTableViewCell.h
//  HuangXiaoErShop
//
//  Created by apple on 2018/12/19.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellModel.h"

typedef void(^JieDanBlock)(NSInteger index, NSInteger btnTag);

@interface NewAppointTableViewCell : UITableViewCell
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) JieDanBlock block;
@property (weak, nonatomic) IBOutlet UIImageView *TypeImage;
@property (weak, nonatomic) IBOutlet UILabel *takeNumLable;
@property (weak, nonatomic) IBOutlet UILabel *OrderTypeLable;
@property (weak, nonatomic) IBOutlet UILabel *UseDateLable;
@property (weak, nonatomic) IBOutlet UIView *addView;
@property (weak, nonatomic) IBOutlet UILabel *BeizhuLable;
@property (weak, nonatomic) IBOutlet UIButton *PrinterButton;
@property (weak, nonatomic) IBOutlet UIButton *JvDanButton;
@property (weak, nonatomic) IBOutlet UIButton *JieDanButton;
@property (weak, nonatomic) IBOutlet UIButton *JiaoHaoButton;

- (void)cellViewsValueWithModel:(CellModel *)model;

@end
