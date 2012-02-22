//
//  SurveyCreationDashboardViewController.m
//  StudyCouchDB
//
//  Created by d d on 12-2-21.
//  Copyright (c) 2012年 d. All rights reserved.
//

#import "SurveyCreationDashboardViewController.h"
#import "Foundation-AddsOn.h"

#define SECONDS_IN_HOUR() (60 * 60)


enum {
    kTagUIInputTextAlert = 100
};


@implementation SurveyCreationDashboardViewController
@synthesize resetBarBtn;
@synthesize editOrDoneBarBtn;
@synthesize questionTitleTextField;
@synthesize answersTableView;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    answerOptions = [[NSMutableArray alloc] initWithObjects:@"iPhone",@"iPod",@"MacBook",@"MacBook Pro",nil];
    
    self.answersTableView.dataSource = self;
    self.answersTableView.delegate = self;
    
    [self.editOrDoneBarBtn setTitle:@"Edit"];
}

- (void)viewDidUnload
{
    [self setResetBarBtn:nil];
    [self setEditOrDoneBarBtn:nil];
    [self setQuestionTitleTextField:nil];
    [self setAnswersTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)dealloc {
    [answerOptions release];
    
    [resetBarBtn release];
    [editOrDoneBarBtn release];
    [questionTitleTextField release];
    [answersTableView release];
    [super dealloc];
}
- (IBAction)resetClicked:(id)sender {
}

- (IBAction)editOrDoneClicked:(id)sender {
    
    if (self.answersTableView.editing) {
        [self.answersTableView setEditing:NO animated:YES];
        [self.answersTableView reloadData];
        [self.editOrDoneBarBtn setTitle:@"Edit"];
    }else {
        [self.answersTableView setEditing:YES animated:YES];
        [self.answersTableView reloadData];
        [self.editOrDoneBarBtn setTitle:@"Done"];
    }
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count =  [answerOptions count]  ;  // +1, one more row for adding new entry
    if (self.answersTableView.editing) {
        count++;
    }
    return count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier ];
    }
    
    // Set up the cell...
    if (self.answersTableView.editing) {
        if ( indexPath.row == [answerOptions count] || [answerOptions count] == 0) {
            cell.textLabel.text = @"添加新的选项";
        }else{
            cell.textLabel.text = [answerOptions objectAtIndex:indexPath.row];
        }
        return cell;
    }else{  // tableview not in editing mode
        cell.textLabel.text = [answerOptions objectAtIndex:indexPath.row];
        return cell;
    }
    return cell;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.answersTableView.editing) {
        if ( indexPath.row == [answerOptions count] || [answerOptions count] == 0) {
            return UITableViewCellEditingStyleInsert;
        }else {
            return UITableViewCellEditingStyleDelete;
        }
    } else {
        return UITableViewCellEditingStyleNone;
    }
    
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//	NextViewController *nextController = [[NextViewController alloc] initWithNibName:@"NextView" bundle:nil];
//	[self.navigationController pushViewController:nextController animated:YES];
//	[nextController changeProductText:[arryData objectAtIndex:indexPath.row]];
    
    NSLog(@"didSelect row  %d ", indexPath.row);
        
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [answerOptions removeObjectAtIndex:indexPath.row];
        [self.answersTableView reloadData];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // TODO: add an alert or embeded editing?
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"提示"
                                                         message:@"请添加选项内容"
                                                        delegate:self 
                                               cancelButtonTitle:@"取消" 
                                               otherButtonTitles:@"确定",nil] autorelease];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        alert.tag = kTagUIInputTextAlert;
        [alert show];
    }
}


#pragma mark -
#pragma mark UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == kTagUIInputTextAlert ) {
        if (buttonIndex == 0) {  // cancel, 
            // do nothing
        }else if (buttonIndex == 1) {
            // add one entry to the list
            UITextField *t = [alertView textFieldAtIndex:0];
            if ( t && [t.text isNotEmpty]) {
                [answerOptions insertObject:t.text atIndex:[answerOptions count]];
                [self.answersTableView reloadData];
            }
        }
    }
}


@end
