//
//  BirthdayView.m
//  TravelWithPetApp
//
//  Created by 吕亚斌 on 2018/4/10.
//  Copyright © 2018年 吕亚斌. All rights reserved.
//

#import "BirthdayView.h"

#import "LVDateHelper.h"

@interface BirthdayView ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *birthdayLabel;
@property (nonatomic, strong) LVDatePickerView *birthdayView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) LVDatePickerModel *timeModel;
@end
@implementation BirthdayView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.birthdayLabel];
        [self.bgView addSubview:self.birthdayView];
        [self.bgView addSubview:self.cancelBtn];
        [self.bgView addSubview:self.sureBtn];
        __weak typeof(self)weakSelf = self;
        self.birthdayView.timeBlock = ^(LVDatePickerModel *timeModel) {
            weakSelf.timeModel = timeModel;
            [weakSelf birthLabelText];
        };
    }
    return self;
}
- (instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).priority(200);//设置优先级 这个优先级低
        make.center.equalTo(self);
        make.width.mas_greaterThanOrEqualTo(300).priority(1000);//优先级设置为最高
        make.height.equalTo(self.bgView).multipliedBy(1);
    }];
    [self.birthdayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.bgView);
        make.height.mas_equalTo(100);
    }];
    [self.birthdayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.top.equalTo(self.birthdayLabel.mas_bottom);
        make.bottom.equalTo(self.cancelBtn.mas_top);
    }];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-8);
        make.bottom.equalTo(self.bgView).offset(-14);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.sureBtn);
        make.centerY.equalTo(self.sureBtn);
        make.right.equalTo(self.sureBtn.mas_left).offset(-24);
    }];
}
- (void)showBirthView{
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}
- (void)dismiss{
    [self removeFromSuperview];
}
- (void)birthLabelText{
    NSString *bir = [NSString stringWithFormat:@"%@年%@月%@日",self.timeModel.year,self.timeModel.month,self.timeModel.day];
    
    //字间距
     NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *dicr = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f};
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:bir attributes:dicr];
    [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(0, bir.length)];
    [att addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:24] range:NSMakeRange(0, self.timeModel.year.length)];
    [att addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:24] range:NSMakeRange(self.timeModel.year.length + 1, self.timeModel.month.length)];
    [att addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:24] range:NSMakeRange(bir.length - 1 - self.timeModel.day.length, self.timeModel.day.length)];
    self.birthdayLabel.attributedText = att;
}
#pragma mark --action
- (void)cancelBtnClick{
    [self dismiss];
}
- (void)sureBtnClick{
    if (self.timeBlock) {
        self.timeBlock(self.timeModel);
    }
    [self dismiss];
}
#pragma mark --setter
- (void)setBirthDay:(LVDatePickerModel *)birthDay{
    if (!birthDay) {
        birthDay = [[LVDatePickerModel alloc] initWithLVDate:[LVDateHelper fetchLocalDate]];
    }
    _birthDay = birthDay;
    self.timeModel = birthDay;
    [self birthLabelText];
    self.birthdayView.scrollToDate = [LVDateHelper fetchDateFromString:[NSString stringWithFormat:@"%@-%@-%@",birthDay.year,birthDay.month,birthDay.day] withFormat:@"yyyy-MM-dd"];
     [self.birthdayView loadDataSouce];
}
#pragma mark --getter
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 5;
        _bgView.clipsToBounds = YES;
    }
    return _bgView;
}
- (UILabel *)birthdayLabel{
    if (!_birthdayLabel) {
        _birthdayLabel = [[UILabel alloc] init];
        _birthdayLabel.backgroundColor = [UIColor colorWithHexString:@"#FFD200"];
//        _birthdayLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _birthdayLabel;
}
- (LVDatePickerView *)birthdayView{
    if (!_birthdayView) {
        _birthdayView = [[LVDatePickerView alloc] init];
        _birthdayView.defailtLimitedMaxDate = [LVDateHelper fetchLocalDate];
        _birthdayView.backgroundColor = [UIColor whiteColor];
    }
    return _birthdayView;
}
- (UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor colorWithHexString:@"#FFD200"] forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}
- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (void)dealloc{
 //   NSLog(@"时间选择器的view释放了");
}

@end
