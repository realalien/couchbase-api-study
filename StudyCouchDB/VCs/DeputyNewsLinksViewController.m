//
//  DeputyNewsLinksViewController.m
//  StudyCouchDB
//
//  Created by d d on 12-3-22.
//  Copyright (c) 2012年 d. All rights reserved.
//

#import "DeputyNewsLinksViewController.h"

#import "SimpleNews.h"
#import "DeputyNominee.h"
#import "CouchbaseServerManager.h"

#import "Foundation-AddsOn.h"

@implementation DeputyNewsLinksViewController

@synthesize data;
@synthesize dataSource;

@synthesize tableView;

- (void)loadView {
    UIScrollView *v = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0,1024,768)];
    v.backgroundColor  = [UIColor grayColor];
    self.view = v;
    //self.view.backgroundColor = [UIColor greenColor];
    [v release];
    
    // how to make orientation agnostic? 
    UITableView *tv = [[UITableView alloc]initWithFrame:CGRectMake(40, 0, 400, 500) style:UITableViewStylePlain];
    tv.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //tv.dataSource = self;
    //tv.delegate = self;
    
    tv.tag = 100;
    self.tableView = tv;
    
    [self.view addSubview:tv];
    [tv release];
    
    UIButton *b = [UIButton buttonWithType:UIButtonTypeContactAdd];
    b.frame = CGRectMake(0 , 0, 20, 20);
    [b addTarget:self action:@selector(addNewsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        NSMutableDictionary *p = [[NSMutableDictionary alloc] init];
        self.data = p;
        [p release];
        
        CouchUITableSource *d = [[CouchUITableSource alloc]init];
        self.dataSource = d;
        [d release];
        
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

- (void)viewDidLoad
{
    [super viewDidLoad];

     [CouchUITableSource class];     // Prevents class from being dead-stripped by linker
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self.dataSource;
    
    
    // Create a CouchDB 'view' containing list items sorted by date,
    // and a validation function requiring parseable dates:
    CouchDesignDocument* design = [[CouchbaseServerManager getDeputyDB] designDocumentWithName: @"news"];
    design.language = kCouchLanguageJavaScript;
    [design defineViewNamed: @"news_listing"
                        map: @"function(doc) {if (doc.doc_type == 'news') emit(doc.deputyNominee, doc);}"];
    
//    design.validation = @"function(doc) {if (doc.created_at && !(Date.parse(doc.created_at) > 0))"
//    "throw({forbidden:'Invalid date'});}";
    
    // Create a query sorted by descending date, i.e. newest items first:
    CouchLiveQuery* query = [[design queryViewNamed: @"news_listing"] asLiveQuery];
    query.keys = [NSArray arrayWithObjects:((DeputyNominee*)[self.data valueForKey:@"nominee"]).document.documentID , nil];
    query.descending = YES;
    
    self.dataSource.tableView = self.tableView;
    
    [self.dataSource setQuery:query];
    self.dataSource.labelProperty = @"title";
    
    [self.dataSource reloadFromQuery];
    [self.tableView reloadData];
}


-(void) dealloc{
    [data release];
    [dataSource release];
    
    [tableView release];
    
    [super dealloc];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    // Return the number of sections.
//    return 1;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

//- (void)couchTableSource:(CouchUITableSource*)source
//     willUpdateFromQuery:(CouchLiveQuery*)query{
//    [self.tableView reloadData];
//}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    
    CouchQueryRow *row = [self.dataSource rowAtIndex:indexPath.row];
    CouchDocument *doc = [row document];
    
    SimpleNews *news =  [SimpleNews modelForDocument:doc];
    NSLog(@"Clikced news:  %@ ( _id: %@)", news.title, news.document.documentID);
}

#pragma mark -

-(void)processNewsLink:(NSString*)url{
    // TODO: sanity check for url
    // TODO: use link to retrieve a title, abstract and other information.
    
    if ( true ) {
        [CouchbaseServerManager getDeputyDB].tracksChanges = YES;
        SimpleNews  *sn = [[SimpleNews alloc]initWithNewDocumentInDatabase:[CouchbaseServerManager getDeputyDB]];
        sn.title = @"模拟标题，待从url访问后处理"; // We may just need to request header rather than bulk of html in order to save bandwidth.
        sn.url = url;
        sn.deputyNominee = ((DeputyNominee*)[self.data valueForKey:@"nominee"])  ;
        sn.doc_type = @"news"; // TODO: this setter should be private.
        
        RESTOperation* op  = sn.save;
        
        // blocking style
        if (![op wait]) {
            // TODO: report error
            NSLog(@"Creating news document via dn2 ..... failed! %@", op.error);
            [self showAlert:@"保存失败！或数据未更新" tag:110];
        }else {
            NSLog(@"Creating news document via dn2 ..... ok! dn2.id is %@",sn.document.documentID);
            [self showAlert:@"保存成功！" tag:111];
        }
        
        
//        sn.deputyNominee = ((DeputyNominee*)[self.data valueForKey:@"nominee"])  ;
//        
//        if (![[sn save] wait]) {
//            // TODO: report error
//            NSLog(@"Creating news document via dn2 ..... failed! %@", op.error);
//            [self showAlert:@"保存失败！或数据未更新" tag:110];
//        }else {
//            NSLog(@"Creating news document via dn2 ..... ok! dn2.id is %@",sn.document.documentID);
//            [self showAlert:@"保存成功！" tag:111];
//        }
        
        [sn release];
    }
}

#pragma mark -
#pragma mark UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == 202) {
        UIAlertView *av = (UIAlertView*)[self.view viewWithTag:201];
        if (av) {
            [av dismissWithClickedButtonIndex:1 animated:NO];
        }
    }
    return YES;
}

#pragma mark -
#pragma mark UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 101) {
        if (buttonIndex== 0) { // cancel
            // do nothing
        }else if (buttonIndex== 1){
            [self processNewsLink:[alertView textFieldAtIndex:0].text ];
        }
    }else if(alertView.tag == 110){
        
    }else if(alertView.tag == 111){
        
    }
}


#pragma mark -
#pragma mark callback methods

-(void)addNewsButtonClicked:(id)sender {
    
    // Temp solution
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"请输入" message:@"消息的链接(URL地址,例如:'http://www.google.com')" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    av.alertViewStyle = UIAlertViewStylePlainTextInput;
    av.tag = 101;
    [av textFieldAtIndex:0].delegate = self;
    [av textFieldAtIndex:0].tag = 202;
    [av show];
}



@end
