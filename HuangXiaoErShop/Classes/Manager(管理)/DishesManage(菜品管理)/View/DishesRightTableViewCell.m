//
//  DishesRightTableViewCell.m
//  HXEshop
//
//  Created by apple on 2018/3/2.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "DishesRightTableViewCell.h"
#import "DishesManagerViewController.h"
#import "RightDataModel.h"

@implementation DishesRightTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatAutoLayout];
    }
    return self;
}

- (void)creatAutoLayout{
    
    [self.contentView addSubview:self.foodImageView];
    [self.contentView addSubview:self.foodNameLable];
    [self.contentView addSubview:self.priceImageLable];
    [self.contentView addSubview:self.priceLable];
    [self.contentView addSubview:self.activityPrice];
    [self.contentView addSubview:self.editorButton];
    [self.contentView addSubview:self.undercarriageButton];
    [self.contentView addSubview:self.underButton];
    
    self.foodImageView.sd_layout.topSpaceToView(self.contentView, 10).leftSpaceToView(self.contentView, 10).widthIs(50).heightIs(50);
    
    self.foodNameLable.sd_layout.topSpaceToView(self.contentView, 10).leftSpaceToView(self.foodImageView, 10).widthIs(250).heightIs(20);
    
    self.priceImageLable.sd_layout.leftSpaceToView(self.foodImageView, 10).topSpaceToView(self.foodNameLable, 10).widthIs(15).heightIs(20);
    
    self.priceLable.sd_layout.topSpaceToView(self.foodNameLable, 10).leftSpaceToView(self.priceImageLable, 2).widthIs(35).heightIs(20);
    
    self.activityPrice.sd_layout.topSpaceToView(self.foodNameLable, 10).leftSpaceToView(self.priceLable, 1).widthIs(60).heightIs(20);
    
    self.editorButton.sd_layout.rightSpaceToView(self.contentView, 75).bottomSpaceToView(self.contentView, 5).widthIs(55).heightIs(30);

    self.undercarriageButton.sd_layout.rightSpaceToView(self.contentView, 10).bottomSpaceToView(self.contentView, 5).widthIs(55).heightIs(30);
    
    self.underButton.sd_layout.rightSpaceToView(self.contentView, 10).bottomSpaceToView(self.contentView, 5).widthIs(55).heightIs(30);

}

- (void)cellViewsValueWithModel:(RightDataModel *)model{
    
    [self.foodImageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:@"userName"]];
    self.foodNameLable.text = model.name;
    self.priceLable.text = [NSString stringWithFormat:@"%@",model.sellPrice];
 //   self.activityPrice.text = [NSString stringWithFormat:@"%@",model.sellPrice];
    NSString *textStr = [NSString stringWithFormat:@"￥%@",model.activityPrice];
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:textStr attributes:attribtDic];
    self.activityPrice.attributedText = attribtStr;
    
    if ([model.status integerValue] == 3) {
        [self.undercarriageButton setHidden:NO];
        [self.underButton setHidden:YES];
    }else if ([model.status integerValue] == 2){
        [self.undercarriageButton setHidden:YES];
        [self.underButton setHidden:NO];
    }
    if (_editorButton.tag == 500) {
        [self.editorButton setHidden:NO];
    }
    
}

- (UIImageView *)foodImageView{
    
    if (!_foodImageView) {
        _foodImageView = [[UIImageView alloc]init];
        _foodImageView.layer.cornerRadius = 5;
        _foodImageView.layer.masksToBounds = YES;
    }
    return _foodImageView;
}

- (UILabel *)foodNameLable{
    
    if (!_foodNameLable) {
        _foodNameLable = [[UILabel alloc]init];
        _foodNameLable.font = [UIFont systemFontOfSize:13];
    }
    return _foodNameLable;
}

- (UILabel *)priceImageLable{
    
    if (!_priceImageLable) {
        _priceImageLable = [UILabel new];
        _priceImageLable.font = [UIFont systemFontOfSize:15];
        _priceImageLable.textColor = kColor(255, 129, 61);
        _priceImageLable.text = [NSString stringWithFormat:@"￥"];
    }
    return _priceImageLable;
}
- (UILabel *)priceLable{
    
    if (!_priceLable) {
        _priceLable = [UILabel new];
        _priceLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        _priceLable.textColor = kColor(255, 129, 61);
        
    }
    return _priceLable;
}

- (UILabel *)activityPrice{
    if (!_activityPrice) {
        _activityPrice = [UILabel new];
        _activityPrice.font = [UIFont systemFontOfSize:13];
        _activityPrice.textColor = kColor(153, 153, 153);
    }
    return _activityPrice;
}

- (UIButton *)editorButton {
    
    if (!_editorButton) {
        _editorButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_editorButton.layer setCornerRadius:5.0];
        [_editorButton.layer setBorderWidth:1.0];
        [_editorButton setTag:500];
        [_editorButton.layer setBorderColor:kColor(255, 210, 0).CGColor];
        [_editorButton setTitle:@"编辑" forState:UIControlStateNormal];
        [_editorButton addTarget:self action:@selector(RightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _editorButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _editorButton.tintColor = [UIColor blackColor];
    }
    return _editorButton;
}

- (UIButton *)undercarriageButton {
    
    if (!_undercarriageButton) {
        _undercarriageButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_undercarriageButton.layer setCornerRadius:5.0];
    //    [_undercarriageButton.layer setBorderWidth:1.0];
        [_undercarriageButton setTag:600];
     //   [_undercarriageButton.layer setBorderColor:kColor(255, 210, 0).CGColor];
        [_undercarriageButton setTitle:@"上架" forState:UIControlStateNormal];
        [_undercarriageButton addTarget:self action:@selector(RightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _undercarriageButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _undercarriageButton.tintColor = [UIColor blackColor];
    }
    return _undercarriageButton;
}

- (UIButton *)underButton {
    
    if (!_underButton) {
        _underButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_underButton.layer setCornerRadius:5.0];
    //    [_underButton.layer setBorderWidth:1.0];
        [_underButton setTag:700];
     //   [_underButton.layer setBorderColor:[UIColor yellowColor].CGColor];
        [_underButton setTitle:@"下架" forState:UIControlStateNormal];
        [_underButton addTarget:self action:@selector(RightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_underButton setBackgroundColor:kColor(255, 210, 0)];
        _underButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _underButton.tintColor = [UIColor whiteColor];
    }
    return _underButton;
}

- (void)RightButtonAction:(UIButton *)sender{
    
    _block(_index, sender.tag);
    
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
