//
//  CustomTableViewCell.h
//  HuangXiaoErShop
//
//  Created by apple on 2018/12/18.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellModel.h"

@interface CustomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *priceLable;

@end
