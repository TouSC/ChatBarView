//
//  ChatBarTextField.m
//  Hrland
//
//  Created by Tousan on 15/9/18.
//  Copyright (c) 2015年 Tousan. All rights reserved.
//

#import "ChatBarTextView.h"

@implementation ChatBarTextView

- (id)init;
{
    self = [super init];
    if (self)
    {
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 1.0f;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.scrollIndicatorInsets = UIEdgeInsetsMake(10.0f, 0.0f, 10.0f, 8.0f);
        self.contentInset = UIEdgeInsetsZero;
        self.scrollEnabled = YES;
        self.scrollsToTop = NO;
        self.userInteractionEnabled = YES;
        self.font = [UIFont systemFontOfSize:16.0f];
        self.textColor = [UIColor blackColor];
        self.backgroundColor = [UIColor whiteColor];
        self.keyboardAppearance = UIKeyboardAppearanceDefault;
        self.keyboardType = UIKeyboardTypeDefault;
        self.returnKeyType = UIReturnKeyDefault;
        self.textAlignment = NSTextAlignmentLeft;
        self.delegate = self;
        
        _placeHolder_Label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 35)];
        _placeHolder_Label.textColor = [UIColor lightGrayColor];
        [self addSubview:_placeHolder_Label];
    }
    return self;
}

- (void)drawRect:(CGRect)rect;
{
    [super drawRect:rect];
    [self scrollRangeToVisible:NSMakeRange(0, 0)];
}

- (void)setPlaceHolder:(NSString *)placeHolder;
{
    _placeHolder_Label.text = placeHolder;
}

@end
