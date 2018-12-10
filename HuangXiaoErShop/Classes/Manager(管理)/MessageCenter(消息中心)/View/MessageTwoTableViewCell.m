//
//  MessageTwoTableViewCell.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/12/4.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "MessageTwoTableViewCell.h"

@implementation MessageTwoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatAutoLayout];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (void)creatAutoLayout{
    
    self.titleLable.frame = CGRectMake(10, 10, kScreenWidth - 40, 30);
    [self.contentView addSubview:self.contentLable];
    self.contentLable.numberOfLines = 0;
    self.contentLable.preferredMaxLayoutWidth = kScreenWidth - 40;
    [self.contentView addSubview:self.contentLable];
    [self.contentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(20);
        make.bottom.mas_equalTo(40);
    }];
    
}
- (UILabel *)titleLable{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc]init];
        _titleLable.text = @"123";
    }
    return _titleLable;
}

- (void)setMessageWith:(MessageModel *)model{
    
    NSAttributedString *contentStr = [[NSAttributedString alloc]initWithString:model.content attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16], NSForegroundColorAttributeName:kColor(204, 204, 204)}];
    self.contentLable.attributedText = contentStr;
    NSLog(@"%@",contentStr);
}
- (CGFloat)heightForModel:(MessageModel *)model{
    [self setMessageWith:model];
    [self layoutIfNeeded];
    
    CGFloat cellHeight = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height+1;
    
    return cellHeight;
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
