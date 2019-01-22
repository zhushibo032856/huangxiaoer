//
//  CateGoryTableViewCell.m
//  HXEshop
//
//  Created by apple on 2018/3/27.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "CateGoryTableViewCell.h"

@implementation CateGoryTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatAutoLayOut];
    }
    return self;
}

- (void)cellDataFromModel:(LeftDataModel *)model{
    
    self.nameLable.text = model.name;
    
}
- (void)creatAutoLayOut{
    
    self.nameLable.frame = CGRectMake(20, 10, 150, 30);
    self.editButton.frame = CGRectMake(kScreenWidth * 0.8 - 10, 10, kScreenWidth * 0.15, 30);
    
    [self.contentView addSubview:self.nameLable];
    [self.contentView addSubview:self.editButton];
    
}

- (UILabel *)nameLable{
    if (!_nameLable) {
        _nameLable = [[UILabel alloc]init];
        _nameLable.font = [UIFont systemFontOfSize:15];
    }
    return _nameLable;
}
- (UIButton *)editButton{
    if (!_editButton) {
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editButton setTag:100];
        _editButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_editButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [_editButton addTarget:self action:@selector(editButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editButton;
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
