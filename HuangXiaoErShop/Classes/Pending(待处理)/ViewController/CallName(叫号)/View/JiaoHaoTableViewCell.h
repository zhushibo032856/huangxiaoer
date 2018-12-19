//
//  JiaoHaoTableViewCell.h
//  HXEshop
//
//  Created by apple on 2018/3/12.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellModel.h"

@interface JiaoHaoTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *xunxuLable;
@property (nonatomic, strong) UIImageView *timeImageView;
@property (nonatomic, strong) UILabel *comeTimeLable;
@property (nonatomic, strong) UIImageView *jiaohaoImageView;
@property (nonatomic, strong) UIButton *jiaohaoButton;

- (void)cellGetDataWithModel: (CellModel *)model;

@end
