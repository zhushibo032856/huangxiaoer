//
//  TodayIncomeTableViewCell.m
//  HuangXiaoErShop
//
//  Created by apple on 2019/1/4.
//  Copyright © 2019年 aladdin. All rights reserved.
//

#import "TodayIncomeTableViewCell.h"

@implementation TodayIncomeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initAutoLayout];
    }
    return self;
}

- (void)uploadDataForCellWith:(TodayDataModel *)model{
    
    if (kStringIsEmpty(model.ordercount)) {
        self.orderNumberLable.text = @"0";
    }else{
        self.orderNumberLable.text = [NSString stringWithFormat:@"%@",model.ordercount];
    }
    self.incomeLable.text = [NSString stringWithFormat:@"%.2f",model.orderfeesum];
    self.orderQrLable.text = [NSString stringWithFormat:@"%.2f",model.orderqrfeesum];
    
}
- (void)initAutoLayout{
    
    self.orderNumber.frame = CGRectMake(0, 20, (kScreenWidth - 30) / 3, 25);
    self.orderNumberLable.frame = CGRectMake(0, 50, (kScreenWidth - 30) / 3, 25);
    self.income.frame = CGRectMake((kScreenWidth - 30) / 3, 20, (kScreenWidth - 30) / 3, 25);
    self.incomeLable.frame = CGRectMake((kScreenWidth - 30) / 3 , 50, (kScreenWidth - 30) / 3, 25);
    self.orderQr.frame = CGRectMake((kScreenWidth - 30) / 3 * 2, 20, (kScreenWidth - 30) / 3, 25);
    self.orderQrLable.frame = CGRectMake((kScreenWidth - 30) / 3 * 2, 50, (kScreenWidth - 30) / 3, 25);
    
    [self.contentView addSubview:self.orderNumber];
    [self.contentView addSubview:self.orderNumberLable];
    [self.contentView addSubview:self.income];
    [self.contentView addSubview:self.incomeLable];
    [self.contentView addSubview:self.orderQr];
    [self.contentView addSubview:self.orderQrLable];
    
}

- (UILabel *)orderNumber{
    if (!_orderNumber) {
        _orderNumber = [UILabel new];
        _orderNumber.text = @"有效订单";
        _orderNumber.textAlignment = NSTextAlignmentCenter;
    }
    return _orderNumber;
}

- (UILabel *)orderNumberLable{
    if (!_orderNumberLable) {
        _orderNumberLable = [UILabel new];
        _orderNumberLable.textAlignment = NSTextAlignmentCenter;
        [_orderNumberLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:25]];
    }
    return _orderNumberLable;
}

- (UILabel *)income{
    if (!_income) {
        _income = [UILabel new];
        _income.text = @"预计收入";
        _income.textAlignment = NSTextAlignmentCenter;
    }
    return _income;
}

- (UILabel *)incomeLable{
    if (!_incomeLable) {
        _incomeLable = [UILabel new];
        _incomeLable.textAlignment = NSTextAlignmentCenter;
        [_incomeLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:25]];
    }
    return _incomeLable;
}

- (UILabel *)orderQr{
    if (!_orderQr) {
        _orderQr = [UILabel new];
        _orderQr.textAlignment = NSTextAlignmentCenter;
        _orderQr.text = @"扫码收款";
    }
    return _orderQr;
}

- (UILabel *)orderQrLable{
    if (!_orderQrLable) {
        _orderQrLable = [UILabel new];
        _orderQrLable.textAlignment = NSTextAlignmentCenter;
        [_orderQrLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:25]];
    }
    return _orderQrLable;
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
