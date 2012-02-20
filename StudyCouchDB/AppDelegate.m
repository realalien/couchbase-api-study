//
//  AppDelegate.m
//  StudyCouchDB
//
//  Created by realalien on 11-12-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "MapViewController.h"
#import "CountyDeputyMapViewController.h"

#import "TraderAlikeViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize navController = _navController;

@synthesize viewController = _viewController;

- (void)dealloc
{
    [_window release];
    [_navController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];

//    // Couchbase database setup
//    CouchbaseMobile* cb = [[CouchbaseMobile alloc] init];
//    cb.delegate = self;
//    NSAssert([cb start], @"Couchbase didn't start: Error = %@", cb.error);
    
    // Override point for customization after application launch.
    
    // -----------------  single view based ------------
    
    // --- TraderAlikeView  test 
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.viewController = [[[TraderAlikeViewController alloc] initWithNibName:@"TraderAlikeView" bundle:nil]autorelease] ; 
    self.window.rootViewController = self.viewController;
    
    
    // -----------------  nav view based ------------- 
//    self.navController = [[UINavigationController alloc] initWithNibName:nil bundle:nil];
//    self.navController.view.backgroundColor = [UIColor whiteColor];
//    self.window.rootViewController = self.navController;
//    
//    
//    // TEMP
////    MapViewController *mapVC = [[MapViewController alloc]init ];
//    CountyDeputyMapViewController *cdMapVc = [[CountyDeputyMapViewController alloc]init];
//    //    AddNewDeputyViewController *addDeputyVc = [[AddNewDeputyViewController alloc]init]; 
//
////    self.navController.view = mapVC.view;
//    [self.navController pushViewController:cdMapVc animated:YES];
    
    // ----------------------------------------------
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

//#pragma mark -
//#pragma mark CouchbaseDelegate methods
//
//-(void)couchbaseMobile:(CouchbaseMobile*)couchbase didStart:(NSURL*)serverURL{
//    NSLog(@"Couchbase is Ready, go! %@", serverURL);
//}
//
//-(void)couchbaseMobile:(CouchbaseMobile *)couchbase failedToStart:(NSError *)error{
//    NSLog(@"Couchbase failed to start! %@", [error localizedDescription]);
//}


@end
