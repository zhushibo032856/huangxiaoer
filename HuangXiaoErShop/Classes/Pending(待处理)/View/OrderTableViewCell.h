//
//  OrderTableViewCell.h
//  HuangXiaoErShop
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderModel;

@interface OrderTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *reorderLable;//订单序号
@property (nonatomic, strong) UIImageView *clockImage;//闹钟图片
@property (nonatomic, strong) UILabel *timeLable;//到店时间
@property (nonatomic, strong) UIButton *orderTakingButton;//接单

@end
