//
//  XJWTextView.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/12/27.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "XJWTextView.h"
#define MaxTextViewHeight 80
#define KscreenBounds [UIScreen mainScreen].bounds

@interface XJWTextView()<UITextViewDelegate,UIScrollViewDelegate>
{
    BOOL statusTextView;//当文字大于限定高度之后的状态
    NSString *placeholderText;
}

@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, strong) UILabel *placeholderLable;
@property (nonatomic, strong) UIButton *sendButton;

@end

@implementation XJWTextView

- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length == 0) {
        self.placeholderLable.text = placeholderText;
        [self.sendButton setBackgroundColor:kColor(180, 180, 180)];
        self.sendButton.userInteractionEnabled = NO;
    }else{
        self.placeholderLable.text = nil;
        [self.sendButton setBackgroundColor:kColor(70, 163, 231)];
        self.sendButton.userInteractionEnabled = YES;
    }
    
    CGSize size = CGSizeMake(kScreenWidth - 65, MaxTextViewHeight);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil];
    
    CGFloat curheight = [textView.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size.height;
    
    CGFloat y = CGRectGetMaxY(self.backGroundView.frame);
    if (curheight < 19.894) {
        statusTextView = NO;
        self.backGroundView.frame = CGRectMake(0, y - 49, kScreenWidth, 49);
    }else if (curheight < MaxTextViewHeight){
        statusTextView = NO;
        self.backGroundView.frame = CGRectMake(0, y - textView.contentSize.height - 10, kScreenWidth, textView.contentSize.height + 10);
    }else{
        statusTextView = YES;
        return;
    }
    
}

#pragma mark  UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (statusTextView == NO) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }else{
        
    }
}

- (void)setPlaceholderText:(NSString *)text{
    placeholderText = text;
    self.placeholderLable.text = placeholderText;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self addConstraint];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    /*
     点击空白区域取消
     */
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [self addGestureRecognizer:tap];
    return self;
}


- (void)addConstraint{
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backGroundView).offset(6);
        make.left.equalTo(self.backGroundView).offset(5);
        make.bottom.equalTo(self.backGroundView).offset(-6);
        make.width.mas_equalTo(kScreenWidth - 65);
    }];
    [self.placeholderLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backGroundView).offset(5);
        make.left.equalTo(self.backGroundView).offset(10);
        make.height.mas_equalTo(39);
    }];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backGroundView).offset(8);
        make.right.equalTo(self.backGroundView).offset(-5);
        make.width.mas_equalTo(50);
    }];
    
}


- (void)keyboardWillShow:(NSNotification *)aNotification{
    
    self.frame = KscreenBounds;
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    CGFloat height = keyboardRect.size.height;
    if (self.textView.text.length == 0) {
        self.backGroundView.frame = CGRectMake(0, kScreenHeight - height - self.backGroundView.frame.size.height, kScreenWidth, 49);
    }else{
        CGRect rect = CGRectMake(0, kScreenHeight - self.backGroundView.frame.size.height - height, kScreenWidth, self.backGroundView.frame.size.height);
        self.backGroundView.frame = rect;
    }
}

- (void)keyboardWillHide:(NSNotification *)aNotification{
    
    if (self.textView.text.length == 0) {
        self.backGroundView.frame = CGRectMake(0, 0, kScreenWidth, 49);
        self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 49);
    }else{
        CGRect rect = CGRectMake(0, 0, kScreenWidth, self.backGroundView.frame.size.height);
        self.backGroundView.frame = rect;
        self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, self.backGroundView.frame.size.height);
    }
    
}

- (void)tapClick{
    [self.textView resignFirstResponder];
}

- (void)sendClick:(UIButton *)sender{
    
    [self.textView endEditing:YES];
    if (self.TextBlcok) {
        self.TextBlcok(self.textView.text);
    }
    self.textView.text = nil;
    self.placeholderLable.text = placeholderText;
    [self.sendButton setBackgroundColor:kColor(180, 180, 180)];
    self.sendButton.userInteractionEnabled = NO;
    
    self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 49);
    self.backGroundView.frame = CGRectMake(0, 0, kScreenWidth, 49);
}

- (UIView *)backGroundView{
    if (!_backGroundView) {
        _backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 49)];
        _backGroundView.backgroundColor = kColor(240, 240, 240);
        [self addSubview:_backGroundView];
    }
    return _backGroundView;
}

- (UITextView *)textView{
    
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.delegate = self;
        _textView.layer.cornerRadius = 5;
        _textView.layer.masksToBounds = YES;
        [self.backGroundView addSubview:_textView];
    }
    return _textView;
}

- (UILabel *)placeholderLable{
    if (!_placeholderLable) {
        _placeholderLable = [[UILabel alloc]init];
        _placeholderLable.font = [UIFont systemFontOfSize:16];
        _placeholderLable.textColor = [UIColor lightGrayColor];
        [self.backGroundView addSubview:_placeholderLable];
    }
    return _placeholderLable;
}

- (UIButton *)sendButton{
    
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setBackgroundColor:kColor(180, 180, 180)];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTintColor:kColor(255, 255, 255)];
        [_sendButton addTarget:self action:@selector(sendClick:) forControlEvents:UIControlEventTouchUpInside];
        _sendButton.layer.masksToBounds = YES;
        _sendButton.layer.cornerRadius = 5;
        _sendButton.userInteractionEnabled = NO;
        [self.backGroundView addSubview:_sendButton];
    }
    return _sendButton;
}


@end
