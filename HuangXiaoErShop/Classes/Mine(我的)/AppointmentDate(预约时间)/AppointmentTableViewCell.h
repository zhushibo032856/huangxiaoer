//
//  AppointmentTableViewCell.h
//  HuangXiaoErShop
//
//  Created by apple on 2018/10/22.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^EditBlock)(NSInteger index,NSInteger buttonTag);

@interface AppointmentTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton *delButton;
@property (nonatomic, strong) UIButton *editButton;

@property (nonatomic, strong) UILabel *timeLable;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) EditBlock block;

@end
