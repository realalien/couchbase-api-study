//
//  AddNewDeputyViewController.h
//  StudyCouchDB
//
//  Created by realalien on 12-1-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeputyAreaPickerController.h"
#import "CouchbaseServerManager.h"

@interface AddNewDeputyViewController : UIViewController <AreaPickerDelegate, UIPopoverControllerDelegate, UIAlertViewDelegate> {
    DeputyAreaPickerController* areaPicker ;
    UIPopoverController *areaPickerPopup;
    
    // NOTE: the problem here is that the Nominee's data object is not supposed to be static, attributes will be added like key/value pair.
    // Q: can we create a a dict here, but can access using .dot notation? Only way I know about is the @dynamic attribute, 
    
    // IDEA: not using object, just plain dictionary .
    NSMutableDictionary* tempData;
}

@property (nonatomic, retain) DeputyAreaPickerController* areaPicker ;
@property (nonatomic, retain) UIPopoverController *areaPickerPopup;
@property (nonatomic, retain) NSMutableDictionary* tempData;

@property (nonatomic, retain) CouchDatabase *database;


@end
