//
//  JieDanCell.m
//  zhedie
//
//  Created by Apple on 2018/3/4.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "AllOrderTableViewCell.h"

@implementation AllOrderTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)cellViewsValueWithModel:(CellModel *)model {

    self.BeiZhuLable.text = model.des;
    self.OrderNumber.text = model.orderNum;
    self.CreatTime.text = model.createTime;
    CGFloat youhuiPrice = [model.couponsFee floatValue];
    if ([model.isCoupons integerValue] == 1) {
        self.CouponsLable.text = [NSString stringWithFormat:@"-￥%.2f",youhuiPrice];
    }else{
        self.CouponsLable.text = [NSString stringWithFormat:@""];
    }
    
    if (6 == [model.orderStatus integerValue]) {
        self.AchieveTime.text = model.updateTime;
    }else{
        self.AchieveTime.text = @"-";
    }
    
    [self.addView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (NSInteger i = 0; i < model.arr.count; i++) {
        OrderCaiModel *caiModel = model.arr[i];

        UIView *caiView = [self addViewWithFrame:(CGRectMake(10, 5 + 30 * i,kScreenWidth - 50 , 30)) Title:caiModel.goodsName num:caiModel.goodsNum Price:caiModel.goodsPrice];
        [self.addView addSubview:caiView];
    }
}


- (UIView *)addViewWithFrame:(CGRect)frame
                       Title:(NSString *)title
                         num:(NSString *)num
                       Price:(NSString *)price {
    UIView *view = [UIView new];
    view.frame = frame;
    
    UILabel *titleLb = [[UILabel alloc] initWithFrame:(CGRectMake(0, 5, view.frame.size.width - 100, view.frame.size.height - 10))];
    titleLb.font = [UIFont systemFontOfSize:15];
    [view addSubview:titleLb];
    titleLb.text = title;
    
    
    UILabel *priceLb = [[UILabel alloc] initWithFrame:(CGRectMake(view.frame.size.width - 70, 5, 70, view.frame.size.height - 10))];
    priceLb.font = [UIFont systemFontOfSize:15];
    CGFloat floatPrice = [[NSString stringWithFormat:@"%@",price]floatValue];
    
    if (floatPrice == 0.00) {
        priceLb.text = [NSString stringWithFormat:@""];
    }else{
        priceLb.text = [NSString stringWithFormat:@"￥%.2f",floatPrice];
    }
    [view addSubview:priceLb];
    priceLb.textAlignment = NSTextAlignmentRight;
    
    
    UILabel *numLb = [[UILabel alloc] initWithFrame:(CGRectMake(priceLb.frame.origin.x - 30, 5, 30, view.frame.size.height - 10))];
    numLb.font=[UIFont systemFontOfSize:15];
    numLb.text = [NSString stringWithFormat:@"x%@",num];
    [view addSubview:numLb];
    
    return view;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
