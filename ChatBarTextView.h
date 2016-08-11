//
//  ChatBarTextField.h
//  Hrland
//
//  Created by Tousan on 15/9/18.
//  Copyright (c) 2015年 Tousan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>

@interface ChatBarTextView : UITextView <UITextViewDelegate>

@property(nonatomic,strong)UILabel *placeHolder_Label;
@property(nonatomic,strong)NSString *placeHolder;

@end
