//
//  DetailMessageTableViewCell.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/11/14.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "DetailMessageTableViewCell.h"

@implementation DetailMessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatAutoLayout];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
    
}
- (void)creatAutoLayout{
    
    [self.contentView addSubview:self.blueImageView];
    [self.contentView addSubview:self.nameLable];
    [self.contentView addSubview:self.stateLable];
    
    self.blueImageView.frame = CGRectMake(10, 5, 40, 40);
    self.nameLable.frame = CGRectMake(CGRectGetMaxX(self.blueImageView.frame)+10, 10, kScreenWidth * 0.4, 30);
    self.stateLable.frame = CGRectMake(CGRectGetMaxX(self.nameLable.frame), 10, kScreenWidth * 0.35, 30);
}

- (UIImageView *)blueImageView{
    if (!_blueImageView) {
        _blueImageView = [[UIImageView alloc]init];
        _blueImageView.layer.masksToBounds = YES;
        _blueImageView.layer.cornerRadius = 20;
    //    _blueImageView.backgroundColor = [UIColor cyanColor];
    }
    return _blueImageView;
}

- (UILabel *)nameLable{
    if (!_nameLable) {
        _nameLable = [[UILabel alloc]init];
   //     _nameLable.backgroundColor = [UIColor redColor];
    }
    return _nameLable;
}

- (UILabel *)stateLable{
    if (!_stateLable) {
        _stateLable = [[UILabel alloc]init];
    //    _stateLable.backgroundColor = [UIColor orangeColor];
    }
    return _stateLable;
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
