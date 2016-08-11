//
//  ChatBarContainer.m
//  Hrland
//
//  Created by Tousan on 15/9/18.
//  Copyright (c) 2015年 Tousan. All rights reserved.
//

#import "ChatBarContainer.h"
#define kChatBarHeight

@implementation ChatBarContainer
{
    NSString *send_Str;
}

- (id)init;
{
    self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100)];
    if (self)
    {
        _isTextRequired = YES;
        _max_Count = 140;
        _txtView = [[ChatBarTextView alloc]init];
        _txtView.placeHolder = @"说点什么吧~";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
        [self addSubview:_txtView];
        self.backgroundColor = [UIColor whiteColor];
        _txtView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
        _txtView.layer.cornerRadius = 5;
        [_txtView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10);
            make.right.equalTo(self.mas_right).offset(-100);
            make.top.equalTo(self.mas_top).offset(5);
            CGRect textFrame=[[_txtView layoutManager]usedRectForTextContainer:[_txtView textContainer]];
            make.height.offset(textFrame.size.height+17);
        }];
        [_txtView layoutIfNeeded];
        CGRect self_Rect = self.frame;
        self_Rect.size.height = _txtView.frame.size.height+10;
        self.frame = self_Rect;
        _txtView.delegate = self;
        
        _send_Btn = [UIButton new];
        [self addSubview:_send_Btn];
        [_send_Btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_txtView.mas_right).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
            CGRect textFrame=[[_txtView layoutManager]usedRectForTextContainer:[_txtView textContainer]];
            make.height.offset(textFrame.size.height+17);
            make.bottom.equalTo(_txtView.mas_bottom);
        }];
        _send_Btn.layer.cornerRadius = 5;
        _send_Btn.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
        [_send_Btn setTitle:@"发送" forState:UIControlStateNormal];
        [_send_Btn addTarget:self action:@selector(clickSend) forControlEvents:UIControlEventTouchUpInside];
        _send_Btn.enabled = _isTextRequired?NO:YES;
        
        UIView *segline = [UIView new];
        [self addSubview:segline];
        [segline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.mas_top);
            make.height.offset(0.5);
        }];
        segline.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
        
        //监听键盘出现事件
        [[NSNotificationCenter defaultCenter]
         addObserver:self selector:@selector(keyboardWasShown)
         name:UIKeyboardWillShowNotification object:nil];
    }
    return self;
}

- (void)setIsTextRequired:(BOOL)isTextRequired;
{
    _isTextRequired = isTextRequired;
    if (!isTextRequired)
    {
        _send_Btn.enabled = YES;
        _send_Btn.layer.backgroundColor = [UIColor colorWithRed:28/255.0 green:106/255.0 blue:255/255.0 alpha:1].CGColor;
    }
}

- (void)keyboardWasShown
{
    _txtView.placeHolder = @"";
}

- (void)textViewDidChange:(UITextView *)textView;
{
    if ([textView positionFromPosition:[textView markedTextRange].start offset:0])
    {
        return;
    }
    send_Str = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    _send_Btn.enabled = _isTextRequired?(send_Str.length?YES:NO):YES;
    _send_Btn.layer.backgroundColor = _send_Btn.isEnabled?[UIColor colorWithRed:28/255.0 green:106/255.0 blue:255/255.0 alpha:1].CGColor:[UIColor lightGrayColor].CGColor;
    if (textView.text.length)
    {
        ChatBarTextView *txt_View = (ChatBarTextView*)textView;
        txt_View.placeHolder_Label.hidden = YES;
    }
    else
    {
        ChatBarTextView *txt_View = (ChatBarTextView*)textView;
        txt_View.placeHolder_Label.hidden = NO;
    }
    if (textView.text.length>_max_Count)
    {
        send_Str = [send_Str substringToIndex:_max_Count];
        textView.text = send_Str;
    }

    CGRect textFrame = [[_txtView layoutManager]usedRectForTextContainer:[_txtView textContainer]];
    if (textFrame.size.height<100)
    {
        [_txtView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(textFrame.size.height+17);
        }];
        [_txtView setNeedsDisplay];
        [_txtView layoutIfNeeded];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(_txtView.frame.size.height+10);
        }];
    }
}

- (void)keyboardWillChange:(NSNotification *)aNotification
{
    NSLog(@"Keyboard change");
    NSDictionary *info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.superview.mas_bottom).offset(-kbSize.height);
        }];
        [self layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    NSDictionary *info = [aNotification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.superview.mas_bottom);
        }];
        [self layoutIfNeeded];
        [self.superview layoutIfNeeded];
    }completion:^(BOOL finished) {
        if (_delegate && [_delegate respondsToSelector:@selector(chatBarDidEndEdit)])
        {
            [_delegate chatBarDidEndEdit];
        }
    }];
}
- (void)keyboardDidShow:(NSNotification *)aNotification
{
    if (_delegate && [_delegate respondsToSelector:@selector(chatBarDidBecomeActive)])
    {
        [_delegate chatBarDidBecomeActive];
    }
}

- (void)clickSend;
{
    if (_delegate && [_delegate respondsToSelector:@selector(clickSendWithContent:)])
    {
        [_delegate clickSendWithContent:send_Str];
    }
}

- (void)dealloc;
{
    [[NSNotificationCenter defaultCenter]removeObserver:self forKeyPath:UIKeyboardWillChangeFrameNotification];
    [[NSNotificationCenter defaultCenter]removeObserver:self forKeyPath:UIKeyboardWillHideNotification];
    [[NSNotificationCenter defaultCenter]removeObserver:self forKeyPath:UIKeyboardDidShowNotification];
}

@end
