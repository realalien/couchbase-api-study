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
    // Deprecatd: it's unsafe to use dict for row indexing, 
    // 2D array, 1st dimension is area name, 2nd dimensio is area number. e.g. "Hongkou" ("1"-"19")
//    NSMutableDictionary *areas;  
    
    
    // NOTE: the area name and area number are kept seperate, here they are mainly used for UI usage.
    NSMutableArray *areaNames; // data are the names of Shanghai area, 'HongKou', 'HuangPu', etc.
    
    id<AreaPickerDelegate> delegate;
    
    NSString* currentAreaNameSelection ; 
    NSString* currentAreaNumberSelection ; 
    
}

//@property (nonatomic, retain) NSMutableDictionary *areas;

@property (nonatomic, retain) NSMutableArray *areaNames;

@property (nonatomic, assign) id<AreaPickerDelegate> delegate;

@property (nonatomic, retain) NSString* currentAreaNameSelection ; 
@property (nonatomic, retain) NSString* currentAreaNumberSelection ; 

@end
