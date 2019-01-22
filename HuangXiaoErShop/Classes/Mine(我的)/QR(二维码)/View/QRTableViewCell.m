//
//  QRTableViewCell.m
//  HuangXiaoErShop
//
//  Created by apple on 2019/1/21.
//  Copyright © 2019年 aladdin. All rights reserved.
//

#import "QRTableViewCell.h"

@implementation QRTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setDataForCellWithModel:(QRModel *)model{
    self.NumberLable.text = model.machineNum;
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
