//
//  LocationController.h
//  StudyCouchDB
//
//  Created by realalien on 12-2-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol LocationControllerDelegate <NSObject>
@required
- (void)locationUpdate:(CLLocation*)location;
@end

@interface  LocationController : NSObject <CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    id delegate;
}

+ (LocationController *)sharedInstance;

-(void) start;
-(void) stop;
-(BOOL) locationKnown;

@property (nonatomic, retain) CLLocation *currentLocation;
@property (nonatomic, assign) id <LocationControllerDelegate> delegate;
@property (nonatomic, retain) CLLocationManager* locationManager;

@end
