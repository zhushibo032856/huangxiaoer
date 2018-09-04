//
//  MyMachineTableViewCell.h
//  HuangXiaoErShop
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MachinesModel;

@interface MyMachineTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *categoryImageView;
@property (nonatomic, strong) UILabel *categoyrLable;
@property (nonatomic, strong) UILabel *connectedLable;//已连接按钮

- (void)setDataForCellWithModel: (MachinesModel *)model;

@end
