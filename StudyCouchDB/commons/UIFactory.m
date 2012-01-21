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
    UITextField *t = [[UITextField alloc]initWithFrame:CGRectMake(100, 30, 150, 40)];
    t.placeholder = p;
    t.font = [UIFont systemFontOfSize:18.0];
    t.textColor = [UIColor blackColor];
    t.tag = tagging;
    return [t autorelease];
}

// TODO: make an UI control combined of a label and textfield



@end
