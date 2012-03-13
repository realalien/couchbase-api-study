//
//  OrganizationsPlaygroundViewController.m
//  StudyCouchDB
//
//  Created by d d on 12-3-13.
//  Copyright (c) 2012年 d. All rights reserved.
//


#import "OrganizationSlideView.h"
#import "OrganizationsPlaygroundViewController.h"

@implementation OrganizationsPlaygroundViewController

@synthesize currentSelectOrganizationView;

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
    // TODO: should be right even after auto rotation.
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
    self.view = v;
    [v release];
    
    

    //[longPressRecognizer release];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // EXPERIMENTAL: add new orgranization by long press gesture
    // Q: why the gesture recognizer doesn't load in the loadview?
    
    // Long press for creating a new UIView.
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressWithGestureRecognizer:)];
    longPressRecognizer.minimumPressDuration = 1;
    longPressRecognizer.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:longPressRecognizer];
    
    // Tap for selection.
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    // Pan for moving UIView
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    panRecognizer.minimumNumberOfTouches = 1;    
    [self.view addGestureRecognizer:panRecognizer];
    
    
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


#pragma mark -
#pragma mark callback methods

-(void)longPressWithGestureRecognizer:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan ) {
        NSLog(@"longPressWithGestureRecognizer ... began");
    }else if ([gestureRecognizer state] == UIGestureRecognizerStateEnded ) {
        NSLog(@"longPressWithGestureRecognizer ... ended");
        // create a organization slide view at the touch point if in empty space.
        CGPoint pos = [gestureRecognizer locationInView:self.view];
        NSLog(@"position is (%f, %f)", pos.x, pos.y );
        OrganizationSlideView *v = [[OrganizationSlideView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        v.center = pos;
        v.backgroundColor = [UIColor greenColor];
        // TODO: also assign tag for persistence and create back from save data.
        [self.view addSubview:v];
    }
}


-(void)tapGestureRecognizer:(UITapGestureRecognizer*)gestureRecognizer{
    NSLog(@"tapGestureRecognizer ... began");
    if ( [gestureRecognizer state] == UIGestureRecognizerStateEnded) {
        CGPoint pos = [gestureRecognizer locationInView:self.view];
        NSLog(@"position is (%f, %f)", pos.x, pos.y );
        
        // check the if touch insides a UIView created by longPressGesture
        UIView* viewYouWishToObtain = [self.view hitTest:pos withEvent:nil];
        if (viewYouWishToObtain && viewYouWishToObtain!=self.view) {
            if ( !self.currentSelectOrganizationView){
                self.currentSelectOrganizationView = viewYouWishToObtain;
                self.currentSelectOrganizationView.backgroundColor = [UIColor redColor];
            }else {// already there is a selection
                if (viewYouWishToObtain == self.currentSelectOrganizationView) { // deselect
                    self.currentSelectOrganizationView.backgroundColor = [UIColor greenColor];
                    self.currentSelectOrganizationView = nil;
                }else{ // assign new selection
                    self.currentSelectOrganizationView.backgroundColor = [UIColor greenColor]; // set original selection back to normal
                    self.currentSelectOrganizationView = viewYouWishToObtain;
                    self.currentSelectOrganizationView.backgroundColor = [UIColor redColor];
                }
            }
        }
    }
}

-(void)panGestureRecognizer:(UIPanGestureRecognizer*)gestureRecognizer {
    NSLog(@"panGestureRecognizer ... began");
    if ( [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        if (self.currentSelectOrganizationView) {
            // get the currrent postion and move the 
            CGPoint pos = [gestureRecognizer locationInView:self.view];
            self.currentSelectOrganizationView.frame = CGRectMake(pos.x, 
                                                                  pos.y, 
                                                                  self.currentSelectOrganizationView.frame.size.width,
                                                                  self.currentSelectOrganizationView.frame.size.height); // better position with origin
        }
    }else if([gestureRecognizer state] == UIGestureRecognizerStateEnded){
        // do nothing.
    }
}

@end
