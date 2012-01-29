//
//  AppDelegate.h
//  StudyCouchDB
//
//  Created by realalien on 11-12-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Couchbase/CouchbaseMobile.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>  // CouchbaseDelegate

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navController;

@end
