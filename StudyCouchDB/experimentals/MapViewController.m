//
//  MapViewController.m
//  StudyCouchDB
//
//  Created by realalien on 12-1-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import "UIFactory.h"
#import <Couchbase/CouchbaseMobile.h>
#import <CouchCocoa/CouchCocoa.h>

enum {
    kTagUISchoolNameLabel = 100,
    kTagUISchoolNameTextField
};

@interface MapViewController (private)     
-(void)printOutDocs;
@end


@implementation MapViewController

@synthesize database;

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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
 */
- (void)loadView
{
    CGRect screen = [[UIScreen mainScreen] bounds];
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen.size.width, screen.size.height)];
    self.view = v;
    [v release];
    
    
    // Input box for user input data
    // IDEA: user should input as little as possible, we may assist!
    // TODO: see if we can wrap a group of UI controls and publize the control  , AFM    
    UILabel *l = [UIFactory makeDefaultLabelWithText:@"学校名称" 
                                              andTag:kTagUISchoolNameLabel];
    [self.view addSubview:l];
    
    UITextField *t = [UIFactory makeDefaultTextFieldWithPlaceholder:@"请填写"
                                                             andTag:kTagUISchoolNameTextField];
    [self.view addSubview:t];
    
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    b.frame = CGRectMake(260, 20, 50, 40);
    [b setTitle:@"添加" forState:UIControlStateNormal];
    [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    b.backgroundColor = [UIColor whiteColor];
    [b addTarget:self action:@selector(addNewSchoolButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b];
    
    
    // MKMap view
    // TODO: should appear as a draggable overlay view like twitter's!
    self.view.backgroundColor = [UIColor whiteColor];
    MKMapView *map = [[MKMapView alloc] init]; 
    map.frame = CGRectMake(screen.size.width / 2 , 0, screen.size.width / 2 , 300); 
    [self.view addSubview:map];
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
    [database release];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}



- (void)useDatabase:(CouchDatabase*)theDatabase {
    self.database = theDatabase;
}


#pragma mark -
#pragma mark Event handler

-(void)addNewSchoolButtonClicked{
    NSLog(@"addNewSchoolButtonClicked!");
    
    
    // Delete all existing documents
    CouchQuery* q = [self.database getAllDocuments];
    
    // Q: It looks like we can only remove one row at a time, how to do the bulk delete?
    // A: 
    for (int i=0; i<[q.rows count]; i++) {
        CouchQueryRow *row = [q.rows rowAtIndex:i];
        [self.database deleteDocuments:[NSArray arrayWithObject:[row document]]];
    }
    NSLog(@"------ DELETE EXECUTED ----");
    NSLog(@"Total docs : %d", [self.database getDocumentCount]);
    
    
    NSString *schoolName = ((UITextField *)[self.view viewWithTag:kTagUISchoolNameTextField]).text;
    schoolName = [schoolName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] ;
    
    if ( schoolName && ![@"" isEqualToString: schoolName]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0]; 
        [dict setValue:schoolName forKey:@"name"];
        
        CouchDocument *doc = [self.database untitledDocument];
        RESTOperation *op = [doc putProperties:dict];
        
        if (op.isSuccessful) {
            NSLog(@"documentID : %@", [doc documentID]);
            NSLog(@"properties : %@", [doc properties]);
                   }else{
            NSLog(@"Error occured: %@", op.error.localizedDescription);
        }
        
        NSLog(@"Total docs : %d", [self.database getDocumentCount]);

    }else{
        [self printOutDocs];
        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"提示" message:@"不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alert show];
		[alert release];
    }
    
}


-(void)printOutDocs{
    CouchQuery* q = [self.database getAllDocuments];
    
    for (int i=0; i<[q.rows count]; i++) {
        CouchQueryRow *row = [q.rows rowAtIndex:i];
        NSLog(@"documentID :  %@", [row documentID]);
        NSLog(@"documentRevision : %@", [row documentRevision] );
        
        if ([@"曲阳第四小学" isEqualToString: [[row documentProperties] valueForKey:@"name"]]) {
            NSLog(@"!!!!!!!!!");
        }
    }
}

@end
