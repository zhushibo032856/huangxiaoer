//
//  RecommendedGalleryViewController.h
//  HuangXiaoErShop
//
//  Created by apple on 2018/12/24.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^imageUrlBlock)(NSString *imgUrl);

@interface RecommendedGalleryViewController : BaseViewController

@property (nonatomic, strong) NSString *nameString;
@property (nonatomic, strong) imageUrlBlock block;

@end
