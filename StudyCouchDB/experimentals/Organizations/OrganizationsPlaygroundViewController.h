//
//  OrganizationsPlaygroundViewController.h
//  StudyCouchDB
//
//  Created by d d on 12-3-13.
//  Copyright (c) 2012年 d. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrganizationsPlaygroundViewController : UIViewController <UITextFieldDelegate> {
    CGPoint originalOffset;
    UIView *activeField;
}

@property (nonatomic,retain) UIView* currentSelectOrganizationView;

@end
