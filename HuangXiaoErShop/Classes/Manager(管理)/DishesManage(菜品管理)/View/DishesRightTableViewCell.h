//
//  DishesRightTableViewCell.h
//  HXEshop
//
//  Created by apple on 2018/3/2.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RightDataModel;

typedef void(^RightBlock)(NSInteger index,NSInteger buttonTag);

@interface DishesRightTableViewCell : UITableViewCell

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong)UIImageView *foodImageView;
@property (nonatomic, strong)UILabel *foodNameLable;
@property (nonatomic, strong)UILabel *priceImageLable;
@property (nonatomic, strong)UILabel *priceLable;
@property (nonatomic, strong)UILabel *activityPrice;

@property (nonatomic, strong)UIButton *editorButton;//编辑按钮
@property (nonatomic, strong)UIButton *undercarriageButton;//下架按钮
@property (nonatomic, strong)UIButton *underButton;//上架按钮

@property (nonatomic, strong) RightDataModel *model;

@property (nonatomic, copy) RightBlock block;

- (void)cellViewsValueWithModel:(RightDataModel *)model;

@end

