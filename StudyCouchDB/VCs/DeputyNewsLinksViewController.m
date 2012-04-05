//
//  DeputyNewsLinksViewController.m
//  StudyCouchDB
//
//  Created by d d on 12-3-22.
//  Copyright (c) 2012年 d. All rights reserved.
//

#import "DeputyNewsLinksViewController.h"

#import "SimpleNews.h"
#import "CouchbaseServerManager.h"

#import "Foundation-AddsOn.h"

@implementation DeputyNewsLinksViewController

@synthesize data;


- (void)loadView {
    UIScrollView *v = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0,1024,768)];
    self.view = v;
    //self.view.backgroundColor = [UIColor greenColor];
    [v release];
    
    // how to make orientation agnostic? 
    UITableView *tv = [[UITableView alloc]initWithFrame:CGRectMake(40, 0, 400, 500) style:UITableViewStyleGrouped];
    tv.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //tv.dataSource = self;
    //tv.delegate = self;
    tv.tag = 100;
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
}


-(void)processNewsLink:(NSString*)url{
    // TODO: sanity check for url
    // TODO: use link to retrieve a title, abstract and other information.
    if ( true ) {
        SimpleNews  *sn = [[SimpleNews alloc]initWithNewDocumentInDatabase:[CouchbaseServerManager getDeputyDB]];
        sn.title = @"模拟标题，待从url访问后处理"; // We may just need to request header rather than bulk of html in order to save bandwidth.
        sn.url = url;
        NSLog(@"---> %@", [(DeputyNominee*)[self.data valueForKey:@"nominee"] description]);
        sn.deputyNominee = ((DeputyNominee*)[self.data valueForKey:@"nominee"]).document.documentID ;
        sn.doc_type = @"news"; // TODO: this setter should be private.
        
        RESTOperation* op  = [sn save];
        
        // blocking style
        if (![op wait]) {
            // TODO: report error
            NSLog(@"Creating news document via dn2 ..... failed! %@", op.error);
            [self showAlert:@"保存失败！或数据未更新" tag:110];
        }else {
            NSLog(@"Creating news document via dn2 ..... ok! dn2.id is %@",sn.document.documentID);
            [self showAlert:@"保存成功！" tag:111];
        }
        
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
