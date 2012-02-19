//
//  CountyDeputyMapViewController.m
//  StudyCouchDB
//
//  Created by realalien on 12-1-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CountyDeputyMapViewController.h"
#import "AddNewDeputyViewController.h"
#import "DeputyAnnotation.h"
#import "DeputyAnnotationView.h"


#define METERS_PER_MILE 1609.344


enum {
    kTagUIMapView=100,
    kTagUITableViewOfAreaNames,
    kTagUITableViewOfAreaNumbers,
    kTagUITableViewOfNominees
    
};


@interface CountyDeputyMapViewController (private) 
-(void)customizeNavigationbar;
-(void)setMapDisplayRegion:(CLLocationCoordinate2D)center latMeter:(CLLocationDistance)latitudinalMeters lngMeter:(CLLocationDistance)longitudinalMeters;

//-(void)loadAnnotations;
-(NSMutableArray *)countByAreaNameAreaNumberWithGroupingLevel:(NSInteger)levelOfGrouping;
-(void) reloadAggregateNomineesData ;

@end


static int HEIGHT_CELL = 44 ;

@implementation CountyDeputyMapViewController

@synthesize singleProfileViewController;
@synthesize popoverDataHolder;
@synthesize areaSelectPopup;
@synthesize nomineesGroupingLevel;

// data
@synthesize currentSelectAreaName;
@synthesize currentSelectAreaNumber;
@synthesize currentSelectNominee;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// temp
// IDEA: should group together if some people are affliated to one organization.
-(void)loadDummyAnnotations {
    CLLocationCoordinate2D workingCoordinate;
    MKMapView* mapView = (MKMapView*)[self.view viewWithTag:kTagUIMapView];
    mapView.showsUserLocation = YES;
    mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    workingCoordinate.latitude = 31.264588;
    workingCoordinate.longitude = 121.50512;
    
    DeputyAnnotation* d1 = [[DeputyAnnotation alloc] initWithCoordinate:workingCoordinate];
    [d1 setTitle:@"测试人1"];
    [d1 setSubtitle:@"虹口区2011年度区县人大选举－候选代表"];
    [d1 setDeputyAnnotationType:DeputyAnnotationTypeLatestNomineeMale];
    [mapView addAnnotation:d1];
    
    workingCoordinate.latitude = 31.274588;
    workingCoordinate.longitude = 121.50612;
    
    DeputyAnnotation* d2 = [[DeputyAnnotation alloc] initWithCoordinate:workingCoordinate];
    [d2 setTitle:@"测试人2"];
    [d2 setSubtitle:@"虹口区2011年度区县人大选举－当选代表"];
    [d2 setDeputyAnnotationType:DeputyAnnotationTypeLatestElectedMale];
    [mapView addAnnotation:d2];
}


/**/
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    UIView *v = [[UIView alloc]initWithFrame: [[UIScreen mainScreen]bounds] ];
    self.view = v;
    [v release];
    
//    NSLog(@"self.view.bounds  width,height is (%f, %f)",  self.view.bounds.size.width,self.view.bounds.size.height );
    
    // Create a MKMapView depends on device orientation
    //  Q: Why in debugg session, the view appeared to be in portrait mode?
    //  A: 
    
//    CGRect boundsChangedForOrientation = CGRectZero;
//    if ( UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) ) {
//        boundsChangedForOrientation = CGRectMake(0, 0, 1024, 768);
//    } else{
//        boundsChangedForOrientation = CGRectMake(0, 0, 768, 1024);
//    }
    
    MKMapView *mapV = [[MKMapView alloc]initWithFrame:CGRectZero];
    mapV.tag = kTagUIMapView;
    mapV.delegate = self;
    [self.view addSubview:mapV];
    
    // Register orientation change notification and config orientation
    // REF: http://stackoverflow.com/questions/2738734/get-current-orientation-of-ipad
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    
    //  add buttons on the navigation bar
    [self customizeNavigationbar];
    
    
    // When view created, level should be 1, Q: any better solution? A:
    nomineesGroupingLevel = [@"1" intValue];
    popoverDataHolder = [[NSMutableArray alloc]init];
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [LocationController sharedInstance].delegate = self;
    [[LocationController sharedInstance]start];
    
    
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self loadDummyAnnotations];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


