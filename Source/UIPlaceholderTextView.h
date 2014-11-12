//
//  AutoExpandingTextView.h
//  ParadoxLogic
//
//  Created by renat on 23.10.13.
//  Copyright (c) 2013 Flatstack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPlaceholderTextView : UITextView

@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

@end
