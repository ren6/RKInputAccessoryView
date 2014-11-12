//
//  InputTextViewContainer.h
//  Heychat
//
//  Created by Renat on 17.10.14.
//  Copyright (c) 2014 Softeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RKInputAccessoryView : UIView

@property (nonatomic, strong, readonly) UITextView *textView;
@property (nonatomic, strong, readonly) UIButton *sendButton;

+ (instancetype)view;

@end
