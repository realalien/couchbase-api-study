//
//  AddNewDeputyViewController.m
//  StudyCouchDB
//
//  Created by realalien on 12-1-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AddNewDeputyViewController.h"
#import "UIFactory.h"
#import "DeputyAreaPickerController.h"
enum {
    kTagUITextFieldDeputyName,
    kTagUIButtonDeputyArea
};

@interface AddNewDeputyViewController  ()
-(void)createToolbar ;
@end


@implementation AddNewDeputyViewController

@synthesize areaPicker ;
@synthesize areaPickerPopup;

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
    // Q: It looks like that the size is not effective. Why?
    // A:
    CGFloat width = 500.0;
    CGFloat height = 400.0;
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    v.backgroundColor = [UIColor whiteColor];
    self.view = v;
    [v release];
    
    //  ------- TOOLBAR
    [self createToolbar];

    
//    // Title label, deprecated: in toolbar rather than in view
//    CGFloat widthTitle = 300;
//    CGFloat heightTitle = 50;
//    UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake( (width-widthTitle)/2, 80, widthTitle, heightTitle)];
//    l.text = @"Add a new deputy information";
//    l.font = [UIFont systemFontOfSize:20.0];
//    l.textAlignment = UITextAlignmentCenter;
//    [self.view addSubview:l];
//    [l release];
    
    // Thumbernail for user guide
    
    
    // Deputy name
    CGFloat widthTextField = 250;
    CGFloat heightTextField = 20;
    UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake( (width-widthTextField)/2, 125, widthTextField, heightTextField) ]; 
    tf.placeholder = @"Input the nominee's name"; // TODO: l10n
    tf.borderStyle = UITextBorderStyleRoundedRect;
    tf.tag = kTagUITextFieldDeputyName;
    [self.view addSubview:tf];
    [tf release];
    
    // nominee's political area + number , use a button and a picker(within a popup)
    CGFloat widthAreaLabel = 250;
    CGFloat heightAreaLabel = 20;
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    b.frame = CGRectMake( (width-widthAreaLabel)/2, 175, widthAreaLabel, heightAreaLabel);
    [b setTitle:@"Select the area of the anominee" forState:UIControlStateNormal];
    b.tag = kTagUIButtonDeputyArea;
    [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [b addTarget:self action:@selector(selectAreaButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b];
    [b release];
    
    // Q: If we use multiple controller, how to pass around the data  A:
    
    
    
    // IDEA: create a general table view ui for creating key/value attribute, both can be modified.
    
    
    
}


-(void)createToolbar{
    UIToolbar *toolBar;
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 500, 50)];
    toolBar.frame = CGRectMake(0, 0, 500, 50);
    toolBar.barStyle = UIBarStyleDefault;
    [toolBar sizeThatFits:CGSizeMake(500, 50)]; 
    
    // --- Cancel and Done buttons
    UIBarButtonItem *flexibleSpace = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelAction:)] autorelease];
//    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneAction:)];
    UIBarButtonItem *doneButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                                                                target:self 
                                                                                action:@selector(doneAction:)] autorelease];
    // --- Title
    // How to add title to the toolbar 
    //REF: http://stackoverflow.com/questions/1319834/proper-way-to-add-a-title-to-a-modal-view-controllers-toolbar
    
//    // Title frame option #1
    NSString *titleString = @"Add a new nominee's information"; //NSLocalizedString(@"Back", nil);
    const CGFloat cancelButtonWidth = [@"Cancel" sizeWithFont:[UIFont boldSystemFontOfSize:[UIFont buttonFontSize]]
                                      constrainedToSize:toolBar.frame.size].width;
    const CGRect titleFrame = {{0.0f, 0.0f},
        {toolBar.frame.size.width - (cancelButtonWidth * 2.0f),50.0f}};
    
//    // Title frame option #2
//    CGFloat textWidth = [UIFactory estimateWidthFromText: @"Add new nominee information"
//                                                withFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]
//                                       withAllowedHeight:44.0
//                                           lineBreakMode:UILineBreakModeWordWrap];
//    UILabel* l = [[UILabel alloc] initWithFrame:CGRectMake( (toolBar.frame.size.width - textWidth) / 2  ,
//                                                           10.0f, 
//                                                           textWidth, 
//                                                           44.0f )]; 
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
    [titleLabel setText:titleString];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextAlignment:UITextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:20.0f]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setShadowColor:[UIColor colorWithWhite:0.0f alpha:0.5f]];
    [titleLabel setShadowOffset:CGSizeMake(0.0f, -1.0f)];
    
    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithCustomView:titleLabel];
    [titleLabel release];

    NSArray *barButtons  =   [[NSArray alloc] initWithObjects:cancelButton,flexibleSpace,titleItem,flexibleSpace,doneButton,nil];
    [toolBar setItems:barButtons];
    
    [self.view addSubview:toolBar];
    [toolBar release];
    [barButtons release];
    barButtons = nil;
    
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

-(void) dealloc{
    [areaPicker release];
    [areaPickerPopup release];
}

#pragma mark -
#pragma mark AreaPickerDelegate methods

- (void)areaNameSelected:(NSString *)areaName{
    NSLog(@"areaName : %@  selected!", areaName);
}

- (void)areaNumberSelected:(NSString *)areaNumber{
    NSLog(@"areaNumber : %@  selected!", areaNumber);
}


#pragma mark -
#pragma mark callback methods


-(void)cancelAction:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)doneAction:(id)sender{
    // data validation
    
    // save to database
    
    
    // or navigate to other view controll for sharing or data digging!
}

-(void)selectAreaButtonClicked:(id)sender{
    
    if (areaPicker == nil) {
        areaPicker = [[DeputyAreaPickerController alloc] init]; 
        areaPicker.delegate = self;
        self.areaPickerPopup = [[[UIPopoverController alloc] 
                                    initWithContentViewController:areaPicker] autorelease];               
    }
    
    [self.areaPickerPopup presentPopoverFromRect:[self.view viewWithTag:kTagUIButtonDeputyArea].frame
                                          inView:self.view
                        permittedArrowDirections:UIPopoverArrowDirectionUp
                                        animated:YES];
    
    // NOTE: can't use presentPopoverFromBarButtonItem... as the popup comes from a UIButton who has no uiview as instance.
//    [self.areaPickerPopup presentPopoverFromBarButtonItem:sender 
//                                    permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}




@end
