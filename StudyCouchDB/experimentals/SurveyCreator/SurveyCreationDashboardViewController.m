//
//  SurveyCreationDashboardViewController.m
//  StudyCouchDB
//
//  Created by d d on 12-2-21.
//  Copyright (c) 2012年 d. All rights reserved.
//

// TODO: unfin, app crashes when try to save the modification of answerOptions array.

#import "SurveyCreationDashboardViewController.h"
#import "Foundation-AddsOn.h"
#import "CouchbaseServerManager.h"
#import "SurveyTemplate.h"

#define SECONDS_IN_HOUR() (60 * 60)


@interface SurveyCreationDashboardViewController() {
@private
    NSIndexPath *currentEditingCellIndexPath;
}

@property (nonatomic,retain) NSIndexPath *currentEditingCellIndexPath;

-(NSMutableArray *)loadAllSurveyTemplates;

@end 

enum {
    kTagUIAddAnswerTextAlert = 100,
    kTagUIEditAnswerTextAlert
};


@implementation SurveyCreationDashboardViewController
@synthesize resetBarBtn;
@synthesize editOrDoneBarBtn;
@synthesize saveBarBtn;
@synthesize questionTextView;
@synthesize answersTableView;
@synthesize surveyListTableView;

@synthesize currentEditingCellIndexPath;

@synthesize surveyList;
@synthesize refreshSurveyListBarBtn;

@synthesize currentEditingRow;

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
    
    answerOptions = [[NSMutableArray alloc] initWithObjects:nil];
    
    self.answersTableView.dataSource = self;
    self.answersTableView.delegate = self;
    self.answersTableView.allowsSelectionDuringEditing = YES;
    
    [self.editOrDoneBarBtn setTitle:@"Edit"];
    
    // list of survey templates
    NSMutableArray *data = [self loadAllSurveyTemplates];
    surveyList = data;
    self.surveyListTableView.dataSource = self;
    self.surveyListTableView.delegate = self;

//    [data release];
    
}

- (void)viewDidUnload
{
    [self setResetBarBtn:nil];
    [self setEditOrDoneBarBtn:nil];
    [self setAnswersTableView:nil];
    [self setQuestionTextView:nil];
    [self setCurrentEditingCellIndexPath:nil];
    
    [self setSaveBarBtn:nil];
    [self setSurveyListTableView:nil];
    [self setRefreshSurveyListBarBtn:nil];
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

    [answersTableView release];
    [questionTextView release];
    [saveBarBtn release];
    [surveyListTableView release];
    [refreshSurveyListBarBtn release];
    
    [surveyList release];
    
    [super dealloc];
}


- (IBAction)resetClicked:(id)sender {
    // TODO: either clean the answerOptions if newly created 
    //       or reload latest revision!
    
    
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

- (IBAction)saveClicked:(id)sender {

    #define kDeputyNominees @"deputy-nominees"
    CouchDatabase *db = [[CouchbaseServerManager getServer] databaseNamed: kDeputyNominees];
    
    if (self.currentEditingRow != nil) {
        // write back to 
        CouchDocument *doc = [db documentWithID: self.currentEditingRow.documentID];
        if (doc) {
            NSLog(@"[DEBUG] Already existing doc, docId: %@", doc.documentID);
            SurveyTemplate *template = [SurveyTemplate modelForDocument: self.currentEditingRow.document];
            template.questionAsTitle = self.questionTextView.text;
            template.predefinedOptions = answerOptions;
            [template save];
        }else{
            NSLog(@"[DEBUG] WARNING, the doc is supposed to exists");
        }
        
    }else {
        // create new doc
        NSLog(@"[DEBUG] Storing new doc to the db");
        CouchDocument* doc = [db untitledDocument];
        NSDictionary* props = [NSDictionary dictionaryWithObjectsAndKeys:
                               questionTextView.text, @"question_as_title",
                               answerOptions, @"predefined_options",
                               @"survey_template", @"doc_type",
                               nil];
        [doc putProperties: props]; // TODO: need to make sure the data is saved!
    }
}

- (IBAction)refreshSurveyListClicked:(id)sender {
    
    NSMutableArray *data = [self loadAllSurveyTemplates];
    surveyList = data;
    [self.surveyListTableView reloadData];
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.surveyListTableView) {
        return [surveyList count];
    } else if (tableView == self.answersTableView){
        int count =  [answerOptions count]  ;  // +1, one more row for adding new entry
        if (self.answersTableView.editing) {
            count++;
        }
        return count;
    }
    return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.surveyListTableView) {
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell =  [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier ] autorelease];
        }
        
        // Set up the cell...
