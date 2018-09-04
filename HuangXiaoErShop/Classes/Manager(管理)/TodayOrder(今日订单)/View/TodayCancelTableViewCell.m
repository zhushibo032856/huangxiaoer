//
//  TodayCancelTableViewCell.m
//  HXEshop
//
//  Created by apple on 2018/3/7.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "TodayCancelTableViewCell.h"

@implementation TodayCancelTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatAutoLayout];
    }
    return self;
}

- (void)creatAutoLayout{
    
    self.numberLanle.frame = CGRectMake(15, 10, kScreenWidth * 0.55, 15);
    self.timeLable.frame = CGRectMake(15, 35, kScreenWidth * 0.55, 15);
    self.refuseLable.frame = CGRectMake(kScreenWidth * 0.7, 10, kScreenWidth * 0.2, 15);
    self.reasonLable.frame = CGRectMake(kScreenWidth * 0.7, 35, kScreenWidth * 0.2, 15);
    
    [self.contentView addSubview:self.numberLanle];
    [self.contentView addSubview:self.timeLable];
    [self.contentView addSubview:self.refuseLable];
    [self.contentView addSubview:self.reasonLable];
    
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

- (UILabel *)refuseLable{
    
    if (!_refuseLable) {
        _refuseLable = [UILabel new];
        _refuseLable.font = [UIFont systemFontOfSize:12];
        _refuseLable.textColor = [UIColor blackColor];
        _refuseLable.text = @"";
    }
    return _refuseLable;
}
- (UILabel *)reasonLable{
    
    if (!_reasonLable) {
        _reasonLable = [UILabel new];
        _reasonLable.font = [UIFont systemFontOfSize:11];
        _reasonLable.textColor = [UIColor lightGrayColor];
        _reasonLable.text = @"";
    }
    return _reasonLable;
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
