//
//  MeshableTablesViewController.m
//  StudyCouchDB
//
//  Created by d d on 12-1-13.
//  Copyright (c) 2012年 d. All rights reserved.
//

#import "MeshableTablesViewController.h"

@implementation MeshableTablesViewController

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
    CGRect screen = [[UIScreen mainScreen] bounds];
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen.size.width, screen.size.height)];
    self.view = v;
    [v release];
    
//    UITableViewController *tv1 = [[UITableViewController alloc]init];
//    UITableViewController *tv2 = [[UITableViewController alloc]init];
//    UITableViewController *tv3 = [[UITableViewController alloc]init];
    
    // Problem is that we need to 
    // Potential solution is we subclass UITableViewControllerDelegate and overriding the delegate methods with calling to the super class, so we can inject the performSelector to boardcast 
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
