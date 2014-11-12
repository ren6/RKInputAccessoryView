//
//  InputTextViewContainer.m
//  Heychat
//
//  Created by Renat on 17.10.14.
//  Copyright (c) 2014 Softeam. All rights reserved.
//

#import "RKInputAccessoryView.h"
#import "RKHelper.h"
#import "UIPlaceholderTextView.h"

#define MAX_TEXT_VIEW_HEIGHT ([UIScreen mainScreen].bounds.size.height < 481 ? (179.0f - 88.0f) : 179.0f)
#define MIN_TEXT_VIEW_HEIGHT 33.0f

@interface RKInputTextView : UIPlaceholderTextView
- (CGSize) sizeWithText:(NSString*)text;
@end

@interface RKInputAccessoryView()

@property (nonatomic, weak) IBOutlet UIButton *inputSendButton;
@property (nonatomic, weak) IBOutlet RKInputTextView *inputTextView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *textViewMaxHeightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *textViewMinHeightConstraint;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *thinLineHeightConstraint;

@end

@implementation RKInputAccessoryView
{
    BOOL _IOS7;
}
+ (instancetype)view
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _textView = self.inputTextView;
    _sendButton = self.inputSendButton;
    
    self.inputTextView.placeholder = NSLocalizedString(@"Add your comment", nil);
    
    [self bringSubviewToFront:self.inputTextView];
    self.textViewMaxHeightConstraint.constant = MAX_TEXT_VIEW_HEIGHT;
    self.textViewMinHeightConstraint.constant = MIN_TEXT_VIEW_HEIGHT;
    
    _IOS7 = ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 8.0);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChange:) name:UITextViewTextDidChangeNotification object:self.inputTextView];
    
    self.inputSendButton.layer.cornerRadius = 4.0f;
    self.inputSendButton.clipsToBounds = YES;
    self.clipsToBounds = NO;
    self.inputSendButton.enabled = YES;
}
- (void)didMoveToSuperview
{
    if (self.superview){
        
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSLayoutConstraint *constraintLeft = [NSLayoutConstraint constraintWithItem:self
                                                                      attribute:NSLayoutAttributeLeading
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.superview
                                                                      attribute:NSLayoutAttributeLeading
                                                                     multiplier:1.0f
                                                                       constant:0];
        
        NSLayoutConstraint *constraintRight = [NSLayoutConstraint constraintWithItem:self
                                                                      attribute:NSLayoutAttributeTrailing                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.superview
                                                                      attribute:NSLayoutAttributeTrailing
                                                                     multiplier:1.0f
                                                                       constant:0];
        [self.superview addConstraint:constraintLeft];
        [self.superview addConstraint:constraintRight];
    }
}

- (void)didChange:(NSNotification*)notif
{
    if (_IOS7)
    {
        [self invalidateIntrinsicContentSize];
        
        if ([_inputTextView.text hasSuffix:@"\n"]) {
            
            [CATransaction setCompletionBlock:^{
                [self scrollToCaretInTextView:_inputTextView animated:NO];
            }];
            
        } else {
            
            [self scrollToCaretInTextView:_inputTextView animated:NO];
        }
    }
    else
    {
        if (_inputTextView.scrollEnabled)
            [self invalidateIntrinsicContentSize];
    }
}
// helper method
- (void)scrollToCaretInTextView:(UITextView *)textView animated:(BOOL)animated
{
    CGRect rect = [textView caretRectForPosition:textView.selectedTextRange.end];
    rect.size.height += textView.textContainerInset.bottom;
    [textView scrollRectToVisible:rect animated:animated];
}
- (void)layoutSubviews
{
    if (_IOS7 && self.superview.frame.size.height > 200)
    {
        CGFloat newY = self.superview.frame.size.height - 216 - self.frame.size.height;
        CGRect frame = self.frame;
        frame.origin.y = newY;
        self.frame = frame;
    }
    
    [super layoutSubviews];
}

- (CGSize)intrinsicContentSize
{
    CGSize size = [_inputTextView sizeWithText:_inputTextView.text];
    
    if (size.height < MAX_TEXT_VIEW_HEIGHT)
    {
        if (self.inputTextView.scrollEnabled)
            [self.inputTextView invalidateIntrinsicContentSize];
    }
    
    return CGSizeZero;
}

@end

@implementation RKInputTextView
- (CGSize)intrinsicContentSize
{
    CGSize size = [self sizeWithText:self.text];
    
    if (size.height >= MAX_TEXT_VIEW_HEIGHT)
    {
        if (!self.scrollEnabled)
            self.scrollEnabled = YES;
        
        return CGSizeMake(self.frame.size.width, MAX_TEXT_VIEW_HEIGHT);
    }
    else
    {
        if (self.scrollEnabled)
            self.scrollEnabled = NO;
    }
    
    return CGSizeMake(self.frame.size.width, size.height);
}
- (CGSize) sizeWithText:(NSString*)text{
    CGRect frame = self.bounds;
    
    UIEdgeInsets textContainerInsets = self.textContainerInset;
    UIEdgeInsets contentInsets = self.contentInset;
    
    CGFloat leftRightPadding = textContainerInsets.left + textContainerInsets.right + self.textContainer.lineFragmentPadding * 2 + contentInsets.left + contentInsets.right;
    CGFloat topBottomPadding = textContainerInsets.top + textContainerInsets.bottom + contentInsets.top + contentInsets.bottom;
    
    frame.size.width -= leftRightPadding;
    frame.size.height -= topBottomPadding;
    
    if ([text hasSuffix:@"\n"])
    {
        text = [NSString stringWithFormat:@"%@-", text];
    }
    
    CGSize size = [text sizeForStringWithFont:self.font
                            constrainedToSize:CGSizeMake(CGRectGetWidth(frame), MAXFLOAT)];
    
    size.height += topBottomPadding;
    
    return size;
}
@end
