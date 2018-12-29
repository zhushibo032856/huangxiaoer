//
//  NoneDataTableViewCell.h
//  HuangXiaoErShop
//
//  Created by apple on 2018/12/25.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoneDataTableViewCell : UITableViewCell

/**
 没有数据展示的cell
 
 @param imageName 图片名称
 @param tips 提示语
 */
- (void)showNoDataWithImgurl:(NSString *)imageName
                andTipString:(NSString *)tips;

@end
