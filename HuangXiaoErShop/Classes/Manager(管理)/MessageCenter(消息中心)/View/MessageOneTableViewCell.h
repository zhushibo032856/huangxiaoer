//
//  MessageOneTableViewCell.h
//  HuangXiaoErShop
//
//  Created by apple on 2018/12/4.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

@interface MessageOneTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *typeImage;
@property (nonatomic, strong) UILabel *messageType;
@property (nonatomic, strong) UILabel *typeLable;
@property (nonatomic, strong) UILabel *timeLable;
@property (nonatomic, strong) UILabel *contentLable;
@property (nonatomic, strong) UILabel *detaillable;

@property (nonatomic, strong) UIImageView *detailImage;

- (void)setDataForCellWith:(MessageModel *)model;

@end
