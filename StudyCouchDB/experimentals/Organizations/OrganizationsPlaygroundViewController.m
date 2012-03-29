//
//  OrganizationsPlaygroundViewController.m
//  StudyCouchDB
//
//  Created by d d on 12-3-13.
//  Copyright (c) 2012年 d. All rights reserved.
//

#import "Foundation-AddsOn.h"
#import "OrganizationSlideView.h"
#import "OrganizationsPlaygroundViewController.h"

#import <QuartzCore/QuartzCore.h>

enum {
    kTagStyleContainer = 100,
    kTagBoxSample_1,
    kTagBoxSample_2
};



// -------------------------

@interface OrganizationConnection :UIView 

// Two UIViews on which to create a connection.
@property (nonatomic,retain) UIView *v1;
@property (nonatomic,retain) UIView *v2;

@end

@implementation OrganizationConnection

@synthesize v1;
@synthesize v2;


-(id)initWithTwoViewsV1:(UIView*)vi andV2:(UIView*)vii{ //  inParentView:(UIView*)twoViewsParent
    if (vi && vii) {
        self.v1 = vi;
        self.v2 = vii;
        // Experiment, use v1,v2 to decide the the view location and bounds!
        
        // connections on both origin
        [self initWithFrame:CGRectMake(v1.frame.origin.x, 
                                       v1.frame.origin.y, 
                                       v2.frame.origin.x - v1.frame.origin.x, 
                                       v2.frame.origin.y - v1.frame.origin.y)];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *p = [UIBezierPath bezierPath];
    CGPoint src = CGPointMake(0, 0); // NOTE: when drawing, think it as in its own space,no knowledge of outside value!!   v1.frame.origin;
    
    //src = CGPointMake(0, 0); // [[self.view viewWithTag:kTagStyleContainer] convertPoint:src toView:self.view];
    //    src = [self.view convertPoint:src fromView:[self.view viewWithTag:kTagStyleContainer]];
    [p moveToPoint:src];
    
    CGPoint dest = CGPointMake(self.frame.size.width, self.frame.size.height);
    //dest =  CGPointMake(600, 600); //[[self.view viewWithTag:kTagStyleContainer] convertPoint:dest toView:self.view];
    //    dest = [self.view convertPoint:dest fromView:[self.view viewWithTag:kTagStyleContainer]];
    
    [p addLineToPoint:dest];
    [[UIColor blackColor] setStroke];
    [[UIColor blackColor] setFill];
    [p stroke];
    [p fill];
    
}


-(void)dealloc{
    self.v1 = nil;
    self.v2 = nil;
    
    [super dealloc];
}

@end

// -------------------------

@interface OrganizationsPlaygroundViewController()
-(void)selectOrganizationUIView:(UIView*)v;
- (void)registerForKeyboardNotifications;
@end


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
    UIScrollView *v = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
    v.pagingEnabled = NO;

    v.scrollEnabled = YES;
    v.userInteractionEnabled = YES;
    v.showsVerticalScrollIndicator = YES;
    v.showsHorizontalScrollIndicator = YES;
    self.view = v;
    [v release];
    
    // ---------- experiment with the boxes and connections
    UIView *stylesContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 500, 500)];
    stylesContainer.backgroundColor = [UIColor colorWithRed:223.0/255 green:243.0/255 blue:177.0/255 alpha:0.6] ;
    stylesContainer.tag = kTagStyleContainer;
    [self.view addSubview:stylesContainer];

    
    // style #1 - 
    // * transparent black box(round corner)
    // * one label near the bottom indicating the name of the organization
    // * Q: should the boxes keep one size or resizable with their names?
    
    UIView *blkbox = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 120, 160)];
    blkbox.tag = kTagBoxSample_1;
    blkbox.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6] ;
    [stylesContainer addSubview:blkbox];
    //blkbox.layer.cornerRadius = 10;
    NSString *s = @"江湾镇街道党工委";
    CGSize size =  [s sizeWithFont:[UIFont systemFontOfSize:16]
                 constrainedToSize:CGSizeMake(110, 18)
                     lineBreakMode:UILineBreakModeTailTruncation];
    UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake( (120 - size.width)/2, (160 - size.height)/2, size.width, size.height)];
    l.backgroundColor = [UIColor clearColor];
    l.font = [UIFont systemFontOfSize:16];
    l.text = s;
    l.textColor = [UIColor whiteColor];
    l.textAlignment = UITextAlignmentCenter;
    [blkbox addSubview:l];
    [l release];
    [blkbox release];
    
    // -------
    UIView *blkbox2 = [[UIView alloc]initWithFrame:CGRectMake(10*2 + 120 + 50, 10+160-120, 160,120)];
    blkbox2.tag = kTagBoxSample_2;
    blkbox2.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6] ;
    [stylesContainer addSubview:blkbox2];
    //blkbox2.layer.cornerRadius = 10;
    [blkbox2 release];
    
    size =  [s sizeWithFont:[UIFont systemFontOfSize:16]
                 constrainedToSize:CGSizeMake(150, 18)
                     lineBreakMode:UILineBreakModeTailTruncation];

    l = [[UILabel alloc]initWithFrame:CGRectMake( (160 - size.width)/2, (120 - size.height)/2, size.width, size.height)];
    l.backgroundColor = [UIColor clearColor];
    l.font = [UIFont systemFontOfSize:16];
    l.text = s;
    l.textColor = [UIColor whiteColor];
    l.textAlignment = UITextAlignmentCenter;
    [blkbox2 addSubview:l];
    [l release];
    
    
    // connection test

    // EXPERIMENT:  customize drawRect ...NOT working, it's inside a rectangular
    OrganizationConnection *oc = [[OrganizationConnection alloc]initWithTwoViewsV1:[stylesContainer viewWithTag:kTagBoxSample_1]
                                                                            andV2:[stylesContainer viewWithTag:kTagBoxSample_2]];
    [stylesContainer addSubview:oc];
    oc.backgroundColor = [UIColor clearColor];
    [oc release];
    

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
    
    // Tap for selection. NOTE: double tapping is not very natural for beginners, try to avoid use that interaction.
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    // Pan for moving UIView
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    panRecognizer.minimumNumberOfTouches = 1;    
    [self.view addGestureRecognizer:panRecognizer];
    
    ((UIScrollView*)self.view).contentSize = CGSizeMake(2048, 2048);
    
    // listen to keyboard event
    [self registerForKeyboardNotifications];
    
    
    // connections
    // EXPERIMENT: UIBezierPath
