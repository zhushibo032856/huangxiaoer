//
//  MessageTwoTableViewCell.h
//  HuangXiaoErShop
//
//  Created by apple on 2018/12/4.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

@interface MessageTwoTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UILabel *contentLable;
@property (nonatomic, strong) UILabel *timeLable;

- (void)setMessageWith:(MessageModel *)model;

@end
