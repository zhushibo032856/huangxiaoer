//
//  MessageDetailTableViewCell.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/12/13.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "MessageDetailTableViewCell.h"

@implementation MessageDetailTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