//    UIBezierPath *p = [UIBezierPath bezierPath];
//    CGPoint src = [[self.view viewWithTag:kTagStyleContainer] viewWithTag:kTagBoxSample_1].frame.origin;
//    
//    src = CGPointMake(0, 0); // [[self.view viewWithTag:kTagStyleContainer] convertPoint:src toView:self.view];
////    src = [self.view convertPoint:src fromView:[self.view viewWithTag:kTagStyleContainer]];
//    [p moveToPoint:src];
//    
//    CGPoint dest = [[self.view viewWithTag:kTagStyleContainer] viewWithTag:kTagBoxSample_2].frame.origin;
//    dest =  CGPointMake(600, 600); //[[self.view viewWithTag:kTagStyleContainer] convertPoint:dest toView:self.view];
////    dest = [self.view convertPoint:dest fromView:[self.view viewWithTag:kTagStyleContainer]];
//    
//    [p addLineToPoint:dest];
//    [[UIColor blackColor] setStroke];
//    [[UIColor blackColor] setFill];
//    [p stroke];
//    [p fill];
    
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

-(void)createUITextFieldForEditing:(UIView*)aView{
    if (!aView) {
        return; // do nothing
    }else{
        // create a text field at center.
        
        CGSize tfStandard = CGSizeMake(120, 20);
         
        UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake((aView.frame.size.width - tfStandard.width )/2 , (aView.frame.size.height - tfStandard.height)/2, tfStandard.width, tfStandard.height)];
//        UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake(aView.center.x - tfStandard.width/2 , aView.center.y - tfStandard.height/2, tfStandard.width, tfStandard.height)];
        
        
        tf.backgroundColor = [UIColor whiteColor];
        tf.textAlignment = UITextAlignmentCenter;
        tf.placeholder = @"请输入机构名称";
        tf.delegate = self;
        [self.currentSelectOrganizationView addSubview:tf];
//        [self.view addSubview:tf];
        [tf release];
        
        
    }
}

// NOTE: press in empty space to create new UIView, press on existing UIView goes to edit mode.
-(void)longPressWithGestureRecognizer:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan ) {
        NSLog(@"longPressWithGestureRecognizer ... began");
    }else if ([gestureRecognizer state] == UIGestureRecognizerStateEnded ) {
        NSLog(@"longPressWithGestureRecognizer ... ended");
        // create a organization slide view at the touch point if in empty space.
        CGPoint pos = [gestureRecognizer locationInView:self.view];
        NSLog(@"position is (%f, %f)", pos.x, pos.y );
        
        UIView *potentialPressedOn = [self.view hitTest:pos withEvent:nil];
        if (potentialPressedOn 
            && [[self.view subviews] containsObject:potentialPressedOn]
            && potentialPressedOn != self.view) { // check if pressed on subviews, then go to edit mode
            
            // also select new one 
            [self selectOrganizationUIView:potentialPressedOn];
            
            potentialPressedOn.backgroundColor = [UIColor blueColor];
            [self createUITextFieldForEditing:potentialPressedOn];
        }else{
            // TODO: try to avoid overlaying
            OrganizationSlideView *v = [[OrganizationSlideView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
            v.center = pos;
            v.backgroundColor = [UIColor greenColor];
            // TODO: also assign tag for persistence and create back from saved data.
            [self.view addSubview:v]; 
        }
 
    }
}

// NOTE: single tap to select and deselect.
// IDEA:TODO: even the long press(to create a uiview) is not natural, considering using drag-n-drop from existing widget!
-(void)tapGestureRecognizer:(UITapGestureRecognizer*)gestureRecognizer{
    NSLog(@"tapGestureRecognizer ... began");
    if ( [gestureRecognizer state] == UIGestureRecognizerStateEnded) {
        CGPoint pos = [gestureRecognizer locationInView:self.view];
        NSLog(@"position is (%f, %f)", pos.x, pos.y );
        
        // check the if touch insides a UIView created by longPressGesture
        UIView* viewYouWishToObtain = [self.view hitTest:pos withEvent:nil];
        if (viewYouWishToObtain && viewYouWishToObtain!=self.view) {
            [self selectOrganizationUIView:viewYouWishToObtain];
        }
    }
}

// NOTE: move the selected if any one.
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


#pragma mark -
#pragma mark UITextFieldDelegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    activeField = textField;
}

