//
//  AppointmentTableViewCell.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/10/22.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "AppointmentTableViewCell.h"

@implementation AppointmentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
   self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self creatAutoLayout];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)creatAutoLayout{
    
    [self.contentView addSubview:self.timeLable];
    [self.contentView addSubview:self.editButton];
    [self.contentView addSubview:self.delButton];
    
    self.timeLable.frame = CGRectMake(20, 5, kScreenWidth * 0.55, 40);
    _editButton.frame = CGRectMake(kScreenWidth * 0.6, 10, kScreenWidth * 0.15, 35);
    _delButton.frame = CGRectMake(kScreenWidth * 0.8 - 5, 10, kScreenWidth * 0.15, 35);
    
}

- (UILabel *)timeLable{
    if (!_timeLable) {
        _timeLable = [[UILabel alloc]init];
    }
    return _timeLable;
}

- (UIButton *)editButton{
    if (!_editButton) {
        _editButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [_editButton setTintColor:[UIColor blackColor]];
        [_editButton setTag:100];
        [_editButton addTarget:self action:@selector(editButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editButton;
}
- (UIButton *)delButton{
    if (!_delButton) {
        _delButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_delButton setTitle:@"删除" forState:UIControlStateNormal];
        [_delButton setTintColor:kColor(210, 210, 210)];
        [_delButton setTag:200];
        [_delButton addTarget:self action:@selector(editButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _delButton;
}

- (void)editButton:(UIButton *)sender{
    
    _block(_index,sender.tag);
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
