//
//  AddNewDeputyViewController.m
//  StudyCouchDB
//
//  Created by realalien on 12-1-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AddNewDeputyViewController.h"
#import "DeputyAreaPickerController.h"

#import "Foundation-AddsOn.h"
#import "UICustomSwitch.h"
#import "UIFactory.h"

#import <MapKit/MapKit.h>

#define kDeputyNominees @"deputy-nominees"

enum {
    kTagUITextFieldDeputyName = 10, // TODO: strange that in callback method, the view with zero index is self.view?!
    kTagUIButtonDeputyArea,
    
    kTagUILabelreportGPSprompt, //
    kTagUISwitchIsReportGPS,
    kTagUILabelGPS,
    
    kTagAlertSaveDocumentSuccess
};

@interface AddNewDeputyViewController  ()
-(void)createToolbar;
-(void)refreshAreaUI;
-(void)handleReportGPSSwitch:(id)sender;

- (void)showErrorAlert: (NSString*)message forOperation: (RESTOperation*)op;
@end


static NSString* DATA_KEY_nominee_area = @"NOMINEE_AREA";
static NSString* DATA_KEY_nominee_number = @"NOMINEE_NUMBER";
static NSString* DATA_KEY_USE_GPS = @"IS_REPORT_GPS";
static NSString* DATA_KEY_GPS_LAT_LNG = @"GPS_LAT_LNG";

@implementation AddNewDeputyViewController

@synthesize tempData;

@synthesize areaPicker ;
@synthesize areaPickerPopup;

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
    
    // nominee's political area + number , use a button and a picker(within a popup)
    CGFloat widthAreaLabel = 350;
    CGFloat heightAreaLabel = 30;
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    b.frame = CGRectMake( (width-widthAreaLabel)/2, 125, widthAreaLabel, heightAreaLabel);
    [b setTitle:@"请选择代表人所在的行政区和选区编号" forState:UIControlStateNormal];
    b.tag = kTagUIButtonDeputyArea;
    [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [b addTarget:self action:@selector(selectAreaButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b];
    // autoreleased! [b release];
    
    // Q: If we use multiple controller, how to pass around the data  A:
    
    // Deputy name
    // NOTE: only a minority of people will input the name, most people should select from a list or their nominees and 
    CGFloat widthTextField = 250;
    CGFloat heightTextField = 30;
    UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake( (width-widthTextField)/2, 175, widthTextField, heightTextField) ]; 
    tf.placeholder = @"请填写代表人的姓名"; // TODO: l10n
    tf.font = [UIFont systemFontOfSize:18];
    tf.textAlignment = UITextAlignmentCenter;
    tf.borderStyle = UITextBorderStyleRoundedRect;
    tf.tag = kTagUITextFieldDeputyName;
    [self.view addSubview:tf];
    [tf release];
    
    // a check box for indicating current user location is in the nominee's area, for later data minding.
    // REF: a quick solution can be retrieved from: http://stackoverflow.com/questions/5368196/how-create-simple-checkbox
    
    // EXP.
    CGFloat widthUseGPSLabel = 350;
    CGFloat heightUseGPSLabel = 30;
    UILabel *reportGPSprompt = [UIFactory makeDefaultLabelWithText:@"请确认您当前位置是否在代表人的选区" andTag:kTagUILabelreportGPSprompt];
    reportGPSprompt.frame = CGRectMake( (width-widthUseGPSLabel)/2 - 30, 225, widthUseGPSLabel, heightUseGPSLabel);
    [self.view addSubview:reportGPSprompt];
    // autoreleased! [reportGPSprompt release];
    
    UICustomSwitch *isReportGPS = [UICustomSwitch switchWithLeftText:@"是" andRight:@"不是"];
    isReportGPS.frame = CGRectMake((width-widthUseGPSLabel)/2 + 300, 225, 95,27);
    [isReportGPS setOn:NO animated:NO]; // NOTE: use setOn rather than isReportGPS.on = NO;  // default is NO
    isReportGPS.tag = kTagUISwitchIsReportGPS;
    [isReportGPS addTarget:self action:@selector(handleReportGPSSwitch:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:isReportGPS];
    // autoreleased! [isReportGPS release];
    
    CGFloat widthGPSLabel = 350;
    CGFloat heightGPSLabel = 30;
    UILabel *gpsLabel = [UIFactory makeDefaultLabelWithText:@"您现在的地理位置：(等待GPS信息)" andTag:kTagUILabelGPS];
    gpsLabel.font = [UIFont systemFontOfSize:12];
    gpsLabel.textAlignment = UITextAlignmentCenter;
    gpsLabel.frame = CGRectMake( (width-widthGPSLabel)/2, 260, widthGPSLabel, heightGPSLabel);
    [self.view addSubview:gpsLabel];
    

    
    // IDEA: create a general table view ui for creating key/value attribute, both can be modified.    
    
    
}


-(void)createToolbar{
    UIToolbar *toolBar;
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 500, 50)];
    toolBar.frame = CGRectMake(0, 0, 500, 50);
    toolBar.barStyle = UIBarStyleDefault;
    [toolBar sizeThatFits:CGSizeMake(500, 50)]; 
    
    // --- Cancel and Done buttons
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] ;
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelAction:)] ;
//    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneAction:)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleBordered target:self action:@selector(doneAction:)] ; // TODO: highlight!
    