// NOTE: return to set the text for the UIView and resize the UIView.
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField.text isNotEmpty]) {
        // add UILabel with the text and resize the UIView in editing
        NSString *t = textField.text;
        CGSize s = [t sizeWithFont:[UIFont systemFontOfSize:16]
                 constrainedToSize:CGSizeMake(120, 18)
                     lineBreakMode:UILineBreakModeTailTruncation];
        
        UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, s.width, s.height)];
        l.textColor = [UIColor blackColor];
        l.backgroundColor = [UIColor clearColor];
        l.font = [UIFont systemFontOfSize:16];
        l.text = t;
        
        if (self.currentSelectOrganizationView) {  // TODO: make long press on existing uiview as selection action.
            // add label component
            [self.currentSelectOrganizationView addSubview:l];
            // resize the UIView
            self.currentSelectOrganizationView.frame = CGRectMake(self.currentSelectOrganizationView.frame.origin.x, 
                                                                  self.currentSelectOrganizationView.frame.origin.y,
                                                                  l.frame.size.width, 
                                                                  l.frame.size.height);
            self.currentSelectOrganizationView.backgroundColor = [UIColor yellowColor];
        }
     
        [l release];
    }
    
    // remove the textField anyway.
    [textField resignFirstResponder];
    [textField removeFromSuperview]; //TODO: did it do the clean?
    
    // unset current highlight
    self.currentSelectOrganizationView = nil;
    
    
    return YES;
}



#pragma mark -
#pragma mark Private methods

-(void)selectOrganizationUIView:(UIView*)v{
    if ( v && v!= self.view && v!= [self.view viewWithTag:kTagStyleContainer]) { // excluding the containers
        if ( !self.currentSelectOrganizationView){
            self.currentSelectOrganizationView = v;
            self.currentSelectOrganizationView.backgroundColor = [UIColor redColor];
        }else {// already there is a selection
            if (v == self.currentSelectOrganizationView) { // deselect
                self.currentSelectOrganizationView.backgroundColor = [UIColor greenColor];
                self.currentSelectOrganizationView = nil;
            }else{ // assign new selection
                self.currentSelectOrganizationView.backgroundColor = [UIColor greenColor]; // set original selection back to normal
                self.currentSelectOrganizationView = v;
                self.currentSelectOrganizationView.backgroundColor = [UIColor redColor];
            }
        }
    }else {
        // possible interaction with self.view
    }
}


#pragma mark -
#pragma mark keyboard related

- (void)registerForKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}


// Called when the UIKeyboardDidShowNotification is sent.
// REF:http://jason.agostoni.net/2011/02/12/ipad-resize-view-to-account-for-keyboard/  and its comments
// REF: https://developer.apple.com/library/ios/#documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/KeyboardManagement/KeyboardManagement.html#//apple_ref/doc/uid/TP40009542-CH5-SW7
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    kbRect = [self.view convertRect:kbRect toView:nil];

    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbRect.size.height, 0.0);
    ((UIScrollView*)self.view).contentInset = contentInsets;
    ((UIScrollView*)self.view).scrollIndicatorInsets = contentInsets;

    // get valid area
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbRect.size.height;
    aRect.size.height -=  self.navigationController.toolbar.frame.size.height;

    
    CGPoint fieldOrigin = [activeField superview].frame.origin;
    fieldOrigin.y -= ((UIScrollView*)self.view).contentOffset.y;
    fieldOrigin = [self.view convertPoint:fieldOrigin toView:self.view.superview];
    originalOffset = ((UIScrollView*)self.view).contentOffset;
    
    CGRect controlRect = CGRectMake(fieldOrigin.x, fieldOrigin.y, [activeField superview].frame.size.width, [activeField superview].frame.size.height);
    if (!CGRectContainsRect(aRect, controlRect) ) {
        [((UIScrollView*)self.view) scrollRectToVisible:[activeField superview].frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;

    ((UIScrollView*)self.view).contentInset = contentInsets;
    ((UIScrollView*)self.view).scrollIndicatorInsets = contentInsets;
    [((UIScrollView*)self.view) setContentOffset:originalOffset animated:YES];
}


@end
