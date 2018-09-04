//
//  CancleCell.m
//  HXEshop
//
//  Created by apple on 2018/3/11.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "CancleCell.h"

@implementation CancleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
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
    self.priceLb.text = [NSString stringWithFormat:@"￥%@",model.realFee];
    
    [self.addView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (NSInteger i = 0; i < model.arr.count; i++) {
        OrderCaiModel *caiModel = model.arr[i];
        UIView *caiView = [self addViewWithFrame:(CGRectMake(10, 10 + 30 * i,kScreenWidth - 50 , 30)) Title:caiModel.goodsName num:caiModel.goodsNum Price:caiModel.goodsPrice];
        [self.addView addSubview:caiView];
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
    
    
    UILabel *priceLb = [[UILabel alloc] initWithFrame:(CGRectMake(view.width - 70, 0, 60, view.height))];
    priceLb.text = [NSString stringWithFormat:@"￥%@",price];
    [view addSubview:priceLb];
     priceLb.textAlignment = NSTextAlignmentRight;
    
    
    UILabel *numLb = [[UILabel alloc] initWithFrame:(CGRectMake(priceLb.left - 30, 0, 30, view.height))];
    numLb.text = [NSString stringWithFormat:@"x%@",num];
    [view addSubview:numLb];
    
    
    return view;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
