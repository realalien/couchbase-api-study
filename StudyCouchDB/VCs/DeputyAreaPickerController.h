//
//  DeputyAreaSelectionViewController.h
//  StudyCouchDB
//
//  Created by realalien on 12-1-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AreaPickerDelegate
- (void)areaNameSelected:(NSString *)areaName;
- (void)areaNumberSelected:(NSString *)areaNumber;
@end


@interface DeputyAreaPickerController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource>{
    // 2D array, 1st dimension is area name, 2nd dimensio is area number. e.g. "Hongkou" ("1"-"19")
    NSMutableDictionary *areas;  
    id<AreaPickerDelegate> delegate;
    
    int currentAreaNameSelectionIndex ; 
    int currentAreaNumberSelectionIndex ; 
    
}

@property (nonatomic, retain) NSMutableDictionary *areas;
@property (nonatomic, assign) id<AreaPickerDelegate> delegate;

@property int currentAreaNameSelectionIndex ; 
@property int currentAreaNumberSelectionIndex ; 

@end