//    UIBarButtonItem *doneButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
//                                                                                target:self 
//                                                                                action:@selector(doneAction:)] autorelease];
    // --- Title
    // How to add title to the toolbar 
    //REF: http://stackoverflow.com/questions/1319834/proper-way-to-add-a-title-to-a-modal-view-controllers-toolbar
    
//    // Title frame option #1
    NSString *titleString = @"添加代表人信息"; //NSLocalizedString(@"Back", nil);
    const CGFloat cancelButtonWidth = [@"取消" sizeWithFont:[UIFont boldSystemFontOfSize:[UIFont buttonFontSize]]
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
    
    [cancelButton release];
    [flexibleSpace release];
    [titleItem release];
    [doneButton release];
    
    // TODO: probably we need a timer to periodically get updated here! Find best practice!
    [LocationController sharedInstance].delegate = self;
 }



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];  
    
    // request for a update
    [[LocationController sharedInstance] start];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];  
    
    // request for a update
    [[LocationController sharedInstance] stop];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableDictionary *d= [[NSMutableDictionary alloc] init];
    self.tempData = d;
    [d release];

    // temp: for test
    UICustomSwitch* reportGPS = (UICustomSwitch*)[self.view viewWithTag:kTagUISwitchIsReportGPS];
    if (reportGPS != nil) {
        [tempData setValue:[NSNumber numberWithBool:reportGPS.on] forKey:DATA_KEY_USE_GPS]; // set default , TODO: should load from preset if existing data.
        [reportGPS setOn:NO animated:YES];
    }

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
     [[LocationController sharedInstance] stop];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

-(void) dealloc{
    [tempData release];
    
    [areaPicker release];
    [areaPickerPopup release];
}

#pragma mark -
#pragma mark AreaPickerDelegate methods

- (void)areaNameSelected:(NSString *)areaName{
    NSLog(@"areaName : %@  selected!", areaName);
    [self.tempData setValue:areaName forKey:DATA_KEY_nominee_area];
    
    [self refreshAreaUI];
}

- (void)areaNumberSelected:(NSString *)areaNumber{
    NSLog(@"areaNumber : %@  selected!", areaNumber);
    [self.tempData setValue:areaNumber forKey:DATA_KEY_nominee_number];
    
    [self refreshAreaUI];
}

#pragma mark -
#pragma mark LocationControllerDelegate methods

