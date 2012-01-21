//
//  AddNewDeputyViewController.h
//  StudyCouchDB
//
//  Created by realalien on 12-1-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeputyAreaPickerController.h"

@interface AddNewDeputyViewController : UIViewController <AreaPickerDelegate> {
    DeputyAreaPickerController* areaPicker ;
    UIPopoverController *areaPickerPopup;
}

@property (nonatomic, retain) DeputyAreaPickerController* areaPicker ;
@property (nonatomic, retain) UIPopoverController *areaPickerPopup;

@end
