//
//  NewCancelTableViewCell.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/12/17.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "NewCancelTableViewCell.h"

@implementation NewCancelTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)cellViewsValueWithModel:(CellModel *)model{
    
    self.TypeLable.text = @"订单已取消";
    self.BeizhuLable.text = model.des;
    [self.TakeNum setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    if ([model.orderType isEqualToString:@"APPOINTMENT"] ||[model.orderType isEqualToString:@"SECKILL"]) {
        [self.TypeImage setImage:[UIImage imageNamed:@"APPOINTMENT"]];
        if (model.takeNum.length == 0) {
            self.TakeNum.text = @"取餐号 --";
        }else if (model.takeNum.length < 2 && model.takeNum.length > 0) {
            self.TakeNum.text = [NSString stringWithFormat:@"取餐号 0%@",model.takeNum];
        }else{
            self.TakeNum.text = [NSString stringWithFormat:@"取餐号 %@",model.takeNum];
        }
    }else{
        [self.TypeImage setImage:[UIImage imageNamed:@"DINEIN"]];
        self.TakeNum.text = [NSString stringWithFormat:@"桌号 %@",model.deskNum];
    }
    
    [self.AddView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (NSInteger i = 0; i < model.arr.count; i++) {
        OrderCaiModel *caiModel = model.arr[i];
        
        UIView *caiView = [self addViewWithFrame:(CGRectMake(0, 10 + 30 * i,kScreenWidth - 50 , 30)) Title:caiModel.goodsName num:caiModel.goodsNum Price:caiModel.goodsPrice];
        [self.AddView addSubview:caiView];
    }
    self.RefundReason.text = model.desFefount;
}
- (UIView *)addViewWithFrame:(CGRect)frame
                       Title:(NSString *)title
                         num:(NSString *)num
                       Price:(NSString *)price {
    UIView *view = [UIView new];
    view.frame = frame;
    
    UILabel *titleLb = [[UILabel alloc] initWithFrame:(CGRectMake(0, 0, view.width - 100, view.height))];
    [view addSubview:titleLb];
    [titleLb setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    titleLb.text = title;
    
    //    UILabel *priceLb = [[UILabel alloc] initWithFrame:(CGRectMake(view.width - 100, 0, 80, view.height))];
    //    CGFloat floatPrice = [[NSString stringWithFormat:@"%@",price]floatValue];
    //
    //    if (floatPrice == 0.00) {
    //        priceLb.text = [NSString stringWithFormat:@""];
    //    }else{
    //        priceLb.text = [NSString stringWithFormat:@"￥%.2f",floatPrice];
    //    }
    //  //  [view addSubview:priceLb];
    //    priceLb.textAlignment = NSTextAlignmentRight;
    
    
    UILabel *numLb = [[UILabel alloc] initWithFrame:(CGRectMake(view.width - 30, 0, 20, view.height))];
    numLb.text = [NSString stringWithFormat:@"%@",num];
    [numLb setFont:[UIFont fontWithName:@"Helvetica-Bold" size:19]];
    [view addSubview:numLb];
    
    UILabel *fenLable = [[UILabel alloc]initWithFrame:CGRectMake(view.width - 10, 0, 20,view.height)];
    fenLable.text = @"份";
    [view addSubview:fenLable];
    
    
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
