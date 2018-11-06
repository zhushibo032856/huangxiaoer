//
//  SearchBlueToothTableViewCell.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/10/30.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "SearchBlueToothTableViewCell.h"

@implementation SearchBlueToothTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatAutoLayout];
    }
    return self;
}
- (void)creatAutoLayout{
    [self.contentView addSubview:self.nameLable];
    
    self.nameLable.frame = CGRectMake(20, 10, kScreenWidth - 20, 30);
}
- (UILabel *)nameLable{
    if (!_nameLable) {
        _nameLable = [[UILabel alloc]init];
        
    }
    return _nameLable;
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