-(void)dealloc{
    [singleProfileViewController release];
    [popoverDataHolder release];
    [areaSelectPopup release];
    
    [currentSelectAreaName release];
    [currentSelectAreaNumber release];
    [currentSelectNominee release];
}

#pragma mark -
#pragma mark MKMapViewDelegate

-(void)mapView:(MKMapView *)mv regionWillChangeAnimated:(BOOL)animated {
    //---print out the region span - aka zoom level---
//    MKCoordinateRegion region = mv.region;
//    NSLog(@"region.span.latitudeDelta : %f",region.span.latitudeDelta);
//    NSLog(@"region.span.longitudeDelta : %f",region.span.longitudeDelta); 
    
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{

    if ([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }
    
    if ([annotation isKindOfClass:[DeputyAnnotation class]]) {
        DeputyAnnotationView* annoView = nil;
        
        DeputyAnnotation* anno = (DeputyAnnotation*)annotation;
        //    MKMapView* mapView = (MKMapView*)[self.view viewWithTag:kTagUIMapView];
        
        // TODO: code smell bad!
        if (anno.deputyAnnotationType == DeputyAnnotationTypeLatestElectedMale) {
            NSString* identifier = @"LatestElectedMale";
            DeputyAnnotationView* newAnnoView = (DeputyAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
            if (newAnnoView == nil) {
                newAnnoView = [[DeputyAnnotationView alloc] initWithAnnotation:anno reuseIdentifier:identifier];
            }
            
            annoView = newAnnoView;
        }else if (anno.deputyAnnotationType == DeputyAnnotationTypePreviousElectedMale) {
            NSString* identifier = @"PreviousElectedMale";
            DeputyAnnotationView* newAnnoView = (DeputyAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
            if (newAnnoView == nil) {
                newAnnoView = [[DeputyAnnotationView alloc] initWithAnnotation:anno reuseIdentifier:identifier];
            }
            
            annoView = newAnnoView;
        }else if (anno.deputyAnnotationType == DeputyAnnotationTypeLatestNomineeMale) {
            NSString* identifier = @"LatestNomineeMale";
            DeputyAnnotationView* newAnnoView = (DeputyAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
            if (newAnnoView == nil) {
                newAnnoView = [[DeputyAnnotationView alloc] initWithAnnotation:anno reuseIdentifier:identifier];
            }
            
            annoView = newAnnoView;
        }else if (anno.deputyAnnotationType == DeputyAnnotationTypePreviousNomineeMale) {
            NSString* identifier = @"PreviousNomineeMale";
            DeputyAnnotationView* newAnnoView = (DeputyAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
            if (newAnnoView == nil) {
                newAnnoView = [[DeputyAnnotationView alloc] initWithAnnotation:anno reuseIdentifier:identifier];
            }
            
            annoView = newAnnoView;
        }
        
        // female
        else if (anno.deputyAnnotationType == DeputyAnnotationTypeLatestElectedFemale) {
            NSString* identifier = @"LatestElectedFemale";
            DeputyAnnotationView* newAnnoView = (DeputyAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
            if (newAnnoView == nil) {
                newAnnoView = [[DeputyAnnotationView alloc] initWithAnnotation:anno reuseIdentifier:identifier];
            }
            
            annoView = newAnnoView;
        }else if (anno.deputyAnnotationType == DeputyAnnotationTypePreviousElectedFemale) {
            NSString* identifier = @"PreviousElectedFemale";
            DeputyAnnotationView* newAnnoView = (DeputyAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
            if (newAnnoView == nil) {
                newAnnoView = [[DeputyAnnotationView alloc] initWithAnnotation:anno reuseIdentifier:identifier];
            }
            
            annoView = newAnnoView;
        }else if (anno.deputyAnnotationType == DeputyAnnotationTypeLatestNomineeFemale) {
            NSString* identifier = @"LatestNomineeFemale";
            DeputyAnnotationView* newAnnoView = (DeputyAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
            if (newAnnoView == nil) {
                newAnnoView = [[DeputyAnnotationView alloc] initWithAnnotation:anno reuseIdentifier:identifier];
            }
            
            annoView = newAnnoView;
        }else if (anno.deputyAnnotationType == DeputyAnnotationTypePreviousNomineeFemale) {
            NSString* identifier = @"PreviousNomineeFemale";
            DeputyAnnotationView* newAnnoView = (DeputyAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
            if (newAnnoView == nil) {
                newAnnoView = [[DeputyAnnotationView alloc] initWithAnnotation:anno reuseIdentifier:identifier];
            }
            
            annoView = newAnnoView;
        }
        
        [annoView setEnabled:YES];
        [annoView setCanShowCallout:YES]; // NOTE: set to NO to allow showing customized callout, 
        
        // an UIView with UIButtonTypeDetailDisclosure
        [annoView setRightCalloutAccessoryView:[UIButton buttonWithType:UIButtonTypeDetailDisclosure] ];
        
        return annoView;
    }
    
    return nil;
    
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    // deselect
    [mapView deselectAnnotation:view.annotation animated:YES];
    
    
    // EXP. create an overlay view to show the detail.
    // * Better if it's a tab view to show different aspects of information. (IDEA: a note tab to take notes from news VC)
    // * a tab with UIWebView
    
    if (singleProfileViewController == nil) {
        DeputyProfileViewController* profileVC = [[DeputyProfileViewController alloc]init];
        self.singleProfileViewController = profileVC;
    }
    
//    [self.singleProfileViewController loadDeputyProfile:nil];
    
    [self.view addSubview:self.singleProfileViewController.view];
    
//    UIView* demoOverlay = [[UIView alloc]initWithFrame:CGRectMake( self.view.frame.size.width / 2, 
//                                                                 0,
//                                                                 self.view.frame.size.width / 2,
//                                                                  self.view.frame.size.height)];
//    demoOverlay.backgroundColor = [UIColor grayColor];
//    demoOverlay.tag = 123;
//    [self.view addSubview:demoOverlay];
    
    
    // ESP. study the animation and create an effect of moving
    
    
    // Adjust the display of map, annotation clicked should move to 1/4 from the left.
    
}


//// customize the layout of callout display.
//- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
//    if (view.annotation == self.customAnnotation) {
//        if (self.calloutAnnotation == nil) {
//            self.calloutAnnotation = [[CalloutMapAnnotation alloc]
//                                      initWithLatitude:view.annotation.coordinate.latitude
//                                      andLongitude:view.annotation.coordinate.longitude];
//        } else {
//            self.calloutAnnotation.latitude = view.annotation.coordinate.latitude;
//            self.calloutAnnotation.longitude = view.annotation.coordinate.longitude;
//        }
//        [self.mapView addAnnotation:self.calloutAnnotation];
//        self.selectedAnnotationView = view;
//    }
//}

#pragma mark -
#pragma mark UI helper methods

// REF: Multiple Buttons on a Navigation Bar 
//      http://osmorphis.blogspot.com/2009/05/multiple-buttons-on-navigation-bar.html
// Q: Why there is some space at the right most position? A:
-(void)customizeNavigationbar {
    
//    // create a toolbar to have two buttons in the right
//    UIToolbar* toolsLeft = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 133, 44.01)];
//    // create the array to hold the buttons, which then gets added to the toolbar
//    NSMutableArray* buttonsLeft = [[NSMutableArray alloc] initWithCapacity:1];
    
    
    // ----------  left hand side -----------
    UIButton *selectArea = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    selectArea.frame = CGRectMake(0, 0, 150,30);
//    selectArea.backgroundColor = [UIColor blueColor];
//    selectArea.titleLabel.text = @"Filter by Area";
//    selectArea.titleLabel.textColor = [UIColor blackColor];
    
    [selectArea setTitle:@"选择代表人" forState:UIControlStateNormal];
    [selectArea setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    selectArea.titleLabel.textAlignment = UITextAlignmentCenter;
    [selectArea  addTarget:self 
                    action:@selector(showPopupAreaSelect:)
          forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *selectArea2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    selectArea2.frame = CGRectMake(160, 0, 140,30);
//    selectArea2.backgroundColor = [UIColor blueColor];
//    selectArea2.titleLabel.text = @"Filter by Area2";
    [selectArea2 setTitle:@"Filter by Area2" forState:UIControlStateNormal];
    
    [selectArea2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

//    selectArea2.titleLabel.textColor = [UIColor blackColor];
    selectArea2.titleLabel.textAlignment = UITextAlignmentCenter;
    [selectArea2  addTarget:self 
                    action:@selector(showPopupAreaSelect:)
          forControlEvents:UIControlEventTouchUpInside];
    
//    UIBarButtonItem* bi = [[UIBarButtonItem alloc]initWithTitle:@"Filter by Area" style:UIBarButtonItemStyleBordered target:self action:@selector(showPopupAreaSelect:)];
//    bi.style = UIBarButtonItemStyleBordered;
//    [buttonsLeft addObject:bi];
//    [bi release];
    
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:selectArea] ; 
    item1.tag = 102;
    
    self.navigationItem.leftBarButtonItems = [ NSArray arrayWithObjects:
                                              [item1 autorelease], 
                                              [[UIBarButtonItem alloc] initWithCustomView:selectArea2], 
                                              nil]; 
//    [toolsLeft release];
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelEdit:)];
    
    // ----------  right hand side -----------
    
    // create a toolbar to have two buttons in the right
    UIToolbar* tools = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 133, 44.01)];
    
    // create the array to hold the buttons, which then gets added to the toolbar
    NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:3];
    
    
    // create a standard "add" button
    UIBarButtonItem *bi = [[UIBarButtonItem alloc]
                           initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewDeputy:)];
    bi.style = UIBarButtonItemStyleBordered;
    [buttons addObject:bi];
    [bi release];
    
    // create a spacer
    bi = [[UIBarButtonItem alloc]
          initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [buttons addObject:bi];
    [bi release];
    
    // create a standard "refresh" button
    bi = [[UIBarButtonItem alloc]
          initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
    bi.style = UIBarButtonItemStyleBordered;
    [buttons addObject:bi];
    [bi release];
    
    // stick the buttons in the toolbar
    [tools setItems:buttons animated:NO];
    
    [buttons release];
    
    // and put the toolbar in the nav bar
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:tools];
    [tools release];
}

#pragma mark -
#pragma mark LocationControllerDelegate methods

- (void)locationUpdate:(CLLocation*)location{
    // reload the annotation of userlocation  
    NSLog(@"location is ( %f , %f )", location.coordinate.latitude, location.coordinate.longitude);
    [self setMapDisplayRegion:location.coordinate 
                     latMeter:METERS_PER_MILE  
                     lngMeter:METERS_PER_MILE ];
    
    // TODO: delay to allow showing blue circle

    [[LocationController sharedInstance] stop];
}



#pragma mark -
#pragma mark Callback methods

// IDEA: create a drill-down tableview
-(void)showPopupAreaSelect:(id)sender {

    // refresh the data
    //[self reloadAggregateNomineesData];  
    if (self.areaSelectPopup) {
        [self.areaSelectPopup dismissPopoverAnimated:YES]; //later will present anyway.
    }
    
    // create a popover
    if (! self.areaSelectPopup) {
        // if not created, for the first
        UITableViewController *firstLevelVC = [[UITableViewController alloc] init];
        firstLevelVC.tableView.tag = kTagUITableViewOfAreaNames;
        firstLevelVC.tableView.delegate = self;
        firstLevelVC.tableView.dataSource = self;
        
        UINavigationController *aggregateNavVc = [[UINavigationController alloc]initWithRootViewController:firstLevelVC];
        aggregateNavVc.delegate = self;

        // Customize the navigationbar items
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                       style:UIBarButtonItemStylePlain 
                                                                      target:self 
                                                                      action:@selector(popoverBackButtonClicked:)];
        
        firstLevelVC.navigationItem.backBarButtonItem = backButton;
        [backButton release];
        
        UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
        l.backgroundColor = [UIColor clearColor];
        l.textAlignment = UITextAlignmentCenter;
        l.textColor = [UIColor whiteColor];
        l.text = @"选择行政区域";
        firstLevelVC.navigationItem.titleView = l;
        [l release];
        
        
        UIPopoverController *theAreaSelectPopup = [[UIPopoverController alloc]initWithContentViewController:[aggregateNavVc autorelease]];
        self.areaSelectPopup = theAreaSelectPopup;
//        [theAreaSelectPopup release];
        self.areaSelectPopup.delegate = self;
    }
    
    // NOTE: the processes of 'loading data' and 'resize popoverview' is moved to the delegate methods of popoverview
    
    // locate the UITableViewController in order to reloadData
    UIBarButtonItem *item = (UIBarButtonItem*)[self.navigationItem.leftBarButtonItems objectAtIndex:0];
    [self.areaSelectPopup presentPopoverFromBarButtonItem:item
                                 permittedArrowDirections:UIPopoverArrowDirectionAny
                                                 animated:NO];
    
}


-(void) orientationChanged:(id)sender {
    CGRect boundsChangedForOrientation = CGRectZero;
    if ( UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) ) {
        boundsChangedForOrientation = CGRectMake(0, 0, 1024, 768);
    } else{
        boundsChangedForOrientation = CGRectMake(0, 0, 768, 1024);
    }
    
    MKMapView *mapV = (MKMapView*)[self.view viewWithTag:kTagUIMapView];
    mapV.frame = boundsChangedForOrientation;
}

// TODO: suppose to reload data from server, make sure the button is disabled when querying.
// TODO: add a activity indicator when loading
-(void)refresh:(id)sender {
    [[LocationController sharedInstance] start];
    
    // TODO: find a better place to update annotions
//    [self loadAnnotations];
}



-(void)popoverBackButtonClicked:(id)sender {
    nomineesGroupingLevel -= 1;
    NSLog(@"popoverBackButtonClicked  ！！！！  %d", nomineesGroupingLevel);
}



-(void)addNewDeputy:(id)sender {
    AddNewDeputyViewController *addDeputyVc = [[AddNewDeputyViewController alloc]init]; 
    addDeputyVc.modalPresentationStyle = UIModalPresentationFormSheet;
    addDeputyVc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:addDeputyVc animated:YES];
    // TODO: why the superview? Q: A:
    addDeputyVc.view.superview.frame =CGRectMake(0,0,500,400);//it's important to do this after presentModalViewController
    addDeputyVc.view.superview.center=self.view.center;//self.view assumes the base view is doing the launching, if not you might need self.view.superview.center etc.
    
    // Q: Code below may be useful to make navigationViewController to present the modal view. A:
    // addDeputyVc.title = @"Add a new deputy information";
}


-(void)setMapDisplayRegion:(CLLocationCoordinate2D)center latMeter:(CLLocationDistance)latitudinalMeters lngMeter:(CLLocationDistance)longitudinalMeters{
    MKMapView* mapView = (MKMapView*)[self.view viewWithTag:kTagUIMapView];
    // 1
//    CLLocationCoordinate2D zoomLocation;
//    zoomLocation.latitude = 31.264588;
//    zoomLocation.longitude = 121.50512;
    // 2
//    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 100*METERS_PER_MILE, 100*METERS_PER_MILE);
    // 3
//    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];                
//    // 4
//    [mapView setRegion:adjustedRegion animated:YES];  
    
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(center, longitudinalMeters,longitudinalMeters);
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];                
    // 4
    [mapView setRegion:adjustedRegion animated:YES]; 
}


-(NSMutableArray *)countByAreaNameAreaNumberWithGroupingLevel:(NSInteger)levelOfGrouping
                                                     startKey:(id)aStartKey
                                                       endKey:(id)aEndKey {
    // read database.
    NSLog(@"loadAnnotations");
    
    CouchDatabase *database = [CouchbaseServerManager getDeputyDB]; 
    
    CouchDesignDocument* design = [database designDocumentWithName: @"nominees"];
 
    // a simple map/reduce function
    [design defineViewNamed: @"count_nominees_by_area_name" 
                        map: @"function(doc){\
     if (doc.area_name && doc.area_number && doc.nominee_name)\
        emit([doc.area_name, doc.area_number], 1 ); \
     } "
                     reduce:@"function(key, values, rereduce) {\
     return sum(values);\
     }"
     ];

    CouchQuery* query = [design queryViewNamed: @"count_nominees_by_area_name"];
    query.groupLevel = levelOfGrouping;
    query.startKey = aStartKey;
    query.endKey = aEndKey;
    
//    [query start];
    NSLog(@"total count: %d", query.rows.count);
    
    NSMutableArray *ret = [[NSMutableArray alloc]init];
    
    // Q: TODO: shall I cache the data or request everytime?
    // A: 
    for (int i=0; i< query.rows.count; i++) {
        CouchQueryRow *row = [query.rows rowAtIndex:i];
        //NSLog(@"row %d  =>  %@ : %@ ",i, [row.key description], [row.value description]  );
        //[ret setValue:[row.value description]forKey:[row.key description]];
        [ret addObject:row]; // NOTE: it looks like the data structure is loose, i.e. not enforce any attributes! What's the best practice here?
    }
    
    return ret;
}


-(NSMutableArray *)loadNomineesByAreaName:(NSString*)area_name areaNumber:(NSString*)area_number{
    // read database.
    NSLog(@"loadAnnotations");
    
    CouchDatabase *database = [CouchbaseServerManager getDeputyDB]; 
    
    CouchDesignDocument* design = [database designDocumentWithName: @"nominees"];
    
    // TODO: is it ok to add the nominees data into the key? Test in tempview!
    [design defineViewNamed: @"list_nominees_by_area_name_area_number_nominee_name" 
                        map: @"function(doc){\
                                if (doc.area_name && doc.area_number && doc.nominee_name){ \
                                    emit([doc.area_name, doc.area_number, doc.nominee_name], doc ); \
                                } \
                                }"
    ];
    
    CouchQuery* query = [design queryViewNamed: @"list_nominees_by_area_name_area_number_nominee_name"];
    // NOTE:
    //  to filter using just key=, all parts of the complex key must be specified or you will get a null result, as key= is looking for an exact match.
    // REF: http://ryankirkman.github.com/2011/03/30/advanced-filtering-with-couchdb-views.html
    //    query.keys = [NSArray arrayWithObjects: area_name, [NSArray array], nil ];
    query.startKey = [NSArray arrayWithObjects:area_name, area_number, nil] ;
    query.endKey = [NSArray arrayWithObjects: area_name, area_number, [NSDictionary dictionary], nil ];
//    query.groupLevel = 3;
    
    NSLog(@"total count: %d", query.rows.count);
    
    NSMutableArray *ret = [[NSMutableArray alloc]init];
    
    // Q: TODO: shall I cache the data or request everytime?
    // A: 
    for (int i=0; i< query.rows.count; i++) {
        CouchQueryRow *row = [query.rows rowAtIndex:i];
        //NSLog(@"row %d  =>  %@ : %@ ",i, [row.key description], [row.value description]  );
        //[ret setValue:[row.value description]forKey:[row.key description]];
        [ret addObject:row]; // NOTE: it looks like the data structure is loose, i.e. not enforce any attributes! What's the best practice here?
    }
    
    return ret;
}


#pragma mark -
#pragma mark UIPopoverControllerDelegate methods
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    // IDEA: if the popover is not kill, can I mimic the effect of keeping the level of selection ?!
}



#pragma mark -
#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // NOTE: nation or city shall not appear in the popover selection(better be set in location service or other city selection area), so that there is no need to filter data multiple times!
    NSLog(@"nomineesGroupingLevel ＝＝＝＝＝＝  %d", nomineesGroupingLevel);

    if (tableView.tag == kTagUITableViewOfAreaNames) {  // did select a 'area name' 
        NSLog(@"nomineesGroupingLevel >>>>>   %d", nomineesGroupingLevel);
        
        CouchQueryRow *row = (CouchQueryRow*)[popoverDataHolder objectAtIndex:indexPath.row];
        self.currentSelectAreaName = row.key0;
        // NOTE: data loading is in popover delegate methods
        
        UINavigationController *aggreNav = (UINavigationController*) self.areaSelectPopup.contentViewController;
        // push a new UITableViewController , Q: When pop it out, will the vc be release? A:
        UITableViewController *areaNumberTableVc = [[UITableViewController alloc]init];
        areaNumberTableVc.tableView.tag = kTagUITableViewOfAreaNumbers ; 
        areaNumberTableVc.tableView.dataSource = self;
        areaNumberTableVc.tableView.delegate = self;
        
        
        [aggreNav pushViewController:areaNumberTableVc animated:YES]; // NOTE: can't set animation to YES, the popover contentSize will be resized.
        
        // Customize the navigationbar
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                       style:UIBarButtonItemStylePlain 
                                                                      target:self 
                                                                      action:@selector(popoverBackButtonClicked:)];
        
        areaNumberTableVc.navigationItem.backBarButtonItem = backButton;
        [backButton release];
        
        UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
        l.backgroundColor = [UIColor clearColor];
        l.textAlignment = UITextAlignmentCenter;
        l.textColor = [UIColor whiteColor];
        l.text = [NSString stringWithFormat:@"%@", currentSelectAreaName];
        areaNumberTableVc.navigationItem.titleView = l;
        [l release];
        
//        [self.areaSelectPopup setPopoverContentSize:CGSizeMake(260, [popoverDataHolder count] * HEIGHT_CELL + 44 )];
    
    }else if (tableView.tag == kTagUITableViewOfAreaNumbers){   // did select a 'area number'
        
        CouchQueryRow *row = (CouchQueryRow*)[popoverDataHolder objectAtIndex:indexPath.row];        
        self.currentSelectAreaNumber = row.key1 ;
        
        // load the nominees objects
        UINavigationController *aggreNav = (UINavigationController*) self.areaSelectPopup.contentViewController;

        // push a new UITableViewController , Q: When pop it out, will the vc be release? A:
        UITableViewController *nomineesTableVc = [[UITableViewController alloc]init];
        nomineesTableVc.tableView.tag = kTagUITableViewOfNominees;
        nomineesTableVc.tableView.dataSource = self;
        nomineesTableVc.tableView.delegate = self;
        
        [aggreNav pushViewController:nomineesTableVc animated:YES]; // NOTE: can't set animation to YES, the popover contentSize will be resized.
        
        // customize the navigationbar
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                       style:UIBarButtonItemStylePlain 
                                                                      target:self 
                                                                      action:@selector(popoverBackButtonClicked:)];
        
        nomineesTableVc.navigationItem.backBarButtonItem = backButton;
        [backButton release];
        
        UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
        l.backgroundColor = [UIColor clearColor];
        l.textAlignment = UITextAlignmentCenter;
        l.textColor = [UIColor whiteColor];
        l.text = [NSString stringWithFormat:@"%@  第%@选区", currentSelectAreaName, currentSelectAreaNumber];
        nomineesTableVc.navigationItem.titleView = l;
        [l release];
    }else if (tableView.tag == kTagUITableViewOfNominees){
        // show other view controll (probably the details of the nominees
        [self.areaSelectPopup dismissPopoverAnimated:YES];
    }
}