- (void)locationUpdate:(CLLocation*)location{
    // update GPS lat lng, TODO: avoid race condition as the lat and lng is always on the update!
//    if ( [[LocationController sharedInstance] locationKnown]) {
//        CLLocation* current = [[LocationController sharedInstance] currentLocation];
//        [tempData setValue:current forKey:DATA_KEY_GPS_LAT_LNG];
    if (self.tempData) {
        [self.tempData setValue:location forKey:DATA_KEY_GPS_LAT_LNG];
        // NOTE: do not stop location manager here, considering that user is on the move!
    }
        
//        UILabel *l = (UILabel*)[self.view viewWithTag:kTagUILabelGPS];
//        if (l ) {  // Q: why it is not working? " && [[LocationController sharedInstance]locationKnown ]" A:
////            l.text = [NSString stringWithFormat:@"您现在的地理位置：(%f, %f)",location.coordinate.latitude, location.coordinate.longitude];
//            l.text = [NSString stringWithFormat:@"您现在的地理位置：(%f, %f)",
//                      [[LocationController sharedInstance]currentLocation].coordinate.latitude, 
//                      [[LocationController sharedInstance]currentLocation].coordinate.longitude];
//        }
//    }
    
    UILabel* l = (UILabel*)[self.view viewWithTag:kTagUILabelGPS];
    if (l ) {
        l.text = [NSString stringWithFormat:@"您现在的地理位置：(%f,%f)", 
                  location.coordinate.latitude, 
                  location.coordinate.longitude ];
    }
}

#pragma mark -
#pragma mark callback methods


-(void)cancelAction:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)doneAction:(id)sender{
    // data validation
    // TODO: more robust sanity check like active_record, IDEA: more validation be handled at the server side?!
    UIView* target = [self.view viewWithTag:kTagUITextFieldDeputyName];
    NSString* name = ((UITextField*)target).text;
    if ([tempData valueForKey:DATA_KEY_nominee_area]
        && [tempData valueForKey:DATA_KEY_nominee_number]
        && ([name isNotEmpty]) ) {
        // save to database
        NSLog(@"Going to save to the database");
        
        // Ensure database creation
        self.database = [[CouchbaseServerManager getServer] databaseNamed: kDeputyNominees];
//#if !INSTALL_CANNED_DATABASE && !defined(USE_REMOTE_SERVER)
        // Create the database on the first run of the app.
        NSError* error;
        if (![self.database ensureCreated: &error]) {
            [self showAlert: @"Couldn't create local database." error: error fatal: YES];
            return;
        }
//#endif
        database.tracksChanges = YES;

        // IDEA: some reflective methods to avoid burden of maintenance.
        // Insert data
        // Create the new document's properties:
        
        // TODO: make conversion into general class
        NSString *plainGPS = [NSString stringWithFormat:@"(%f,%f)",
                              ((CLLocation*)[tempData valueForKey:DATA_KEY_GPS_LAT_LNG]).coordinate.latitude,  
                              ((CLLocation*)[tempData valueForKey:DATA_KEY_GPS_LAT_LNG]).coordinate.longitude];
        
        NSDictionary *inDocument = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    [tempData valueForKey:DATA_KEY_nominee_area], @"area_name",
                                    [tempData valueForKey:DATA_KEY_nominee_number], @"area_number",
                                    name,@"nominee_name",
                                    [tempData valueForKey:DATA_KEY_USE_GPS], @"is_report_gps",
                                    plainGPS, @"lat_lng", //  
                                    [RESTBody JSONObjectWithDate: [NSDate date]], @"created_at",
                                    @"person", @"doc_type", // TODO: doc_type would be better to managed in one place.
                                    nil];
        
        // Save the document, asynchronously:
        CouchDocument* doc = [database untitledDocument];
        RESTOperation* op = [doc putProperties:inDocument];
        [op onCompletion: ^{
            [inDocument release]; // TODO: research on best place for release.
            if (op.error){
                [self showErrorAlert: @"Couldn't save the new item" forOperation: op];
            }else {
                // TODO: handle the different responses from the server side. e.g. add more 
                [self showAlert:@"保存成功！" tag:kTagAlertSaveDocumentSuccess];
            }
            // Re-run the query:
//            [self.dataSource.query start];
        }];
        [op start];
        
        
    }
    
    
    // or navigate to other view controll for sharing or data digging!
}

