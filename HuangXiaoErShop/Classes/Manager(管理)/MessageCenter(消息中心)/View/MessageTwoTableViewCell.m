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
    
    self.titleLable = [[UILabel alloc]init];
    self.timeLable.font = [UIFont systemFontOfSize:21];
    [self.contentView addSubview:self.titleLable];
    
    self.contentLable = [[UILabel alloc]init];
    self.contentLable.numberOfLines = 0;
    self.contentLable.font = [UIFont systemFontOfSize:17];
    self.contentLable.textColor = kColor(204, 204, 204);
    [self.contentView addSubview:self.contentLable];
    
    self.timeLable = [[UILabel alloc]init];
    self.timeLable.textColor = kColor(204, 204, 204);
    self.timeLable.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.timeLable];
    
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.contentView).offset(10);
        make.height.mas_equalTo(30);
        
    }];
    
    [self.contentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(10);
        make.right.mas_equalTo(self.contentView).offset(-10);
        make.top.mas_equalTo(self.titleLable.mas_bottom).offset(10);
        make.height.mas_equalTo(60);
    }];
    
    [self.timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentLable.mas_bottom).offset(20);
        make.right.mas_equalTo(self.contentView).offset(-10);
        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(self.contentView).offset(-10);
    }];
    
}


- (void)setMessageWith:(MessageModel *)model{
 

    if ([model.type isEqualToString:@"ORDERMSG"]) {
        _titleLable.text = @"订单消息";
    }else if ([model.type isEqualToString:@"VERIFYMSG"]){
        _titleLable.text = @"审核信息";
    }else if ([model.type isEqualToString:@"SYSMSG"]){
        _titleLable.text = @"系统通知";
    }else if ([model.type isEqualToString:@"PAYMSG"]){
        _titleLable.text = @"财务信息";
    }else if ([model.type isEqualToString:@"ACTIVEITYMSG"]){
        _titleLable.text = @"活动消息";
    }
    _contentLable.text = model.content;
    _timeLable.text = model.sendTime;
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
