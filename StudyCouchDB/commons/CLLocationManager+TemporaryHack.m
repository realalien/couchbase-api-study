//
//  CLLocationManager+TemporaryHack.m
//  StudyCouchDB
//
//  Created by realalien on 12-2-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CLLocationManager+TemporaryHack.h"


// TODO: move out to a single file!
// Unconfirmed fix for error: server did not accept client registration 
// REF: http://forums.bignerdranch.com/viewtopic.php?f=79&t=2069
@implementation CLLocationManager (TemporaryHack)

- (void)hackLocationFix
{
    CLLocation *location = [[CLLocation alloc] initWithLatitude:42 longitude:-50];
    [[self delegate] locationManager:self didUpdateToLocation:location fromLocation:nil];     
}

- (void)startUpdatingLocation
{
    [self performSelector:@selector(hackLocationFix) withObject:nil afterDelay:0.1];
}

@end