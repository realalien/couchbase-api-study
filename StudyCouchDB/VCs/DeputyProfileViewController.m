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
#import "Foundation-AddsOn.h"


// EXPERIMENTAL
@protocol WillGenerateDocuments <NSObject>
-(NSMutableArray*) resultDocuments;
@end

// -------------

@interface Tool : NSObject<WillGenerateDocuments> {
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
        NSMutableArray * a= [[NSMutableArray alloc]init];
        self.attributesToLookFor = a;
        [a release];
    }
    
    return self;
}

-(void)dealloc{
    [name release];
    [uuid release];
    [attributesToLookFor release];
    [super dealloc];
}

// TODO: decide if make it public
-(void)addAttributesToLookFor:(NSArray*)attrNames{
    for (NSString* aName in attrNames) {
        // TODO: tuning
        for (NSString *exists in self.attributesToLookFor) {
            if ([exists isEqualToString:aName]) {
                break;
            }else{
                continue;
            }
        }
        
        // last and not found, add to existings.
        [self.attributesToLookFor addObject:aName];
    }
}

-(NSMutableArray*) resultDocuments{ 
    return nil;
}


// NOTE: because it is needed to return an ordered array(for human reading) rather than arbitrary attributes listing.
// TODO: best practice for return collections
-(NSMutableArray*)processDocumentForTableView:(CouchDocument*)doc{
    
    NSMutableArray *ret = [[NSMutableArray alloc]init];
    
    // add attributes of the interested
    for (NSString* attrToLook in self.attributesToLookFor) {
        if ( [[doc userProperties] valueForKey:attrToLook] != [NSNull null] 
            &&  [[doc userProperties] valueForKey:attrToLook] != nil ) { // Q: why nil works?!
            // still keep it as a dict,            
            [ret addObject: [NSDictionary dictionaryWithObject:[[doc userProperties] valueForKey:attrToLook]
                                                        forKey: attrToLook]];
        }else { 
            // couchdoc has no such that attribute
            [ret addObject:[NSDictionary dictionaryWithObject:[NSNull null]
                                                       forKey: attrToLook] ];
        }
    }
 
    return [ret autorelease];
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
        NSMutableArray * a= [[NSMutableArray alloc]init];
        self.tools = a;
        [a release];
        
        NSMutableDictionary *p = [[NSMutableDictionary alloc] init];
        self.data = p;
        [p release];
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
    tv.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tv.dataSource = self;
    tv.delegate = self;
    tv.tag = 100;
    [self.view addSubview:tv];
    [tv release];
    
    UIButton *b = [UIButton buttonWithType:UIButtonTypeContactAdd];
    b.frame = CGRectMake(350, 40, 40, 40);
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *name = [((ListingAttributesTool*)[self.tools objectAtIndex:section]) name];
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 18)];
    l.backgroundColor = [UIColor clearColor];
    l.font = [UIFont boldSystemFontOfSize:15];
    l.textAlignment = UITextAlignmentCenter;
    l.text = name;
    return [l autorelease];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didSelectRow at  sect: %d  row: %d", indexPath.section, indexPath.row);
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


