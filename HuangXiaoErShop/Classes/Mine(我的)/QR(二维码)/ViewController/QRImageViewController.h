//
//  QRImageViewController.h
//  HuangXiaoErShop
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "BaseViewController.h"
@class QRModel;
@class ImageModel;

@interface QRImageViewController : BaseViewController

@property (nonatomic, strong) QRModel *model;

@property (nonatomic, strong) ImageModel *imageModel;

@end