#pragma mark -
#pragma mark UITableDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [popoverDataHolder count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    CouchQueryRow *row =[popoverDataHolder objectAtIndex:indexPath.row];
    
    
    NSString *cellValue = nil;
    // TEMP,EXPERIMENTAL
    
    int keyIndexForUI = 0;  
    // TODO, following code should not be embedded here, should setup depending on the design document
    if (nomineesGroupingLevel == 1) {
        keyIndexForUI = 0;
        cellValue = [NSString stringWithFormat:@"%@ (共%@个选区)",  [row keyAtIndex:keyIndexForUI] ,[row.value description] ] ;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (nomineesGroupingLevel == 2) {
        keyIndexForUI = 1;
        cellValue = [NSString stringWithFormat:@"第%@选区 (共%@位代表)",  [row keyAtIndex:keyIndexForUI] ,[row.value description] ] ;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (nomineesGroupingLevel == 3) {
        keyIndexForUI = 2;
        cellValue = [NSString stringWithFormat:@"%@",  [row keyAtIndex:keyIndexForUI] ]; // the nominee's name
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    
    
    cell.textLabel.text = cellValue;
//    cell.textLabel.textColor = [UIColor colorWithRed:65.0f/255.0f green:65.0f/255.0f blue:65.0f/255.0f alpha:1.0];
    
    return cell;
}


#pragma mark -
#pragma mark UINavigationControllerDelegate methods
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSLog(@" showing tag of viewController  %d", viewController.view.tag);
    
    if (viewController.view.tag == kTagUITableViewOfAreaNames) {
        nomineesGroupingLevel = 1;
        
        // refresh data in case new data has been added.
        [popoverDataHolder removeAllObjects];
        NSMutableArray *data  = [self countByAreaNameAreaNumberWithGroupingLevel:1 
                                                                        startKey:nil 
                                                                          endKey:nil];
        popoverDataHolder = data;// TODO: this looks wired, what's then? A:
        
        if ([self.areaSelectPopup.contentViewController isKindOfClass:[UINavigationController class]] ) {
            UINavigationController *aggreNav = (UINavigationController*) self.areaSelectPopup.contentViewController;
            if (aggreNav && [aggreNav.topViewController isKindOfClass:[UITableViewController class]]) {
                UITableViewController *tableVC =  (UITableViewController *)aggreNav.topViewController ;
                [tableVC.tableView reloadData];
            }
        }
        
    }else if (viewController.view.tag == kTagUITableViewOfAreaNumbers){
        nomineesGroupingLevel = 2;
        
        
        [popoverDataHolder removeAllObjects];
        NSMutableArray *data  = [self countByAreaNameAreaNumberWithGroupingLevel:2 
                                                                        startKey:[NSArray arrayWithObjects: self.currentSelectAreaName, nil,nil ] 
                                                                          endKey:[NSArray arrayWithObjects: self.currentSelectAreaName, [NSDictionary dictionary],nil ]];
        popoverDataHolder = data;
        
        
    }else if (viewController.view.tag == kTagUITableViewOfNominees){
        nomineesGroupingLevel = 3;
        
        [popoverDataHolder removeAllObjects];
        NSMutableArray *data  = [self loadNomineesByAreaName:self.currentSelectAreaName
                                                  areaNumber:self.currentSelectAreaNumber];
        popoverDataHolder = data;

    }
    
    CGSize currentSetSizeForPopover =  CGSizeMake(260, [popoverDataHolder count] * HEIGHT_CELL ) ;//viewController.contentSizeForViewInPopover;
//    CGSize fakeMomentarySize = CGSizeMake(currentSetSizeForPopover.width - 1.0f, currentSetSizeForPopover.height - 1.0f);
//    viewController.contentSizeForViewInPopover = fakeMomentarySize;
    viewController.contentSizeForViewInPopover = currentSetSizeForPopover;
    
//    [self.areaSelectPopup setPopoverContentSize : CGSizeMake(260, [popoverDataHolder count] * HEIGHT_CELL + 44 )];
    
    

 
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [self.areaSelectPopup setPopoverContentSize: CGSizeMake(260, [popoverDataHolder count] * HEIGHT_CELL + 44 ) 
                                       animated:YES];
}



@end
