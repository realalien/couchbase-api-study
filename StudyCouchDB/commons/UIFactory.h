//
//  UIFactory.h
//  StudyCouchDB
//
//  Created by d d on 12-1-13.
//  Copyright (c) 2012年 d. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface UIFactory : NSObject

+(UILabel*) makeDefaultLabelWithText:(NSString*)humanText andTag:(int)tagging ;
+(UITextField*) makeDefaultTextFieldWithPlaceholder:(NSString*)p andTag:(int)tagging;

+(CGFloat) estimateHeightFromText:(NSString*)text withFont:(UIFont*)font withAllowedWidth:(float)width lineBreakMode:(UILineBreakMode)mode;
+(CGFloat) estimateWidthFromText:(NSString*)text withFont:(UIFont*)font withAllowedHeight:(float)height lineBreakMode:(UILineBreakMode)mode ;

@end