//        NSDictionary *data = ((CouchQueryRow *)[self.surveyList objectAtIndex:indexPath.row]).documentProperties;
//        for (NSString *key in [data allKeys]) {
//            NSLog(@"%@ ==> %@", key, [data valueForKey:key]);
//        }
        cell.textLabel.text = [((CouchQueryRow *)[self.surveyList objectAtIndex:indexPath.row]).documentProperties valueForKey:@"question_as_title"]; 
                               
        return cell;

    } else if (tableView == self.answersTableView){
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell =  [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier ] autorelease];
        }
        
        // Set up the cell...
        if (self.answersTableView.editing) {
            if ( indexPath.row == [answerOptions count] || [answerOptions count] == 0) {
                cell.textLabel.text = @"添加新的选项";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else{
                cell.textLabel.text = [answerOptions objectAtIndex:indexPath.row];
                cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            }
            return cell;
        }else{  // tableview not in editing mode
            cell.textLabel.text = [answerOptions objectAtIndex:indexPath.row];
            return cell;
        }
        return cell;
    }
    return nil;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.answersTableView) {
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
    
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//	NextViewController *nextController = [[NextViewController alloc] initWithNibName:@"NextView" bundle:nil];
//	[self.navigationController pushViewController:nextController animated:YES];
//	[nextController changeProductText:[arryData objectAtIndex:indexPath.row]];
    
    if (tableView == self.surveyListTableView) {
        self.currentEditingRow = [self.surveyList objectAtIndex:indexPath.row];
        
        // create model from the row's value
        SurveyTemplate *template = [SurveyTemplate modelForDocument: self.currentEditingRow.document];
        
        // fill the answersTableView with data, TODO:code smell for hard coded attribute retrieving.
        self.questionTextView.text = [template getValueOfProperty:@"question_as_title"];
        answerOptions = [template getValueOfProperty:@"predefined_options"];
        [self.answersTableView reloadData];
    }
    
    
    if (tableView == self.answersTableView) {
        NSLog(@"didSelect row  %d ", indexPath.row);
        
        NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
        self.currentEditingCellIndexPath = selectIndexPath;
        
        if (tableView.editing  && indexPath.row < [answerOptions count]) {
            // TODO: add an alert or embeded editing?
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:@"请修改选项内容"
                                                            delegate:self 
                                                   cancelButtonTitle:@"取消" 
                                                   otherButtonTitles:@"确定",nil] autorelease];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alert textFieldAtIndex:0].text = [answerOptions objectAtIndex:indexPath.row];
            alert.tag = kTagUIEditAnswerTextAlert;
            [alert show];
        }
    }
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.answersTableView) {
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
            alert.tag = kTagUIAddAnswerTextAlert;
            [alert show];
        }
    }
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.answersTableView) {
        if (indexPath.row == [answerOptions count]) { // Watch out for +ADD row
            return NO;
        } else {
            return YES;
        }
    }

    return NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    if (tableView == self.answersTableView) {
        if (sourceIndexPath.row == destinationIndexPath.row) return;
        if (sourceIndexPath.row >= [answerOptions count]) return;
        if (destinationIndexPath.row > [answerOptions count]) return;
        
        
        
        NSObject *o = [answerOptions objectAtIndex:sourceIndexPath.row];
        
        NSLog(@"sourceIndexPath        %d", sourceIndexPath.row);
        NSLog(@"destinationIndexPath   %d", destinationIndexPath.row);
        
        
        if(destinationIndexPath.row > sourceIndexPath.row) {//moving a row down
            int x = 0;
            if (destinationIndexPath.row == [answerOptions count]) { // watch out for last 'Add a row' element.
                x = destinationIndexPath.row - 1 ;
            }else{
                x = destinationIndexPath.row;
            }
            for(int j = sourceIndexPath.row; j < x; j++){
                [answerOptions replaceObjectAtIndex:j withObject:(NSString*)[answerOptions objectAtIndex:j+1]];
            }
        }else{ //moving a row up
            for(int k = sourceIndexPath.row; k >destinationIndexPath.row; k--)
                [answerOptions replaceObjectAtIndex:k withObject:[answerOptions objectAtIndex:k-1]];
        }
        if (destinationIndexPath.row == [answerOptions count]) {  // watch out for last 'Add a row' element.
            [answerOptions replaceObjectAtIndex:destinationIndexPath.row - 1 withObject:o];
        }else{
            [answerOptions replaceObjectAtIndex:destinationIndexPath.row withObject:o];
        }
        
        [self.answersTableView reloadData];
    }
}



#pragma mark -
#pragma mark UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == kTagUIAddAnswerTextAlert ) {
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
    }else if (alertView.tag == kTagUIEditAnswerTextAlert ) {
        if (buttonIndex == 0) {  // cancel, 
            // do nothing
        }else if (buttonIndex == 1) {
            // add one entry to the list
            UITextField *t = [alertView textFieldAtIndex:0];
            if ( t && [t.text isNotEmpty]) {
                [answerOptions replaceObjectAtIndex:self.currentEditingCellIndexPath.row withObject:t.text];
                //[answerOptions insertObject:t.text atIndex:[answerOptions count]];
                //[self.answersTableView reloadData];
                
                [self.answersTableView reloadData];
                
                // find the cell and refresh
                UITableViewCell *cell = [self.answersTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentEditingCellIndexPath.row inSection:0]];
                //[cell setNeedsLayout];
                [cell setHighlighted:YES animated:YES];
            }
        }
    }
}



-(NSMutableArray *)loadAllSurveyTemplates{
    // read database.
    NSLog(@"loadAllSurveyTemplates");
    
    CouchDatabase *database = [CouchbaseServerManager getDeputyDB]; 
    
    CouchDesignDocument* design = [database designDocumentWithName: @"survey_template"];
    
    // TODO: is it ok to add the nominees data into the key? Test in tempview!
    [design defineViewNamed: @"list_all_survey_template" 
                        map: @"function(doc){"
                                "if (doc.doc_type == 'survey_template' ){"
                                    "emit( null, doc );"
                                "}"
                              "}"
     ];
    
    CouchQuery* query = [design queryViewNamed: @"list_all_survey_template"];
    query.prefetch = YES;
    NSLog(@"total count: %d", query.rows.count);
    
    NSMutableArray *ret = [[NSMutableArray alloc]init];
    
    // Q: TODO: shall I cache the data or request everytime?
    // A: 
    for (int i=0; i< query.rows.count; i++) {
        CouchQueryRow *row = [query.rows rowAtIndex:i];
        //NSLog(@"row %d  =>  %@ : %@ ",i, [row.key description], [row.value description]  );
        //[ret setValue:[row.value description]forKey:[row.key description]];
        [ret addObject:row]; // NOTE: it looks like the data structure is loose, i.e. not enforce any attributes! What's the best practice here?
    }
    
    return ret;
}



@end
