//
//  AddMachinesTableViewCell.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "AddMachinesTableViewCell.h"

@implementation AddMachinesTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.addLable];
        self.addLable.frame = CGRectMake(10, 5, kScreenWidth - 20, 40);
    }
    return self;
}

- (UILabel *)addLable{
    
    if (!_addLable) {
        _addLable = [[UILabel alloc]init];
        _addLable.textAlignment = NSTextAlignmentCenter;
        //   _addLable.text = @"添加GPRS新票机";
        _addLable.font = [UIFont systemFontOfSize:15];
    }
    return _addLable;
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
