//
//  ChatBarContainer.h
//  Hrland
//
//  Created by Tousan on 15/9/18.
//  Copyright (c) 2015年 Tousan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>
#import "ChatBarTextView.h"

@protocol ChatBarContainerDelegate <NSObject>

@optional
- (void)clickSendWithContent:(NSString*)content;
- (void)chatBarDidBecomeActive;
- (void)chatBarDidEndEdit;

@end

@interface ChatBarContainer : UIView <UITextViewDelegate>

@property(nonatomic,strong)ChatBarTextView *txtView;
@property(nonatomic,strong)UIButton *send_Btn;
@property(nonatomic,strong)id<ChatBarContainerDelegate>delegate;
@property(nonatomic,assign)int max_Count;
@property(nonatomic,assign)BOOL isTextRequired;

- (void)textViewDidChange:(UITextView *)textView;

@end
