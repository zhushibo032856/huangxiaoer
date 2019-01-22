//
//  HeadTableViewCell.h
//  HuangXiaoErShop
//
//  Created by apple on 2019/1/21.
//  Copyright © 2019年 aladdin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HeadTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *TypeImage;

@property (weak, nonatomic) IBOutlet UILabel *NameLable;

@property (weak, nonatomic) IBOutlet UILabel *HeadLable;

@end

NS_ASSUME_NONNULL_END
