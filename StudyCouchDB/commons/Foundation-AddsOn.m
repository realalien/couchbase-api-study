//
//  UIKit-AddsOn.m
//  StudyCouchDB
//
//  Created by d d on 12-1-29.
//  Copyright (c) 2012年 d. All rights reserved.
//

#import "Foundation-AddsOn.h"


#pragma mark -
#pragma NSString extension

@implementation NSString(private)

-(BOOL)isNotEmpty{
    NSString *trimmedString = [self stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([trimmedString isEqualToString:@"" ]) {
        return NO;
    }else{
        return YES;
    }
}

-(BOOL)isALink{
    return YES;
}

-(BOOL)isValidHumanName{
    return NO;
}




@end 


#pragma mark -

@implementation NSObject (private)

// mainly used by CouchbaseServerManager et al. NOTE: copied from CouchDemo project.
- (void)showAlert: (NSString*)message error: (NSError*)error fatal: (BOOL)fatal{
    if (error) {
        message = [NSString stringWithFormat: @"%@\n\n%@", message, error.localizedDescription];
    }
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle: (fatal ? @"Fatal Error" : @"Error")
                                                    message: message
                                                   delegate: (fatal ? self : nil)
                                          cancelButtonTitle: (fatal ? @"Quit" : @"Sorry")
                                          otherButtonTitles: nil];
    [alert show];
    [alert release];
    
}

- (void)showAlert: (NSString*)aMessage tag:(NSInteger)tag {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"消息"
                                                    message:aMessage 
                                                   delegate:self 
                                          cancelButtonTitle:@"确定" 
                                          otherButtonTitles:nil, nil]; 
    alert.tag = tag;
    [alert show];
    [alert release];
    
}


- (void)showAlert: (NSString*)aMessage{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"消息"
                                                    message:aMessage 
                                                   delegate:self 
                                          cancelButtonTitle:@"确定" 
                                          otherButtonTitles:nil, nil]; 
    [alert show];
    [alert release];
}

@end






@implementation UIKit_AddsOn

@end
