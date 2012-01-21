//
//  MapViewController.h
//  StudyCouchDB
//
//  Created by realalien on 12-1-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class CouchDatabase;

@interface MapViewController : UIViewController {
     CouchDatabase *database;
}

@property (nonatomic, retain) CouchDatabase *database;

-(void)useDatabase:(CouchDatabase*)theDatabase;

@end
