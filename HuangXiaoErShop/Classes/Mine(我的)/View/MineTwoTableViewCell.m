//
//  MineTwoTableViewCell.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/8/6.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "MineTwoTableViewCell.h"

@implementation MineTwoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatAutoLayout];
    }
    return self;
}

- (void)creatAutoLayout{
    
    [self.contentView addSubview:self.quitLogin];
    
    self.quitLogin.sd_layout.topSpaceToView(self.contentView, 10).leftSpaceToView(self.contentView, kScreenWidth / 3).widthIs(kScreenWidth / 3).heightIs(30);
}

- (UIButton *)quitLogin{
    
    if (!_quitLogin) {
        _quitLogin = [UIButton buttonWithType:UIButtonTypeSystem];
        [_quitLogin setTitle:@"退出登录" forState:UIControlStateNormal];
        _quitLogin.tintColor = [UIColor redColor];
        _quitLogin.titleLabel.font = [UIFont systemFontOfSize:16];
        
    }
    return _quitLogin;
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
