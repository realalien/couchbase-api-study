//
//  UIKit-AddsOn.h
//  StudyCouchDB
//
//  Created by d d on 12-1-29.
//  Copyright (c) 2012年 d. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (private)
-(BOOL)isValidHumanName;
// Test if a string is empty or not after removing the blankspaces.
-(BOOL)isNotEmpty;
@end




@interface NSObject (private)   
// mainly used by CouchbaseServerManager et al. NOTE: copied from CouchDemo project.
- (void)showAlert: (NSString*)message error: (NSError*)error fatal: (BOOL)fatal;

- (void)showAlert: (NSString*)aMessage tag:(NSInteger)tag;
- (void)showAlert: (NSString*)aMessage;
@end


@interface UIKit_AddsOn : NSObject

@end
