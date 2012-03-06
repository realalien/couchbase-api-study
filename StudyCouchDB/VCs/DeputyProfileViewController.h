//
//  DeputyProfileViewController.h
//  StudyCouchDB
//
//  Created by d d on 12-1-31.
//  Copyright (c) 2012年 d. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeputyProfileViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
    
    // NOTE: 
    NSMutableDictionary *data;
    NSMutableArray *tools;
    NSMutableArray *targets;
}


@property(nonatomic,retain) NSMutableDictionary *data;
@property(nonatomic,retain) NSMutableArray *tools;
@property(nonatomic,retain) NSMutableArray *targets;

@end
