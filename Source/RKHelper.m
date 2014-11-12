//
//  RKHelper.m
//  RKInputAccessoryView
//
//  Created by Renat on 22.10.14.
//  Copyright (c) 2014 Softeam. All rights reserved.
//

#import "RKHelper.h"

@implementation NSString (Utils)
- (CGSize)sizeForStringWithFont:(UIFont *)font constrainedToSize:(CGSize)size {
    CGSize boundingSize = size;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    
    NSDictionary *attributes = @{ NSFontAttributeName: font, NSParagraphStyleAttributeName : paragraphStyle };
    
    CGRect contentRect = [self boundingRectWithSize:boundingSize
                                            options:(NSStringDrawingUsesLineFragmentOrigin)
                                         attributes:attributes
                                            context:NULL];
    CGSize contentSize = CGSizeMake(ceilf(contentRect.size.width), ceilf(contentRect.size.height));
    
    return contentSize;
}
@end;