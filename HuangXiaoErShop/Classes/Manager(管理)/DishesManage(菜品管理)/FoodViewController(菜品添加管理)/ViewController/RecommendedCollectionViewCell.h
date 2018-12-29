//
//  RecommendedCollectionViewCell.h
//  HuangXiaoErShop
//
//  Created by apple on 2018/12/24.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendModel.h"

@interface RecommendedCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *pictureImage;

- (void)setPictureImageWith:(RecommendModel *)mode;

@end
