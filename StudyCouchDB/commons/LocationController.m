//
//  LocationController.m
//  StudyCouchDB
//
//  a convenience method that just gets the current location, once, 
//  REF: http://stackoverflow.com/questions/459355/whats-the-easiest-way-to-get-the-current-location-of-an-iphone
//  License info not speficied, follow Stackoverflow.com agreement!
// 
//  another similar implementation
//  REF: http://jinru.wordpress.com/2010/08/15/singletons-in-objective-c-an-example-of-cllocationmanager/
//  License info not speficied.
// 
//  Created by realalien on 12-2-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

#import "LocationController.h"
#import "CLLocationManager+TemporaryHack.h"


@implementation LocationController

@synthesize currentLocation;
@synthesize locationManager;
@synthesize delegate;


static LocationController *sharedInstance;

+ (LocationController *)sharedInstance {
    @synchronized(self) {
        if (!sharedInstance)
            sharedInstance=[[LocationController alloc] init];       
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone{
    return self;
}

- (id)retain{
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}


+(id)alloc {
    @synchronized(self) {
        NSAssert(sharedInstance == nil, @"Attempted to allocate a second instance of a singleton LocationController.");
        sharedInstance = [super alloc];
    }
    return sharedInstance;
}

-(id) init {
    if (self = [super init]) {
        self.currentLocation = [[CLLocation alloc] init];
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        [self start];
    }
    return self;
}

- (void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}



-(void) start {
    [locationManager startUpdatingLocation];
}

-(void) stop {
    [locationManager stopUpdatingLocation];
}

-(BOOL) locationKnown { 
    if (round(currentLocation.speed) == -1) return NO; else return YES; 
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    //if the time interval returned from core location is more than two minutes we ignore it because it might be from an old session
    
    // TODO: choose one of the following.
    if ( abs([newLocation.timestamp timeIntervalSinceDate: [NSDate date]]) < 120) {     
        self.currentLocation = newLocation;
    }
    
    [self.delegate locationUpdate:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

-(void) dealloc {
    [locationManager release];
    [currentLocation release];
    [super dealloc];
}


@end
