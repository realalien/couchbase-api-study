//
//  OrganzationNewsMapViewController.h
//  StudyCouchDB
//
//  Created by d d on 12-4-9.
//  Copyright (c) 2012年 d. All rights reserved.
//


// TODO: mainly to get a general view of latest news update for target 

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h> 
#import "BMapKit.h"
#import <CouchCocoa/CouchUITableSource.h>

@interface OrganzationNewsMapViewController : UIViewController<BMKMapViewDelegate, UITableViewDataSource, UITableViewDelegate, BMKSearchDelegate, UIAlertViewDelegate, CouchUITableDelegate> {
    BMKMapView *map;
    BMKMapManager* _mapManager;
    
    // 用于各种搜索
    BMKSearch* _search;
    
    
    NSMutableArray *mapSearchResult;
    
    NSMutableDictionary *data;
    
    UITableView *poiTableView;
    
    
    CouchUITableSource* organizationAnnotationDataSource;
}

@property (nonatomic, retain)  BMKMapView *map;
@property (nonatomic, retain)  NSMutableArray *mapSearchResult;

@property (nonatomic, retain)   NSMutableDictionary *data;
@property (nonatomic, retain)  UITableView *poiTableView;

@property(nonatomic, retain) CouchUITableSource* organizationAnnotationDataSource;

@end

