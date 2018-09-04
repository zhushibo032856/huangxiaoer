//
//  JiaoHaoTableViewCell.m
//  HXEshop
//
//  Created by apple on 2018/3/12.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "JiaoHaoTableViewCell.h"

@implementation JiaoHaoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatAutoLayout];
    }
    return self;
}

- (void)creatAutoLayout{
    
    self.xunxuLable.frame = CGRectMake(10, 15, 50, 20);
    self.timeImageView.frame = CGRectMake(50, 15, 20, 20);
    self.comeTimeLable.frame = CGRectMake(80, 15, 150, 20);
    self.jiaohaoImageView.frame = CGRectMake(150, 15, 20, 20);
    self.jiaohaoButton.frame = CGRectMake(kScreenWidth * 0.7, 15, kScreenWidth * 0.25, 20);
    
    [self.contentView addSubview:self.xunxuLable];
    [self.contentView addSubview:self.timeImageView];
    [self.contentView addSubview:self.comeTimeLable];
    [self.contentView addSubview:self.jiaohaoImageView];
    [self.contentView addSubview:self.jiaohaoButton];
    
}
- (void)cellGetDataWithModel:(CellModel *)model{
    
    self.xunxuLable.text = [NSString stringWithFormat:@"#%@",model.takeNum];
    [self.timeImageView setImage:[UIImage imageNamed:@"timeImage"]];
    NSString *string = [model.useDate substringWithRange:NSMakeRange(11, 5)];
    self.comeTimeLable.text = [NSString stringWithFormat:@"预计%@到店",string];
  //  [self.jiaohaoButton setTitle:@"叫号" forState:UIControlStateNormal];
  //  self.jiaohaoButton.tintColor = [UIColor blackColor];
    if (4 == [model.orderStatus integerValue]) {
        [self.jiaohaoButton setTitle:@"已叫号" forState:UIControlStateNormal];
        self.jiaohaoButton.tintColor = [UIColor greenColor];
    }else if (2 == [model.orderStatus integerValue]){
        [self.jiaohaoButton setTitle:@"叫号" forState:UIControlStateNormal];
        self.jiaohaoButton.tintColor = [UIColor blackColor];
    }
    else if (3 == [model.orderStatus integerValue]){
        [self.jiaohaoButton setTitle:@"已拒单" forState:UIControlStateNormal];
        self.jiaohaoButton.tintColor = [UIColor redColor];
    }
    
    
}

- (UILabel *)xunxuLable{
    
    if (!_xunxuLable) {
        _xunxuLable = [[UILabel alloc]init];
        _xunxuLable.font = [UIFont systemFontOfSize:15];
    }
    return _xunxuLable;
}

- (UIImageView *)timeImageView{
    
    if (!_timeImageView) {
        _timeImageView = [UIImageView new];
    }
    return _timeImageView;
}

- (UILabel *)comeTimeLable {
    
    if (!_comeTimeLable) {
        _comeTimeLable = [UILabel new];
        _comeTimeLable.font = [UIFont systemFontOfSize:13];
        _comeTimeLable.textColor = [UIColor lightGrayColor];
    }
    return _comeTimeLable;
}
- (UIImageView *)jiaohaoImageView{
    
    if (!_jiaohaoImageView) {
        _jiaohaoImageView = [UIImageView new];
    }
    return _jiaohaoImageView;
}

- (UIButton *)jiaohaoButton{
    
    if (!_jiaohaoButton) {
        _jiaohaoButton = [UIButton buttonWithType:UIButtonTypeSystem];
    }
    return _jiaohaoButton;
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
