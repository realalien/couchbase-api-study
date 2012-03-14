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


@interface OrganizationsPlaygroundViewController()
-(void)selectOrganizationUIView:(UIView*)v;
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
    
    // Tap for selection. NOTE: double tapping is not very natural for beginners, try to avoid use that interaction.
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    // Pan for moving UIView
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    panRecognizer.minimumNumberOfTouches = 1;    
    [self.view addGestureRecognizer:panRecognizer];
    
    ((UIScrollView*)self.view).contentSize = CGSizeMake(2048, 2048);
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
            // TODO: also assign tag for persistence and create back from save data.
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
    // NOT WORKING: [(UIScrollView*)self.view scrollRectToVisible:[textField frame] animated:YES];
    UIScrollView* v = (UIScrollView*) self.view ;
    CGRect rc = [textField bounds];
    rc = [textField convertRect:rc toView:v  ];
//    rc.origin.x = 0 ;
//    rc.origin.y -= 160 ;
//    
//    rc.size.height = 400;
    
    
    // adjust the y to allow display the whole UIView, no change of x.
    // TODO: one ivar to keep the offset
    if (rc.origin.y + rc.size.height > (768 - 384) ) { // under keyboard
//        rc.origin.y -= (rc.origin.y + rc.size.height - (768 - 352) );
        float offSetY = (rc.origin.y + rc.size.height - (768 - 384) ); // 352
        [(UIScrollView*)self.view setContentOffset:CGPointMake(0, offSetY) animated:YES];
    }
    
//    [(UIScrollView*)self.view scrollRectToVisible:rc animated:YES];
    
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
    if ( v && v!= self.view) { // excluding the container
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


@end
