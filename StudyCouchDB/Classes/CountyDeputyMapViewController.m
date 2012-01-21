//
//  CountyDeputyMapViewController.m
//  StudyCouchDB
//
//  Created by realalien on 12-1-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CountyDeputyMapViewController.h"

#import "AddNewDeputyViewController.h"

enum {
    kTagUIMapView=100
};


@interface CountyDeputyMapViewController (private) 
-(void)customizeNavigationbar;
@end


@implementation CountyDeputyMapViewController

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


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

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

#pragma mark -
#pragma mark MKMapViewDelegate

-(void)mapView:(MKMapView *)mv regionWillChangeAnimated:(BOOL)animated {
    //---print out the region span - aka zoom level---
    MKCoordinateRegion region = mv.region;
    NSLog(@"%f",region.span.latitudeDelta);
    NSLog(@"%f",region.span.longitudeDelta); 
    
}


#pragma mark -
#pragma mark 

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
    
}

-(void)addNewDeputy:(id)sender {
    AddNewDeputyViewController *addDeputyVc = [[AddNewDeputyViewController alloc]init]; 
    addDeputyVc.modalPresentationStyle = UIModalPresentationFormSheet;
    addDeputyVc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:addDeputyVc animated:YES];
    addDeputyVc.view.superview.frame = CGRectMake(0, 0, 500, 400);//it's important to do this after presentModalViewController
    addDeputyVc.view.superview.center = self.view.center;
    
    // Q: Code below may be useful to make navigationViewController to present the modal view. A:
    // addDeputyVc.title = @"Add a new deputy information";
}

@end
