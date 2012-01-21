//
//  DeputyAreaSelectionViewController.m
//  StudyCouchDB
//
//  Created by realalien on 12-1-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DeputyAreaPickerController.h"


static const int AREA_NAME_PICKER_COMPONENT = 0;
static const int AREA_NUMBER_PICKER_COMPONENT = 1;

enum {
  kTagUIAreaPicker
};


@implementation DeputyAreaPickerController

@synthesize areas;
@synthesize delegate;

@synthesize currentAreaNameSelectionIndex ; 
@synthesize currentAreaNumberSelectionIndex ; 

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
//    CGFloat width = 300;
//    CGFloat height = 200;
//    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
//    v.backgroundColor = [UIColor whiteColor];
//    self.view = v;
//    [v release];
    
    // One picker with two components.
    UIPickerView *areaName = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
    areaName.backgroundColor = [UIColor blueColor];
    areaName.delegate = self;
    areaName.dataSource = self;
    areaName.showsSelectionIndicator = YES;
    areaName.tag = kTagUIAreaPicker;
    self.view  = areaName;
//    [self.view addSubview:areaName];
    [areaName release];
    
    
    //    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(300.0, 200.0);
    self.areas = [NSMutableDictionary dictionary];
    
    
    
    // Dummy data
    NSString* Hongkou = @"HongKou";
    NSString* BaoShan = @"BaoShan";
    NSString* ZhaBei = @"ZhaoBei";
    [areas setValue:[NSArray  arrayWithObjects:@"1",@"2",@"3", nil] forKey:Hongkou];
    [areas setValue:[NSArray  arrayWithObjects:@"1",@"2",@"3",@"4", nil] forKey:BaoShan];
    [areas setValue:[NSArray  arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6", nil] forKey:ZhaBei];
    
    self.currentAreaNameSelectionIndex = -1 ;   // -1:no selection
    self.currentAreaNumberSelectionIndex = -1; 
    
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    

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


-(void)dealloc {
    // Q: What's the point of release and set to nil?  A: 
    [areas release]; areas = nil;
    delegate = nil;
}

#pragma mark -
#pragma mark UIPickerViewDelegate methods


// TODO: we need to change the default the behavior, only select by tapping on the item. Shall I customize the row view?
// REF: UICatalog source code http://developer.apple.com/library/ios/#samplecode/UICatalog/Introduction/Intro.html#//apple_ref/doc/uid/DTS40007710-Intro-DontLinkElementID_2
// REF: http://stackoverflow.com/questions/7579133/ios-how-to-add-a-custom-selectionindicator-to-a-uipickerview

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    // Handle the selection
    
    if ( delegate !=  nil) {
        if (component == AREA_NAME_PICKER_COMPONENT) {
            NSString *areaName = [[self.areas allKeys] objectAtIndex:row];
            [delegate areaNameSelected:areaName];
        } else if (component == AREA_NUMBER_PICKER_COMPONENT) {
            
            // FIXME: the keys is not determined, can't get value from row info!
            NSString *areaNameKey = [[self.areas allKeys] objectAtIndex:row]; // TODO: should depend on the first component!
            NSString *areaNumber = [[self.areas valueForKey:areaNameKey] objectAtIndex:row];
            [delegate areaNumberSelected:areaNumber];
        }                                
    }
}

// tell the picker how many rows are available for a given component
// Q: What if the second component' rows depends on the 1st component, how to calculate 
// A: 
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == AREA_NAME_PICKER_COMPONENT) { // area name
        return [[self.areas allKeys] count];
    }else if( component == AREA_NUMBER_PICKER_COMPONENT) {
        return 3;
    }
    return 0;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title = nil ;
    // title = @""; [@"" stringByAppendingFormat:@"%d",row];
    if (component == AREA_NAME_PICKER_COMPONENT ) {
        title = [[self.areas allKeys] objectAtIndex:row];
    }else if ( component == AREA_NUMBER_PICKER_COMPONENT ) {
        NSString *areaNameKey = [[self.areas allKeys] objectAtIndex:row]; // TODO: should depend on the first component!
        title = [[self.areas valueForKey:areaNameKey] objectAtIndex:row];
    }

    return title;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 0 ;
    if ( component == AREA_NAME_PICKER_COMPONENT ) {
        sectionWidth = 180 ; // TODO: estimate based on the longest text length.
    }else if ( component == AREA_NUMBER_PICKER_COMPONENT) {
        sectionWidth = 120 ;
    }
    
    return sectionWidth;
}


@end
