//
//  SurveyCreationDashboardViewController.h
//  StudyCouchDB
//
//  Created by d d on 12-2-21.
//  Copyright (c) 2012年 d. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SurveyCreationDashboardViewController : UIViewController <UITableViewDelegate,UITableViewDataSource, UIAlertViewDelegate> {
    NSMutableArray *answerOptions;
}

@property (retain, nonatomic) IBOutlet UIBarButtonItem *resetBarBtn;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *editOrDoneBarBtn;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *saveBarBtn;

@property (retain, nonatomic) IBOutlet UITextView *questionTextView;
@property (retain, nonatomic) IBOutlet UITableView *answersTableView;

- (IBAction)resetClicked:(id)sender;
- (IBAction)editOrDoneClicked:(id)sender;
- (IBAction)saveClicked:(id)sender;


@end
