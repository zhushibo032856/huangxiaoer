//
//  SumTableViewCell.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/12/26.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "SumTableViewCell.h"

@implementation SumTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initCellLable];
    }
    return self;
}

- (void)initCellLable{
    
    [self.contentView addSubview:self.todayNumberLable];
    [self.contentView addSubview:self.sunNumberLable];
    
    self.todayNumberLable.frame = CGRectMake(20, 10, kScreenWidth * 0.5, 30);
    self.sunNumberLable.frame = CGRectMake(kScreenWidth * 0.5 + 10, 10, kScreenWidth * 0.5 - 30, 30);
}

- (void)setdataForCellWith:(MemberModel *)model{
    
    _todayNumberLable.text = [NSString stringWithFormat:@"今日新增%ld名新顾客",(long)model.newCustomerCount];
    _sunNumberLable.text = [NSString stringWithFormat:@"当前共%ld名会员",(long)model.customerCount];
    
}

- (UILabel *)todayNumberLable{
    if (!_todayNumberLable) {
        _todayNumberLable = [[UILabel alloc]init];
    }
    return _todayNumberLable;
}
- (UILabel *)sunNumberLable{
    if (!_sunNumberLable) {
        _sunNumberLable = [[UILabel alloc]init];
        [_sunNumberLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
        _sunNumberLable.textAlignment = NSTextAlignmentRight;
    }
    return _sunNumberLable;
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