-(void)selectAreaButtonClicked:(id)sender{
    
    if (areaPicker == nil) {
        areaPicker = [[DeputyAreaPickerController alloc] init]; 
        areaPicker.delegate = self;
        if ( !self.areaPickerPopup) {
            self.areaPickerPopup = [[[UIPopoverController alloc] 
                                     initWithContentViewController:areaPicker] autorelease]; 
            self.areaPickerPopup.delegate = self;
        }
    }
    
    // selection data for the picker.
    // IDEA: Better if in the middle of the picker selection.
    if ([tempData valueForKey:DATA_KEY_nominee_area]) {
        areaPicker.currentAreaNameSelection = [tempData valueForKey:DATA_KEY_nominee_area];
    }
    
    if ([tempData valueForKey:DATA_KEY_nominee_number] ) {
        areaPicker.currentAreaNumberSelection = [tempData valueForKey:DATA_KEY_nominee_number];
    }
    
    [self.areaPickerPopup presentPopoverFromRect:[self.view viewWithTag:kTagUIButtonDeputyArea].frame
                                          inView:self.view
                        permittedArrowDirections:UIPopoverArrowDirectionUp
                                        animated:YES];
    
    // NOTE: can't use presentPopoverFromBarButtonItem... as the popup comes from a UIButton who has no uiview as instance.
//    [self.areaPickerPopup presentPopoverFromBarButtonItem:sender 
//                                    permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}


#pragma mark -
#pragma mark UIPopoverControllerDelegate methods
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    if (![tempData valueForKey:DATA_KEY_nominee_area]) {
        [self.tempData setValue:@"浦东新区" forKey:DATA_KEY_nominee_area]; // TODO: code smell
    }
    
    if (![tempData valueForKey:DATA_KEY_nominee_number]) {
        [self.tempData setValue:@"1" forKey:DATA_KEY_nominee_number];
    }
    
    [self refreshAreaUI];
    
}


#pragma mark -
#pragma mark UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == kTagAlertSaveDocumentSuccess) {
        [self dismissModalViewControllerAnimated:YES];
    }
    
    // if error occurs, user should retry 'Save/Done' or 'Cancel' explicitly.
}


#pragma mark -
#pragma mark utilities

-(void)refreshAreaUI{
    UIButton* areaButton = (UIButton*)[self.view viewWithTag:kTagUIButtonDeputyArea];
    if ( [self.tempData valueForKey:DATA_KEY_nominee_area]
        &&  [self.tempData valueForKey:DATA_KEY_nominee_number]) {
        NSString* areaInfo = [NSString stringWithFormat:@"%@ 第%@选区",
                                        [self.tempData valueForKey:DATA_KEY_nominee_area], 
                                        [self.tempData valueForKey:DATA_KEY_nominee_number] ];
        [areaButton setTitle:areaInfo forState:UIControlStateNormal];
    }
}

- (void)showErrorAlert: (NSString*)message forOperation: (RESTOperation*)op {
    [super showAlert: message error: op.error fatal: NO];
}


#pragma mark -
#pragma mark callback methods
-(void)handleReportGPSSwitch:(id)sender {
    UICustomSwitch* reportGPS = (UICustomSwitch*)[self.view viewWithTag:kTagUISwitchIsReportGPS];
    
    if (reportGPS != nil) {
        if (reportGPS.on) {
            // NOTE: * do NOT change UI here as user fires the UI change! 
            //       * also, when switch changed, on is also set.
            [tempData setValue:[NSNumber numberWithBool:YES] forKey:DATA_KEY_USE_GPS];
        }else {
            [tempData setValue:[NSNumber numberWithBool:NO] forKey:DATA_KEY_USE_GPS];
        }
    }
}

@end
