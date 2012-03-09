//
//  DeputyProfileViewController.m
//  StudyCouchDB
//
//  Created by d d on 12-1-31.
//  Copyright (c) 2012年 d. All rights reserved.
//

#import "DeputyProfileViewController.h"
#import "UIFactory.h"
#import <CouchCocoa/CouchCocoa.h>


// EXPERIMENTAL
@protocol ProductOfTools <NSObject>
-(NSMutableArray*) resultDocuments;
@end

// -------------

@interface Tool : NSObject<ProductOfTools> {
    NSString *name;
    NSString *uuid;
    NSMutableDictionary *knowledge;
    NSMutableDictionary *processes;
}

@property (nonatomic, assign) NSString *name;
@property (nonatomic, readonly) NSString *uuid;

@end


@implementation Tool

@synthesize name;
@synthesize uuid;

-(NSMutableArray*) resultDocuments{ return nil;}
@end

// -------------

// TODO: save it as a CouchDocument
@interface ListingAttributesTool : Tool {
    NSMutableArray *attributesToLookFor;
}

@property (nonatomic,retain) NSMutableArray *attributesToLookFor;

-(void)addAttributesToLookFor:(NSArray*)attrNames;

@end


@implementation ListingAttributesTool

@synthesize attributesToLookFor;

-(id)initWithName:(NSString*)aName {
    if ( self = [super init]) {
        self.name = aName;
    }
    
    return self;
}

-(void)dealloc{
    [name release];
    [uuid release];
    [super dealloc];
}

// TODO: decide if make it public
-(void)addAttributesToLookFor:(NSArray*)attrNames{
    for (NSString* aName in attrNames) {
        // TODO: tuning
        for (NSString *exist in self.attributesToLookFor) {
            if ([exist isEqualToString:aName]) {
                break;
            }
        }
        // last and not found, add to existings.
        [self.attributesToLookFor addObject:aName];
    }
}

-(NSMutableArray*) resultDocuments{ 
    return nil;
}


-(NSMutableArray*)processDocumentForTableView:(CouchDocument*)doc{
    
    return nil;
}



@end

// -------------

@interface DeputyProfileViewController ()
-(void)loadDeputyProfile:(NSDictionary*)profile ;
@end

@implementation DeputyProfileViewController

@synthesize data;
@synthesize tools;
@synthesize targets;

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
//    UIScrollView* container = [UIFactory makeHalfScreenRightScrollView];
//    container.backgroundColor =[UIColor grayColor];
//    self.view = container;
          
    
    UIScrollView *v = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0,1024,768)];
    self.view = v;
    //self.view.backgroundColor = [UIColor greenColor];
    [v release];
    
    // how to make orientation agnostic? 
    UITableView *tv = [[UITableView alloc]initWithFrame:CGRectMake(40, 0, 320, 768) style:UITableViewStyleGrouped];
    tv.dataSource = self;
    tv.delegate = self;
    [self.view addSubview:tv];
    [tv release];
    
    
    UIButton *b = [UIButton buttonWithType:UIButtonTypeContactAdd];
    b.frame = CGRectMake(350, 40, 40, 18);
    [b addTarget:self action:@selector(testButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b];
    
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
    [data release];
    [tools release];
    [targets release];
    
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


#pragma mark -
#pragma mark UITableView delegate methods


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  44;
}

#pragma mark -
#pragma mark UITableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.tools count];
}


// NOTE: from this method, it is obvious that any internal objects should return some kinds of document or key/value data for table cell content.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ListingAttributesTool *tool = (ListingAttributesTool*)[self.tools objectAtIndex:section];
    
    // TODO: use doc_type, which can also do a second validate if the tool is supposed to process those 'types' of documents.
    // Q: it's quite often that we process the document two times, one in numberOfRowInSection, one in cellForRowAtIndexPath,  then what's best time for processing the data?  Though it's safe not to create another ivar to hold the 
    return [[tool processDocumentForTableView:((CouchDocument*)[self.data objectForKey:@"nominee"])] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    int section = indexPath.section;
    int row = indexPath.row;
    
    NSString *kCellIdentifier = @"kCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell==nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                       reuseIdentifier: kCellIdentifier ] autorelease];
        cell.textLabel.font = [UIFont systemFontOfSize: 14.0];
        cell.accessoryType = UITableViewCellAccessoryNone; // UITableViewCellAccessoryDisclosureIndicator;
        
        UILabel *lkey = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 100, 18)];
        lkey.tag = 201;
        [cell.contentView addSubview:lkey];
        [lkey release];

        UILabel *lval = [[UILabel alloc]initWithFrame:CGRectMake(105, 0, 200, 18)];
        lval.tag = 202;
        [cell.contentView addSubview:lval];
        [lval release];
        
        // IDEA: for specific data, it may have detailIndicator to show more data for specific data, e.g. organzation info of a person.
    }
    
    ListingAttributesTool *tool = (ListingAttributesTool*)[self.tools objectAtIndex:section];
    NSMutableArray *kvPair = [tool processDocumentForTableView:[self.data objectForKey:@"nominee"] ];
    
    UILabel *l = (UILabel*)[cell.contentView viewWithTag:201];
    l.text = [[kvPair objectAtIndex:row] valueForKey:@"attributeName"];
    
    l = (UILabel*)[cell.contentView viewWithTag:202];
    l.text = [[kvPair objectAtIndex:row] valueForKey:@"attributeValue"];
    
    return cell;
    
}


#pragma mark -
#pragma mark callback
-(void)testButtonClicked:(id)sender{
    
    // TEMP
    [self.tools removeAllObjects];
    
    // add a virtual tool/target to the tableview's datasource for display
    
    // Q: what should a tool/target possess? 
    // A: 
    // HINT: for a simple data listing,  __local knowledge__ will be sth. like 'the names of attributes to inspect', 
    //       __actions__ will be 'check those attributes', 'giving statics'(which depends other tool/target), 
    
    ListingAttributesTool *tool = [[ListingAttributesTool alloc]init];
    [self.tools addObject:tool];  
    
    // NOTE: IDEA: * the tools should be materialized as documents * the tools should follow some protocols, like produce some documents or not, 
    // NOTE: if tool doens't comply with the some kind of protocol, then it's not very obvious to bind the tools to a tableview(or any other UI)
    
    
}


@end
