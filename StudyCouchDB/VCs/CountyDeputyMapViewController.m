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
    kTagUIMapView=100
};


@interface CountyDeputyMapViewController (private) 
-(void)customizeNavigationbar;
-(void)setMapDisplayRegion:(CLLocationCoordinate2D)center latMeter:(CLLocationDistance)latitudinalMeters lngMeter:(CLLocationDistance)longitudinalMeters;
-(void)loadAnnotations;
@end


@implementation CountyDeputyMapViewController

@synthesize singleProfileViewController;


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
}

#pragma mark -
#pragma mark MKMapViewDelegate

-(void)mapView:(MKMapView *)mv regionWillChangeAnimated:(BOOL)animated {
    //---print out the region span - aka zoom level---
    MKCoordinateRegion region = mv.region;
    NSLog(@"region.span.latitudeDelta : %f",region.span.latitudeDelta);
    NSLog(@"region.span.longitudeDelta : %f",region.span.longitudeDelta); 
    
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
    // create a toolbar to have two buttons in the right
    UIToolbar* toolsLeft = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 133, 44.01)];
    // create the array to hold the buttons, which then gets added to the toolbar
    NSMutableArray* buttonsLeft = [[NSMutableArray alloc] initWithCapacity:1];
    
    
    // ----------  left hand side -----------
    UIBarButtonItem* bi = [[UIBarButtonItem alloc]initWithTitle:@"Filter by Area" style:UIBarButtonItemStyleBordered target:self action:@selector(showPopupAreaSelect:)];
    bi.style = UIBarButtonItemStyleBordered;
    [buttonsLeft addObject:bi];
    [bi release];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:toolsLeft];
    [toolsLeft release];
    
    
    // ----------  right hand side -----------
    
    // create a toolbar to have two buttons in the right
    UIToolbar* tools = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 133, 44.01)];
    
    // create the array to hold the buttons, which then gets added to the toolbar
    NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:3];
    
    
    // create a standard "add" button
    bi = [[UIBarButtonItem alloc]
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

    //[[LocationController sharedInstance] stop];
}



#pragma mark -
#pragma mark Callback methods

-(void)showPopupAreaSelect:(id)sender {
    
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
    [self loadAnnotations];
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



-(void)loadAnnotations {
    // read database.
    
    
    
}


@end
