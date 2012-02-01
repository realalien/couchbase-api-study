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
static int MAX_AREA_NUMBER_FOR_PICKER = 150;

enum {
  kTagUIAreaPicker
};


@implementation DeputyAreaPickerController

//@synthesize areas;
@synthesize areaNames;
@synthesize delegate;

@synthesize currentAreaNameSelection ; 
@synthesize currentAreaNumberSelection ; 

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
//    self.areas = [NSMutableDictionary dictionary];
    
    areaNames = [[NSMutableArray alloc] initWithCapacity:0];
    
    // Q: how to manage localization of the data? for data storage and for client?
    // A: 
//    [areaNames addObjectsFromArray:[NSArray arrayWithObjects:@"Pudong New",@"Huangpu", // @"Luwan" merged into Huangpu in 2011.7.9,
//                                    @"Xuhui",@"Changning",
//                                    @"Jing'an",@"Putuo", @"Zhaobei",
//                                    @"Hongkou",@"Yangpu",@"Baoshan",
//                                    @"Minhang",@"Jiading",@"Jinshan",
//                                    @"Songjaing",@"Fengxian",@"Qingpu", nil] ];
    
    // EXP, storage to be human readable form
    [areaNames addObjectsFromArray:[NSArray arrayWithObjects:@"浦东新区",@"黄浦区", // @"卢湾区" merged into Huangpu in 2011.7.9,
                                    @"徐汇区",@"长宁区",
                                    @"静安区",@"普陀区", @"闸北区",
                                    @"虹口区",@"杨浦区",@"宝山区",
                                    @"闵行区",@"嘉定区",@"金山区",
                                    @"松江区",@"奉贤区",@"青浦区", nil] ];
    
    // IDEA:  we shall listen to an official web page to keep track of changes, e.g. two district merges.
    
    // IDEA: ESP. to make i18n simple when dealing with UI, we can borrow the idea of common select data objects. EXP. to see if we can setup data structure to avoid static modeling, i.e. parse the data by rules(e.g. singel record should have data for i18n, )
    
//    // Dummy data
//    NSString* Hongkou = @"HongKou";
//    NSString* BaoShan = @"BaoShan";
//    NSString* ZhaBei = @"ZhaoBei";
//    [areas setValue:[NSArray  arrayWithObjects:@"1",@"2",@"3", nil] forKey:Hongkou];
//    [areas setValue:[NSArray  arrayWithObjects:@"1",@"2",@"3",@"4", nil] forKey:BaoShan];
//    [areas setValue:[NSArray  arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6", nil] forKey:ZhaBei];
    
//    self.currentAreaNameSelection = nil ;   // -1:no selection
//    self.currentAreaNumberSelection =  nil; 
    
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // TODO: such iteration is tedious, try to make it more general! E.G. study the xms's app!
    if (self.currentAreaNameSelection) {
        for (int i=0; i< [areaNames count]; i++) {
            if ([[areaNames objectAtIndex:i] isEqualToString:self.currentAreaNameSelection ]) {
                [((UIPickerView*)[self.view viewWithTag:kTagUIAreaPicker]) selectRow:i 
                                                                         inComponent:AREA_NAME_PICKER_COMPONENT
                                                                            animated:YES];
                break;
            }
        }
    }
    
    if (self.currentAreaNumberSelection) {
        for (int i=0; i< MAX_AREA_NUMBER_FOR_PICKER; i++) {
            if ([[areaNames objectAtIndex:i] isEqualToString:self.currentAreaNameSelection ]) {
                [((UIPickerView*)[self.view viewWithTag:kTagUIAreaPicker]) selectRow:i 
                                                                         inComponent:AREA_NUMBER_PICKER_COMPONENT
                                                                            animated:YES];
                break;
            }
        }
    }

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
//    [areas release]; areas = nil;
    [areaNames release]; areaNames = nil;
    
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
            NSString *areaName = [areaNames objectAtIndex:row];
            [delegate areaNameSelected:areaName];
        } else if (component == AREA_NUMBER_PICKER_COMPONENT) {
            [delegate areaNumberSelected:[NSString stringWithFormat:@"%d", row + 1]]; // human count starting from 1 instead of 0.
        }                                
    }
}

// tell the picker how many rows are available for a given component
// Q: What if the second component' rows depends on the 1st component, how to calculate 
// A: 
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == AREA_NAME_PICKER_COMPONENT) { // area name
        return [areaNames count];
    }else if( component == AREA_NUMBER_PICKER_COMPONENT) {
        return MAX_AREA_NUMBER_FOR_PICKER; // TODO: give an estimate or interface for changing. better not hard coded!
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
        title = [ areaNames objectAtIndex:row];
    }else if ( component == AREA_NUMBER_PICKER_COMPONENT ) {
        title = [ NSString stringWithFormat:@"第%d选区", row + 1];
    }

    return title;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 0 ;
    if ( component == AREA_NAME_PICKER_COMPONENT ) {
        sectionWidth = 160 ; // TODO: estimate based on the longest text length.
    }else if ( component == AREA_NUMBER_PICKER_COMPONENT) {
        sectionWidth = 140 ;  // IDEA: if better using golden line!
    }
    
    return sectionWidth;
}


@end
