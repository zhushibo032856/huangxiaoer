//
//  TodayIncomeTableViewCell.h
//  HuangXiaoErShop
//
//  Created by apple on 2019/1/4.
//  Copyright © 2019年 aladdin. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "TodayDataModel.h"

@interface TodayIncomeTableViewCell : BaseTableViewCell

@property (nonatomic, strong) UILabel *orderNumber;
@property (nonatomic, strong) UILabel *orderNumberLable;
@property (nonatomic, strong) UILabel *income;
@property (nonatomic, strong) UILabel *incomeLable;
@property (nonatomic, strong) UILabel *orderQr;
@property (nonatomic, strong) UILabel *orderQrLable;

- (void)uploadDataForCellWith:(TodayDataModel *)model;

@end
