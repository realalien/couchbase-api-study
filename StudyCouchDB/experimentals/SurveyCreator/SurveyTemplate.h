//
//  SurveyTemplate.h
//  StudyCouchDB
//
//  Created by d d on 12-2-29.
//  Copyright (c) 2012年 d. All rights reserved.
//

#import <CouchCocoa/CouchCocoa.h>

@interface SurveyTemplate : CouchModel

@property bool isAllowOneUserInputOption;
@property (atomic, copy) NSMutableArray *predefinedOptions; 
@property (copy) NSString* questionAsTitle;

@end
