//
//  DeputyNewsLinksViewController.h
//  StudyCouchDB
//
//  Created by d d on 12-3-22.
//  Copyright (c) 2012年 d. All rights reserved.
//


// TODO:
// * to allow adding a news link  (incl. demo of CouchUITableSource)
// * to create doc ref to Deputy data (demo of ref doc id)
// * to manipulate the info of the link (e.g. source, manual/auto, submitter)

#import <UIKit/UIKit.h>

@interface DeputyNewsLinksViewController : UIViewController<UITextFieldDelegate> {
    // NOTE: 
    NSMutableDictionary *data;
}

@property(nonatomic,retain) NSMutableDictionary *data;
    
@end
