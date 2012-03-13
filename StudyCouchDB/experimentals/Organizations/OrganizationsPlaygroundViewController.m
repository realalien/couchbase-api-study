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
    
    
    // EXPERIMENTAL: add new orgranization by long press gesture
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressDetected:)];
    longPressRecognizer.minimumPressDuration = 2;
    longPressRecognizer.numberOfTouchesRequired = 1;

    [self.view addGestureRecognizer:longPressRecognizer];
    [longPressRecognizer release];
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
#pragma mark callback methods

-(void)longPressDetected:(id)sender{
    
    // create a organization slide view at the touch point if in empty space.
    OrganizationSlideView *v = [[OrganizationSlideView alloc] initWithFrame:CGRectZero];
    
}

@end
