//
//  AutoExpandingTextView.m
//  ParadoxLogic
//
//  Created by renat on 23.10.13.
//  Copyright (c) 2013 Flatstack. All rights reserved.
//

#import "UIPlaceholderTextView.h"
@interface UIPlaceholderTextView()
@property (nonatomic, strong) UILabel *placeHolderLabel;
@end

@implementation UIPlaceholderTextView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    if( (self = [super initWithFrame:frame]) )
    {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    if (!self.placeholder) {
        [self setPlaceholder:@""];
    }
    
    if (!self.placeholderColor) {
        [self setPlaceholderColor:[UIColor lightGrayColor]];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidEndEditing:) name:UITextViewTextDidEndEditingNotification object:nil];
    
}

- (void)textBeginEditing:(NSNotification *)notification {
}

- (void)textChanged:(NSNotification *)notification
{
    if([[self placeholder] length] == 0)
    {
        return;
    }
    
    if([[self text] length] == 0)
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    else
    {
        [[self viewWithTag:999] setAlpha:0.0];
    }
}

- (void)textDidEndEditing:(NSNotification *)notification {
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self textChanged:nil];
}

- (void)drawRect:(CGRect)rect
{
    if( [[self placeholder] length] > 0 )
    {
        if (_placeHolderLabel == nil )
        {
            // on ios 7 placeholder label should start from 7px
            
            UIEdgeInsets textContainerInsets = self.textContainerInset;
            UIEdgeInsets contentInsets = self.contentInset;
            
            CGFloat left = textContainerInsets.left + self.textContainer.lineFragmentPadding + contentInsets.left;
            CGFloat right = textContainerInsets.right + self.textContainer.lineFragmentPadding + contentInsets.right;
            CGFloat width = self.frame.size.width - left - right;
            CGFloat top = textContainerInsets.top + contentInsets.top;
            CGFloat bottom = textContainerInsets.bottom + contentInsets.bottom;
            CGFloat height = self.frame.size.height - top - bottom;
            
            CGRect frame = CGRectMake(left, top, width, height);
            
            _placeHolderLabel = [[UILabel alloc] initWithFrame:frame];
            
            _placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            _placeHolderLabel.numberOfLines = 0;
            _placeHolderLabel.font = self.font;
            _placeHolderLabel.backgroundColor = [UIColor clearColor];
            _placeHolderLabel.textColor = self.placeholderColor;
            _placeHolderLabel.alpha = 0;
            _placeHolderLabel.tag = 999;
            [self addSubview:_placeHolderLabel];
        }
        
        _placeHolderLabel.text = self.placeholder;
        [_placeHolderLabel sizeToFit];
        [self sendSubviewToBack:_placeHolderLabel];
    }
    
    if( [[self text] length] == 0 && [[self placeholder] length] > 0 )
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    
    [super drawRect:rect];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
