//
//  Organization.h
//  StudyCouchDB
//
//  Created by d d on 12-4-10.
//  Copyright (c) 2012年 d. All rights reserved.
//

#import <CouchCocoa/CouchCocoa.h>

@interface Organization : CouchModel

@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* url;
@property double latitude;
@property double longitude;
@property (nonatomic, retain) NSString* fullAddress;
@property (nonatomic, retain) NSString* doc_type;


@end
