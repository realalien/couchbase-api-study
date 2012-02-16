//
//  CountyDeputyMapViewController.h
//  StudyCouchDB
//
//  Created by realalien on 12-1-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h> 

#import "DeputyProfileViewController.h"
#import "LocationController.h"

@interface CountyDeputyMapViewController : UIViewController<MKMapViewDelegate, LocationControllerDelegate, UIPopoverControllerDelegate> {
    // we keep a single person profile vc for reuse the view.
    DeputyProfileViewController* singleProfileViewController;
}

@property(nonatomic, retain) DeputyProfileViewController* singleProfileViewController;

@end
