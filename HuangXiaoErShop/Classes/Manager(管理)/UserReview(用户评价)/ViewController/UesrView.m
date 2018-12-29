//
//  UesrView.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/12/27.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "UesrView.h"

@implementation UesrView

+ (instancetype)SetHeadView {
    return [[[NSBundle mainBundle] loadNibNamed:@"UserView" owner:nil options:nil] firstObject];
}
- (void)headViewSetDataWith:(UserReviewModel *)model{
    self.userImage.layer.masksToBounds = YES;
    self.userImage.layer.cornerRadius = 25;
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.userImage]] placeholderImage:[UIImage imageNamed:@"userName"]];
    
    if (kStringIsEmpty(model.nickName)) {
        self.nameLable.text = @"匿名用户";
    }else{
        self.nameLable.text = model.nickName;
    }
    
    if (kStringIsEmpty(model.phone)) {
        self.phoneLable.text = @"*************";
    }else{
        self.phoneLable.text = [[NSString stringWithFormat:@"%@",model.phone]stringByReplacingCharactersInRange:NSMakeRange(3, 5) withString:@"*****"];
    }
    self.timeLable.text = [[NSString stringWithFormat:@"%@",model.createTime]substringWithRange:NSMakeRange(0, 10)];
    self.contentLable.text = model.content;

    
}

@end
