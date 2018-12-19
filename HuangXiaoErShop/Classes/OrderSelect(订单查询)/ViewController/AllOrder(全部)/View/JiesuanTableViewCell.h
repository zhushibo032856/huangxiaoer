//
//  JiesuanTableViewCell.h
//  HuangXiaoErShop
//
//  Created by apple on 2018/12/13.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JiesuanModel.h"

@interface JiesuanTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLable;
@property (weak, nonatomic) IBOutlet UILabel *incomeLable;

- (void)setValueWith:(JiesuanModel *)model;
@end
