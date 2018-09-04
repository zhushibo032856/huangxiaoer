//
//  CateGoryTableViewCell.h
//  HXEshop
//
//  Created by apple on 2018/3/27.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftDataModel.h"

typedef void(^editBlock)(NSInteger index, NSInteger buttonTag);

@interface CateGoryTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLable;
@property (nonatomic, strong) UIButton *editButton;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) editBlock block;

- (void)cellDataFromModel:(LeftDataModel *)model;

@end
