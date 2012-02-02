//
//  UIFactory.m
//  StudyCouchDB
//
//  Created by d d on 12-1-13.
//  Copyright (c) 2012年 d. All rights reserved.
//

#import "UIFactory.h"

@implementation UIFactory



+(UILabel*) makeDefaultLabelWithText:(NSString*)humanText andTag:(int)tagging {
    UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 80, 40)];
    l.backgroundColor = [UIColor clearColor];
    l.font = [UIFont systemFontOfSize:18.0];
    l.text = humanText;
    l.tag = tagging ;
    
    return [l autorelease];
}

// TODO: why the textfield is not aligned with uilabel that with the same height and y position?
+(UITextField*) makeDefaultTextFieldWithPlaceholder:(NSString*)p andTag:(int)tagging{
    UITextField *t = [[UITextField alloc]initWithFrame:CGRectMake(100, 30, 150, 50)];
    t.placeholder = p;
    t.font = [UIFont systemFontOfSize:18.0];
    t.textColor = [UIColor blackColor];
    t.tag = tagging;
    return [t autorelease];
}

// TODO: allow change on device rotating, 
// TODO: allow width adjustable.
+(UIScrollView*) makeHalfScreenRightScrollView{
    // FIXME: hardcoded width.
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake( 1024 / 2, 0, 1024 / 2, 768)];
    return [scrollView autorelease];
}

// TODO: make an UI control combined of a label and textfield

// 
// Note: from previous experience, this only works for normal flow of texts
//       for text/labels with line break, please calculate by yourself!
+(CGFloat) estimateHeightFromText:(NSString*)text withFont:(UIFont*)font withAllowedWidth:(float)width lineBreakMode:(UILineBreakMode)mode {
    CGSize withinSize = CGSizeMake(width, FLT_MAX); 
    CGSize size = [text sizeWithFont:font constrainedToSize:withinSize lineBreakMode:mode];
    return size.height;
}

+(CGFloat) estimateWidthFromText:(NSString*)text withFont:(UIFont*)font withAllowedHeight:(float)height lineBreakMode:(UILineBreakMode)mode {
    CGSize withinSize = CGSizeMake(FLT_MAX, height); 
    CGSize size = [text sizeWithFont:font constrainedToSize:withinSize lineBreakMode:mode];
    return size.width;
}

@end
