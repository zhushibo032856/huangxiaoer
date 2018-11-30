//
//  MineOneTableViewCell.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/8/6.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "MineOneTableViewCell.h"

@implementation MineOneTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatAutoLayout];
    }
    return self;
}

- (void)creatAutoLayout{
    
    [self.contentView addSubview:self.voiceimageView];
    [self.contentView addSubview:self.voiceLable];
    [self.contentView addSubview:self.voiceSwitch];
    
    self.voiceimageView.sd_layout.topSpaceToView(self.contentView, 13).leftSpaceToView(self.contentView, 13).widthIs(24).heightIs(24);
    
    self.voiceLable.sd_layout.topSpaceToView(self.contentView, 10).leftSpaceToView(self.voiceimageView, 10).widthIs(100).heightIs(30);
    
    self.voiceSwitch.sd_layout.topSpaceToView(self.contentView, 10).rightSpaceToView(self.contentView, 15).widthIs(30).heightIs(30);
}
- (UISwitch *)voiceSwitch{
    
    if (!_voiceSwitch) {
        _voiceSwitch = [[UISwitch alloc]init];
        [_voiceSwitch setOn:YES];
    }
    return _voiceSwitch;
}

- (UIImageView *)voiceimageView{
    
    if (!_voiceimageView) {
        _voiceimageView = [[UIImageView alloc]init];
        // [_voiceimageView setImage:[UIImage imageNamed:@"voiceImage"]];
        
    }
    return _voiceimageView;
}

- (UILabel *)voiceLable{
    
    if (!_voiceLable) {
        _voiceLable = [[UILabel alloc]init];
        _voiceLable.font = [UIFont systemFontOfSize:16];
        // _voiceLable.text = @"门店信息";
    }
    return _voiceLable;
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
