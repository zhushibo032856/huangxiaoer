//
//  UserReviewTableViewCell.m
//  HXEshop
//
//  Created by apple on 2018/3/5.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "UserReviewTableViewCell.h"

@implementation UserReviewTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatAutoLayout];
    }
    return self;
}

- (void)creatAutoLayout{
    
    self.userImage.frame = CGRectMake(5, 5, 40, 40);
    self.userNameLable.frame = CGRectMake(50, 5, 100, 15);
    self.userNumberLable.frame = CGRectMake(50, 25, 100, 15);
    self.timeLable.frame = CGRectMake(kScreenWidth - 110, 5, 100, 15);
    self.assessLable.frame = CGRectMake(50, 45, kScreenWidth - 70, 40);
    
    [self.contentView addSubview:_userImage];
    [self.contentView addSubview:_userNameLable];
    [self.contentView addSubview:_userNumberLable];
    [self.contentView addSubview:_timeLable];
    [self.contentView addSubview:_assessLable];
}

- (UIImageView *)userImage{
    
    if (!_userImage) {
        _userImage = [UIImageView new];
        _userImage.layer.masksToBounds = YES;
        _userImage.layer.cornerRadius = 20;
        _userImage.backgroundColor = [UIColor redColor];
    }
    return _userImage;
}

- (UILabel *)userNameLable{
    if (!_userNameLable) {
        _userNameLable = [UILabel new];
        _userNameLable.font = [UIFont systemFontOfSize:12];
    }
    return _userNameLable;
}
- (UILabel *)userNumberLable{
    
    if (!_userNumberLable) {
        _userNumberLable = [UILabel new];
        _userNumberLable.font = [UIFont systemFontOfSize:11];
    }
    return _userNumberLable;
}

- (UILabel *)timeLable{
    
    if (!_timeLable) {
        _timeLable = [UILabel new];
        _timeLable.font = [UIFont systemFontOfSize:12];
    }
    return _timeLable;
}

- (UILabel *)assessLable{
    
    if (!_assessLable) {
        _assessLable = [UILabel new];
        _assessLable.numberOfLines = 0;
    //    _assessLable.backgroundColor = [UIColor redColor];
        _assessLable.font = [UIFont systemFontOfSize:12];
    }
    return _assessLable;
}



- (void)setFrame:(CGRect)frame{
    frame.origin.x += 10;
    frame.origin.y += 10;
    frame.size.height -= 10;
    frame.size.width -= 20;
    [super setFrame:frame];
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
