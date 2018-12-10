//
//  MessageOneTableViewCell.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/12/4.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "MessageOneTableViewCell.h"

@implementation MessageOneTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatAutoLayout];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (void)creatAutoLayout{
    
    self.typeImage.frame = CGRectMake(10, 19, 12, 12);
    self.typeLable.frame = CGRectMake(30, 15, kScreenWidth * 0.3, 20);
    self.timeLable.frame = CGRectMake(kScreenWidth * 0.45, 10, kScreenWidth * 0.45, 20);
    self.contentLable.frame = CGRectMake(30, 40, kScreenWidth - 55, 20);
    self.messageType.frame = CGRectMake(30, 65, 70, 20);
    self.detaillable.frame = CGRectMake(kScreenWidth * 0.4, 90, kScreenWidth * 0.45, 20);
    self.detailImage.frame = CGRectMake(kScreenWidth * 0.85 + 5, 95, 10, 10);
    
    [self.contentView addSubview:self.typeImage];
    [self.contentView addSubview:self.typeLable];
    [self.contentView addSubview:self.timeLable];
    [self.contentView addSubview:self.contentLable];
    [self.contentView addSubview:self.messageType];
    [self.contentView addSubview:self.detaillable];
    [self.contentView addSubview:self.detailImage];
}

- (void)setDataForCellWith:(MessageModel *)model{
    
    NSString *time = [model.sendTime substringWithRange:NSMakeRange(0, 16)];
    _timeLable.text = [NSString stringWithFormat:@"%@",time];
    _contentLable.text = model.content;
    
    if ([model.status integerValue] == 1) {
        [_typeImage setBackgroundColor:kColor(255, 210, 0)];
        _typeLable.textColor = kColor(0, 0, 0);
        _detaillable.textColor = kColor(0, 0, 0);
    }else{
        [_typeImage setBackgroundColor:kColor(210, 210, 210)];
        _typeLable.textColor = kColor(210, 210, 210);
        _detaillable.textColor = kColor(210, 210, 210);
    }
    
    if ([model.type isEqualToString:@"ORDERMSG"]) {
        _typeLable.text = @"订单状态";
        _messageType.text = @"订单消息";
    }else if ([model.type isEqualToString:@"VERIFYMSG"]){
        _typeLable.text = @"审核进度";
        _messageType.text = @"审核信息";
    }else if ([model.type isEqualToString:@"SYSMSG"]){
        _typeLable.text = @"系统消息";
        _messageType.text = @"系统通知";
    }else if ([model.type isEqualToString:@"PAYMSG"]){
        _typeLable.text = @"支付信息";
        _messageType.text = @"财务信息";
    }else if ([model.type isEqualToString:@"ACTIVEITYMSG"]){
        _typeLable.text = @"活动通知";
        _messageType.text = @"活动消息";
    }
    
    
}

- (UIImageView *)typeImage{
    if (!_typeImage) {
        _typeImage = [[UIImageView alloc]init];
        _typeImage.layer.masksToBounds = YES;
        _typeImage.layer.cornerRadius = 6;
    }
    return _typeImage;
}
- (UILabel *)typeLable{
    if (!_typeLable) {
        _typeLable = [[UILabel alloc]init];
        _typeLable.font = [UIFont systemFontOfSize:19];
    }
    return _typeLable;
}
- (UILabel *)timeLable{
    if (!_timeLable) {
        _timeLable = [[UILabel alloc]init];
        _timeLable.textColor = kColor(204, 204, 204);
        _timeLable.textAlignment = NSTextAlignmentRight;
    }
    return _timeLable;
}
- (UILabel *)contentLable{
    if (!_contentLable) {
        _contentLable = [[UILabel alloc]init];
        _contentLable.font = [UIFont systemFontOfSize:15];
        _contentLable.textColor = kColor(150, 150, 150);
        _contentLable.numberOfLines = 1;
    }
    return _contentLable;
}
- (UILabel *)messageType{
    if (!_messageType) {
        _messageType = [[UILabel alloc]init];
        _messageType.textAlignment = NSTextAlignmentCenter;
        _messageType.font = [UIFont systemFontOfSize:15];
        _messageType.textColor = kColor(150, 150, 150);
        _messageType.backgroundColor = kColor(240, 240, 240);
    }
    return _messageType;
}


- (UILabel *)detaillable{
    if (!_detaillable) {
        _detaillable = [[UILabel alloc]init];
        _detaillable.textAlignment = NSTextAlignmentRight;
        _detaillable.text = @"查看详情";
        
    }
    return _detaillable;
}
- (UIImageView *)detailImage{
    if (!_detailImage) {
        _detailImage = [[UIImageView alloc]init];
     //   _detailImage.backgroundColor = [UIColor redColor];
        [_detailImage setImage:[UIImage imageNamed:@"chakanxiangqing"]];
    }
    return _detailImage;
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
