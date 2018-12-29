//
//  NewAppointTableViewCell.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/12/19.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "NewAppointTableViewCell.h"

@implementation NewAppointTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


- (void)cellViewsValueWithModel:(CellModel *)model {
    
    if (kStringIsEmpty(model.useDate)) {
        self.UseDateLable.text = [NSString stringWithFormat:@""];
    }else{
        NSString *string = [model.useDate substringWithRange:NSMakeRange(5, 11)];
        self.UseDateLable.text = [NSString stringWithFormat:@"%@",string];
    }
    [self.UseDateLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    
    self.PrinterButton.layer.masksToBounds = YES;
    self.PrinterButton.layer.cornerRadius = 20;
    [self.PrinterButton.layer setBorderWidth:1.0];
    [self.PrinterButton.layer setBorderColor:kColor(210, 210, 210).CGColor];
    
    self.JvDanButton.layer.masksToBounds = YES;
    self.JvDanButton.layer.cornerRadius = 20;
    [self.JvDanButton.layer setBorderWidth:1.0];
    [self.JvDanButton.layer setBorderColor:kColor(210, 210, 210).CGColor];
    
    self.JieDanButton.layer.masksToBounds = YES;
    self.JieDanButton.layer.cornerRadius = 20;
    [self.JieDanButton.layer setBorderWidth:1.0];
    [self.JieDanButton.layer setBorderColor:kColor(255, 210, 0).CGColor];
    
    self.JiaoHaoButton.layer.masksToBounds = YES;
    self.JiaoHaoButton.layer.cornerRadius = 20;
    [self.JiaoHaoButton.layer setBorderWidth:1.0];
    [self.JiaoHaoButton.layer setBorderColor:kColor(20, 200, 120).CGColor];
    [self.JiaoHaoButton setBackgroundColor:kColor(20, 200, 120)];
    
    self.BeizhuLable.text = model.des;
    [self.takeNumLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    if ([model.orderType isEqualToString:@"APPOINTMENT"] ||[model.orderType isEqualToString:@"SECKILL"]) {
        [self.TypeImage setImage:[UIImage imageNamed:@"APPOINTMENT"]];
        if (model.takeNum.length == 0) {
            self.takeNumLable.text = @"取餐号 --";
        }else if (model.takeNum.length < 2 && model.takeNum.length > 0) {
            self.takeNumLable.text = [NSString stringWithFormat:@"取餐号 0%@",model.takeNum];
        }else{
            self.takeNumLable.text = [NSString stringWithFormat:@"取餐号 %@",model.takeNum];
        }
    }else{
        [self.TypeImage setImage:[UIImage imageNamed:@"DINEIN"]];
        self.takeNumLable.text = [NSString stringWithFormat:@"桌号 %@",model.deskNum];
    }
    
    if ([model.orderStatus integerValue] == 1) {
        self.OrderTypeLable.text = @"待接单";
    }else if ([model.orderStatus integerValue] == 2){
        self.OrderTypeLable.text = @"已接单";
    }else if ([model.orderStatus integerValue] == 4){
        self.OrderTypeLable.text = @"等待取餐";
    }else if ([model.orderStatus integerValue] == 5){
        self.OrderTypeLable.text = @"用户退单";
    }else if ([model.orderStatus integerValue] == 6){
        self.OrderTypeLable.text = @"订单完成";
    }else{
        self.OrderTypeLable.text = @"已取消";
    }
    
    [self.addView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (NSInteger i = 0; i < model.arr.count; i++) {
        OrderCaiModel *caiModel = model.arr[i];
        
        UIView *caiView = [self addViewWithFrame:(CGRectMake(0, 10 + 30 * i,kScreenWidth - 50 , 30)) Title:caiModel.goodsName num:caiModel.goodsNum Price:caiModel.goodsPrice];
        [self.addView addSubview:caiView];
    }
    
    if (1 == [model.orderStatus integerValue]) {
        [self.JieDanButton setHidden:NO];
        [self.JvDanButton setHidden:NO];
        [self.JiaoHaoButton setHidden:YES];
    } else {
        [self.JieDanButton setHidden:YES];
        [self.JvDanButton setHidden:YES];
        [self.JiaoHaoButton setHidden:NO];
    }
}

- (UIView *)addViewWithFrame:(CGRect)frame
                       Title:(NSString *)title
                         num:(NSString *)num
                       Price:(NSString *)price {
    UIView *view = [UIView new];
    view.frame = frame;
    
    UILabel *titleLb = [[UILabel alloc] initWithFrame:(CGRectMake(0, 0, view.width - 100, view.height))];
    [titleLb setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    [view addSubview:titleLb];
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


- (IBAction)JieDanButtonAction:(UIButton *)sender {
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
