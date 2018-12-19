//
//  SimpleMasonryCell.m
//  cell高度自适应内容
//
//  Created by 蔡强 on 2017/5/23.
//  Copyright © 2017年 kuaijiankang. All rights reserved.
//

#import "SimpleMasonryCell.h"
#import "Masonry.h"

@interface SimpleMasonryCell ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation SimpleMasonryCell

#pragma mark - 构造方法

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // UI搭建
        [self setUpUI];
    }
    return self;
}

#pragma mark - UI搭建
/** UI搭建 */
- (void)setUpUI {
    //------- 红色view -------//
    UIView *redView = [[UIView alloc] init];
    [self.contentView addSubview:redView];
    redView.backgroundColor = [UIColor redColor];
    
    //------- label -------//
    self.label = [[UILabel alloc] init];
    [self.contentView addSubview:self.label];
    self.label.font = [UIFont systemFontOfSize:20];
    self.label.numberOfLines = 0;
    
    //------- 绿色view -------//
    UIView *greenView = [[UIView alloc] init];
    [self.contentView addSubview:greenView];
    greenView.backgroundColor = [UIColor greenColor];
    
    //------- 建立约束 -------//
    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.contentView);
        make.height.mas_equalTo(30);
    }];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView);
        make.top.mas_equalTo(redView.mas_bottom);
    }];
    
    [greenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.label.mas_bottom);
        make.left.right.mas_equalTo(self.contentView); // bottom是关键点
        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(self.contentView); // bottom是关键点
    }];
}

#pragma mark - set model

- (void)setModel:(SimpleMasonryModel *)model {
    _model = model;
    
    self.label.text = _model.text;
}

@end
