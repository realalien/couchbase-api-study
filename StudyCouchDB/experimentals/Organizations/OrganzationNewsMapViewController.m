//
//  OrganzationNewsMapViewController.m
//  StudyCouchDB
//
//  Created by d d on 12-4-9.
//  Copyright (c) 2012年 d. All rights reserved.
//

#import "OrganzationNewsMapViewController.h"

@interface OrganzationNewsMapViewController ()
-(void)createProcessPanel;
@end
    
@implementation OrganzationNewsMapViewController

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


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    UIView *v = [[UIView alloc]initWithFrame: [[UIScreen mainScreen]bounds] ];
    self.view = v;
    [v release];
    
    // map view
    MKMapView *mapV = [[MKMapView alloc]initWithFrame:CGRectZero];
    mapV.tag = 100;
    mapV.delegate = self;
    [self.view addSubview:mapV];

    [self createProcessPanel];
    
    
    // Register orientation change notification and config orientation
    // REF: http://stackoverflow.com/questions/2738734/get-current-orientation-of-ipad
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

-(void)createProcessPanel {
    
    // process panel
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(1024* 0.8, 0, 1024 *0.2, 768)];
    [self.view addSubview:v];
    
    
    UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 18)];
    l.text = @"请输入组织的名称";
    [v addSubview:l];
    [l release];
    
    UITextField *t = [[UITextField alloc]initWithFrame:CGRectMake(10, 10+18+10, 200, 18)];
    t.placeholder = @"尽量使用全名以便搜索";
    [v addSubview:t];
    [t release];
    
    //table view for select candidate from address search, do we need baidu api for search result?
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(10, (10+18)*2+10, 200, 500)];
    table.delegate = self;
    table.dataSource = self;
    [v addSubview:table];
    [table release];
    
    [v release];
    
}

-(void) orientationChanged:(id)sender {
    CGRect boundsChangedForOrientation = CGRectZero;
    if ( UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) ) {
        boundsChangedForOrientation = CGRectMake(0, 0, 1024, 768);
    } else{
        boundsChangedForOrientation = CGRectMake(0, 0, 768, 1024);
    }
    
    MKMapView *mapV = (MKMapView*)[self.view viewWithTag:100];
    mapV.frame = boundsChangedForOrientation;
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

@end
