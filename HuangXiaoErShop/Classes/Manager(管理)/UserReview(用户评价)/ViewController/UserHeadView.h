//
//  UserHeadView.h
//  HuangXiaoErShop
//
//  Created by apple on 2018/12/27.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserReviewModel.h"

@interface UserHeadView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *phoneLable;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;

@property (weak, nonatomic) IBOutlet UIButton *reviewButton;

+ (instancetype)SetHeadView;
- (void)headViewSetDataWith:(UserReviewModel *)model;
@end
