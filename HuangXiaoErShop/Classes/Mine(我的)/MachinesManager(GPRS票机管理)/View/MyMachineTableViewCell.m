//
//  MyMachineTableViewCell.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "MyMachineTableViewCell.h"
#import "MachinesModel.h"

@implementation MyMachineTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatAutoLayout];
    }
    return self;
}

- (void)creatAutoLayout{
    
    self.categoryImageView.frame = CGRectMake(10, 5, 40, 40);
    self.categoyrLable.frame = CGRectMake(CGRectGetMaxX(self.categoryImageView.frame) + 10, 10, 150, 30);
    self.connectedLable.frame = CGRectMake(kScreenWidth * 0.8 , 10, kScreenWidth * 0.15, 30);
    
    
    [self.contentView addSubview:self.categoryImageView];
    [self.contentView addSubview:self.categoyrLable];
    [self.contentView addSubview:self.connectedLable];
    
    
}

- (void)setDataForCellWithModel:(MachinesModel *)model{
    
    //  if ([model.type isEqualToString:@"GP"]) {
    
    [self.categoryImageView setImage:[UIImage imageNamed:@"gprsMachines"]];
    
    if ([model.name isEqualToString:@"HC"]) {
        
        self.categoyrLable.text = @"GPRS票机 (后厨)";
    }else{
        self.categoyrLable.text = @"GPRS票机 (收银)";
    }
    
    // }
    if ([model.printersStatus isEqualToString:@"离线"]) {
        self.connectedLable.text = @"离线";
        self.connectedLable.textColor = [UIColor grayColor];
    }else{
        self.connectedLable.text = @"在线";
        self.connectedLable.textColor = [UIColor greenColor];
    }
    return;
    
}


- (UIImageView *)categoryImageView{
    if (!_categoryImageView) {
        _categoryImageView = [[UIImageView alloc]init];
        //  _categoryImageView.backgroundColor = [UIColor redColor];
    }
    return _categoryImageView;
}

- (UILabel *)categoyrLable{
    
    if (!_categoyrLable) {
        _categoyrLable = [[UILabel alloc]init];
        // _categoyrLable.backgroundColor = [UIColor blueColor];
    }
    return _categoyrLable;
}

- (UILabel *)connectedLable{
    
    if (!_connectedLable) {
        _connectedLable = [[UILabel alloc]init];
        _connectedLable.textAlignment = NSTextAlignmentCenter;
        //   _connectedLable.backgroundColor = [UIColor yellowColor];
    }
    return _connectedLable;
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
