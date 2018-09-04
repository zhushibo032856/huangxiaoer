//
//  JieDanCell.m
//  zhedie
//
//  Created by Apple on 2018/3/4.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "JieDanCell.h"

@implementation JieDanCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)cellViewsValueWithModel:(CellModel *)model {
    self.nameLb.text = model.nickName;
    self.bzLb.text = model.des;
    self.timeLb.text = model.createTime;
    
    if ([model.isCoupons integerValue] == 1) {
        self.jieshiLb.text = [NSString stringWithFormat:@"(黄小二平台补贴%@元)",model.couponsFee];
    }else{
        self.jieshiLb.text = @"";
    }
    if ([model.orderType isEqualToString:@"APPOINTMENT"]) {
        self.priceLb.text = [NSString stringWithFormat:@"￥%@",model.totalFee];
        self.couponsFee.text = [NSString stringWithFormat:@"￥%@",model.realFee];
    }else if([model.orderType isEqualToString:@"PT"]){
        self.priceLb.text = [NSString stringWithFormat:@"￥%@",model.totalFee];
        self.couponsFee.text = [NSString stringWithFormat:@"￥%@",model.totalFee];
    }

    [self.addView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (NSInteger i = 0; i < model.arr.count; i++) {
        OrderCaiModel *caiModel = model.arr[i];

        UIView *caiView = [self addViewWithFrame:(CGRectMake(10, 10 + 30 * i,kScreenWidth - 50 , 30)) Title:caiModel.goodsName num:caiModel.goodsNum Price:caiModel.goodsPrice];
        [self.addView addSubview:caiView];
    }

    if (1 == [model.orderStatus integerValue]) {
        [self.jiedanBT setHidden:NO];
        [self.judabBt setHidden:NO];
        [self.jiaoHaoBt setHidden:YES];
    } else {
        [self.jiedanBT setHidden:YES];
        [self.judabBt setHidden:YES];
        [self.jiaoHaoBt setHidden:NO];
    }
    
}


- (UIView *)addViewWithFrame:(CGRect)frame
                       Title:(NSString *)title
                         num:(NSString *)num
                       Price:(NSString *)price {
    UIView *view = [UIView new];
    view.frame = frame;
    
    UILabel *titleLb = [[UILabel alloc] initWithFrame:(CGRectMake(0, 0, view.width - 100, view.height))];
    [view addSubview:titleLb];
    titleLb.text = title;
    
    UILabel *priceLb = [[UILabel alloc] initWithFrame:(CGRectMake(view.width - 100, 0, 80, view.height))];
    CGFloat floatPrice = [[NSString stringWithFormat:@"%@",price]floatValue];
    
    if (floatPrice == 0.00) {
        priceLb.text = [NSString stringWithFormat:@""];
    }else{
        priceLb.text = [NSString stringWithFormat:@"￥%.2f",floatPrice];
    }
    [view addSubview:priceLb];
    priceLb.textAlignment = NSTextAlignmentRight;
    
    
    UILabel *numLb = [[UILabel alloc] initWithFrame:(CGRectMake(priceLb.left - 30, 0, 30, view.height))];
    numLb.text = [NSString stringWithFormat:@"x%@",num];
    [view addSubview:numLb];
    
    
    return view;
}
- (IBAction)jieDanBtAction:(UIButton *)sender {
    _block(_index, sender.tag);
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
