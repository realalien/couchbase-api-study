//
//  DeputyNewsLinksViewController.h
//  StudyCouchDB
//
//  Created by d d on 12-3-22.
//  Copyright (c) 2012年 d. All rights reserved.
//


// TODO:
// * DONE: to allow adding a news link  (incl. demo of CouchUITableSource) HINT: just remember to set the tableview property of  CouchUITableSource instance to hook up the change
// * DONE: to create doc ref to Deputy data (demo of ref doc id) HINT: use cocoaframework built from latest source
// * TODO: to manipulate the info of the news link (e.g. source, manual/auto, submitter for admin or for autobots.)
//          e.g. a source url provides the domain name from which we can crawl more data(rather than just using Google Alert.)
//          e.g. admin can get a quick view of what's potential missing from a specific news, e.g. link becomes invalid, server side analysis of news agent credential.

#import <UIKit/UIKit.h>
#import <CouchCocoa/CouchUITableSource.h>

@interface DeputyNewsLinksViewController : UIViewController<UITextFieldDelegate, CouchUITableDelegate> {
    // NOTE: 
    NSMutableDictionary *data;
    UITableView *tableView;
    CouchUITableSource* dataSource;
}


@property(nonatomic, retain) UITableView *tableView;
@property(nonatomic, retain) CouchUITableSource* dataSource;

@property(nonatomic,retain) NSMutableDictionary *data;
    
@end
