//
//  JieDanCell.h
//  zhedie
//
//  Created by Apple on 2018/3/4.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellModel.h"

typedef void(^JieDanBlock)(NSInteger index, NSInteger btnTag);


@interface JieDanCell : UITableViewCell

- (void)cellViewsValueWithModel:(CellModel *)model;

@property (nonatomic, assign) NSInteger index;

@property (weak, nonatomic) IBOutlet UILabel *nameLb;

@property (weak, nonatomic) IBOutlet UIView *addView;

@property (weak, nonatomic) IBOutlet UILabel *bzLb;

@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *priceLb;
@property (weak, nonatomic) IBOutlet UILabel *couponsFee;
@property (weak, nonatomic) IBOutlet UILabel *jieshiLb;

@property (nonatomic, copy) JieDanBlock block;

@property (weak, nonatomic) IBOutlet UIButton *judabBt;
@property (weak, nonatomic) IBOutlet UIButton *jiedanBT;
@property (weak, nonatomic) IBOutlet UIButton *jiaoHaoBt;

@end
