//
//  HeadView.h
//  zhedie
//
//  Created by Apple on 2018/3/4.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadView : UIView

@property (weak, nonatomic) IBOutlet UIButton *Bt;

+ (instancetype)SetHeadView;
@property (weak, nonatomic) IBOutlet UILabel *statusLb;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UIImageView *TypeImageView;

@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *xunxuLb;

@end
