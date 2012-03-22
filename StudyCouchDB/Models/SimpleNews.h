//
//  SimpleNews.h
//  StudyCouchDB
//
//  Created by d d on 12-3-22.
//  Copyright (c) 2012年 d. All rights reserved.
//


// NOTE:  Purpose,
// * to demonstrate a document reference
// * to servce as experimental for other models


// Offshare news links, not a self news mgmt sys!


#import <CouchCocoa/CouchCocoa.h>

@interface SimpleNews : CouchModel{
    NSString* title;
    NSString* newsLink;
    NSString* userId;  // the user who added this infor
    
}

/** Creates a brand-new event and adds a document for it to the database. */

+ (SimpleNews*) addNewsLinkWithDatabase:(CouchDatabase*)database 
                              forDeputy:(NSString*)deputyId
                                  title:(NSString*)aTitle
                               newsLink:(NSString*)aLink
                                 userId:(NSString*)theUserIdentity
                           creationDate:(NSDate*)creationDate;

@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* newsLink;
@property (nonatomic, readonly) NSString* userId;

@property (nonatomic, readonly) NSDate *creationDate;


@end
