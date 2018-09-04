//
//  TodayOrderTableViewCell.m
//  HXEshop
//
//  Created by apple on 2018/3/7.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "TodayOrderTableViewCell.h"

@implementation TodayOrderTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatAutoLayout];
    }
    return self;
}

- (void)creatAutoLayout{
    
    self.numberLanle.frame = CGRectMake(15, 10, kScreenWidth * 0.55, 20);
    self.timeLable.frame = CGRectMake(15, 35, kScreenWidth * 0.55, 20);
    self.priceLable.frame = CGRectMake(kScreenWidth * 0.7, 10, kScreenWidth * 0.2, 20);
    self.payType.frame = CGRectMake(kScreenWidth * 0.7, 35, kScreenWidth * 0.2, 20);
    
    [self.contentView addSubview:self.numberLanle];
    [self.contentView addSubview:self.timeLable];
    [self.contentView addSubview:self.priceLable];
    [self.contentView addSubview:self.payType];
    
}

- (UILabel *)numberLanle{
    
    if (!_numberLanle) {
        _numberLanle = [UILabel new];
        _numberLanle.font = [UIFont systemFontOfSize:12];
        _numberLanle.textColor = [UIColor blackColor];
    }
    return _numberLanle;
}

- (UILabel *)timeLable{
    
    if (!_timeLable) {
        _timeLable = [UILabel new];
        _timeLable.font = [UIFont systemFontOfSize:11];
        _timeLable.textColor = [UIColor lightGrayColor];
    }
    return _timeLable;
}

- (UILabel *)priceLable{
    
    if (!_priceLable) {
        _priceLable = [UILabel new];
        _priceLable.textColor = [UIColor blackColor];
        _priceLable.textAlignment = NSTextAlignmentCenter;
        _priceLable.font = [UIFont systemFontOfSize:12];
    }
    return _priceLable;
}
- (UILabel *)payType{
    
    if (!_payType) {
        _payType = [UILabel new];
       // _payType.text = @"在线支付";
     //   _payType.textColor = [UIColor lightGrayColor];
        _payType.textAlignment = NSTextAlignmentCenter;
        _payType.font = [UIFont systemFontOfSize:11];
    }
    return _payType;
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