// NOTE:TODO:Q for different tools, the cell representation will be different, what's the best way to customize? 
// A:
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
        
        UILabel *lkey = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 100, 18)];
        lkey.tag = 201;
        [cell.contentView addSubview:lkey];
        [lkey release];

        UILabel *lval = [[UILabel alloc]initWithFrame:CGRectMake(105, 5, 100, 18)];
        lval.tag = 202;
        [cell.contentView addSubview:lval];
        [lval release];
        
        UIButton *edit = [UIButton buttonWithType:UIButtonTypeCustom];
        edit.frame = CGRectMake(145, 5, 100, 22);
        edit.hidden = YES;
        [edit setTitle:@"添加资料" forState:UIControlStateNormal];
        [edit setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [edit addTarget:self action:@selector(attrEditClicked:) forControlEvents:UIControlEventTouchUpInside];
        edit.tag = 203;
        [cell.contentView addSubview:edit];

        // IDEA: for specific data, it may have detailIndicator to show more data for specific data, e.g. organzation info of a person.
    }
    
    // TODO: tuning the process below, it looks like for every cell, we will process again!
    ListingAttributesTool *tool = (ListingAttributesTool*)[self.tools objectAtIndex:section];
    
    NSMutableArray *kvPairs = [tool processDocumentForTableView:[self.data objectForKey:@"nominee"] ];
    [kvPairs retain];
    
    NSDictionary *d = [kvPairs objectAtIndex:row];
    // this dict contains only one pair of key/value
    NSArray *keys = [d allKeys]; // 
    
    UILabel *l = (UILabel*)[cell.contentView viewWithTag:201];
    l.text = [keys objectAtIndex:0];
    
    UILabel *lval = (UILabel*)[cell.contentView viewWithTag:202];
    UIButton *b = (UIButton*)[cell.contentView viewWithTag:203];
    
    NSLog(@"d's keys: %@", [[d allKeys] componentsJoinedByString:@","] );
    NSLog(@"d's values: %@", [[d allValues] componentsJoinedByString:@","] );
    
    NSLog(@"[keys objectAtIndex:0]  is %@", [keys objectAtIndex:0]);
    NSLog(@"d valueForKey:[keys objectAtIndex:0]]   is  %@", [d valueForKey:[keys objectAtIndex:0]]);
    
    if ([d valueForKey:[keys objectAtIndex:0]] != [NSNull null]) {
        lval.text = [d valueForKey:[keys objectAtIndex:0]];
        [cell.contentView bringSubviewToFront:lval];

        // make a detail indicator
        if ([lval.text isALink]) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            lval.hidden = NO;
            b.hidden = YES;
        }
        
    }else{
        lval.text = @"N/A";
        lval.hidden = YES;
        b.hidden = NO;
        [cell.contentView bringSubviewToFront:b];
    }
    
    [kvPairs release];
    
    return cell;
    
}


#pragma mark -
#pragma mark callback

-(void)testButtonClicked:(id)sender{
    
    // TEMP: entrance of using
    [self.tools removeAllObjects];
    
    // add a virtual tool/target to the tableview's datasource for display
    
    // Q: what should a tool/target possess? 
    // A: 
    // HINT: for a simple data listing,  __local knowledge__ will be sth. like 'the names of attributes to inspect', 
    //       __actions__ will be 'check those attributes', 'giving statics'(which depends other tool/target), 
    
    
//    //       First iteration, the concept of diggable inforamtion based on checklist style listing
//     //  ------------------------------------------------------------------------------------------
//     //
//    // NOTE: some attributes are just for viewing.
//    ListingAttributesTool *tool = [[ListingAttributesTool alloc]initWithName:@"Personal Info"];
//    [tool addAttributesToLookFor:[NSArray arrayWithObjects:@"area_name",@"area_number", @"nominee_name", nil]];
//    [self.tools addObject:tool];  
//    [tool release];  // TODO:
//    
//    // NOTE: some attributes are the interfaces to outside data, like personal page of the SNS, the data crawling tools key words.
//    ListingAttributesTool *tool2 = [[ListingAttributesTool alloc]initWithName:@"Sociality"];
//    [tool2 addAttributesToLookFor:[NSArray arrayWithObjects:@"weibo_account",@"twitter_account",@"blog",nil]];
//    [self.tools addObject:tool2];  
//    [tool2 release];
//    
//    UITableView *tv = (UITableView*)[self.view viewWithTag:100];
//    if (tv) {
//        [tv reloadData];
//    }
//    // NOTE: IDEA: * the tools should be materialized as documents * the tools should follow some protocols, like produce some documents or not, 
//    // NOTE: if tool doens't comply with the some kind of protocol, then it's not very obvious to bind the tools to a tableview(or any other UI)
//    
//    //  ------------------------------------------------------------------------------------------
    
    
    
    
    
    
    
}

// to edit the data of the deputy.
-(void)attrEditClicked:(id)sender{
    
}


@end
