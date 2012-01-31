//
//  DeputyProfileViewController.m
//  StudyCouchDB
//
//  Created by d d on 12-1-31.
//  Copyright (c) 2012年 d. All rights reserved.
//

#import "DeputyProfileViewController.h"
#import "UIFactory.h"

@implementation DeputyProfileViewController

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
    
    UIScrollView* container = [UIFactory makeHalfScreenRightScrollView];
    container.backgroundColor =[UIColor grayColor];
    self.view = container;
    

    // Image
    
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
#pragma mark Utilties

// update the UI control with profile info of a deputy.
-(void)loadDeputyProfile:(NSDictionary*)profile {
    
}


@end
