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

@interface CountyDeputyMapViewController : UIViewController
    <MKMapViewDelegate, LocationControllerDelegate, 
    UIPopoverControllerDelegate, 
    UITableViewDelegate, UITableViewDataSource, 
    UINavigationControllerDelegate> {
    // we keep a single person profile vc for reuse the view.
    DeputyProfileViewController* singleProfileViewController;
    
    NSMutableArray *popoverDataHolder;
    NSInteger nomineesGroupingLevel;
    
    UIPopoverController *areaSelectPopup;
}

@property(nonatomic, retain) DeputyProfileViewController* singleProfileViewController;

@property(nonatomic, retain) NSMutableArray *popoverDataHolder;

@property(nonatomic, retain) UIPopoverController *areaSelectPopup;

@property(nonatomic) NSInteger nomineesGroupingLevel;

@end
