//
//  ScavengingTableViewCell.m
//  HXEshop
//
//  Created by apple on 2018/5/4.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "ScavengingTableViewCell.h"

@implementation ScavengingTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatAutoLayout];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)cellSetDataWith:(ScavengModel *)model{
    
    if ([model.payType integerValue] == 2) {
        [self.payImageView setImage:[UIImage imageNamed:@"AliPay"]];
    }else if([model.payType integerValue] == 1){
        [self.payImageView setImage:[UIImage imageNamed:@"WeChat"]];
    }
    
    self.timeLable.text = [[NSString stringWithFormat:@"%@",model.createTime]substringWithRange:NSMakeRange(11, 8)];
    self.moneyLable.text = [NSString stringWithFormat:@"￥%@",model.realFee];
    self.orderNumberLable.text = [[NSString stringWithFormat:@"%@",model.orderNum]substringWithRange:NSMakeRange(model.orderNum.length - 4, 4)];
    
}

- (void)creatAutoLayout{
    
    self.payImageView.frame = CGRectMake(kScreenWidth * 0.1 - 6.5, 7.5, 35, 35);
    self.timeLable.frame = CGRectMake(kScreenWidth * 0.25 - 10, 10, kScreenWidth * 0.2, 30);
    self.moneyLable.frame = CGRectMake(kScreenWidth * 0.5, 10, kScreenWidth * 0.15, 30);
    self.orderNumberLable.frame = CGRectMake(kScreenWidth * 0.65 + 10, 10, kScreenWidth * 0.3, 30);
    
    [self.contentView addSubview:self.payImageView];
    [self.contentView addSubview:self.timeLable];
    [self.contentView addSubview:self.moneyLable];
    [self.contentView addSubview:self.orderNumberLable];
    
}
- (UIImageView *)payImageView{
    if (!_payImageView) {
        _payImageView = [UIImageView new];
        _payImageView.layer.cornerRadius = 15;
        _payImageView.layer.masksToBounds = YES;
    }
    return _payImageView;
}

- (UILabel *)timeLable{
    if (!_timeLable) {
        _timeLable = [UILabel new];
        _timeLable.font = [UIFont systemFontOfSize:14];
        _timeLable.textColor = kColor(100, 100, 100);
        _timeLable.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLable;
}
- (UILabel *)moneyLable{
    if (!_moneyLable) {
        _moneyLable = [UILabel new];
        _moneyLable.font = [UIFont systemFontOfSize:15];
        _moneyLable.textAlignment = NSTextAlignmentCenter;
    }
    return _moneyLable;
}
- (UILabel *)orderNumberLable{
    if (!_orderNumberLable) {
        _orderNumberLable = [UILabel new];
        _orderNumberLable.font = [UIFont systemFontOfSize:14];
        _orderNumberLable.textColor = kColor(100, 100, 100);
        _orderNumberLable.textAlignment = NSTextAlignmentCenter;
    }
    return _orderNumberLable;
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
