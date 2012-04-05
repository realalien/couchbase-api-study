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

@class DeputyNominee;

@interface SimpleNews : CouchModel{
//    NSString* title;
//    NSString* newsLink;
//    NSString* userId;  // the user who added this infor
    
}

/** Creates a brand-new event and adds a document for it to the database. */

+ (SimpleNews*) addNewsLinkWithDatabase:(CouchDatabase*)database 
                              forDeputy:(NSString*)deputyId
                                  title:(NSString*)aTitle
                               newsLink:(NSString*)aLink
                                 userId:(NSString*)theUserIdentity
                           creationDate:(NSDate*)creationDate;

@property (nonatomic, retain) DeputyNominee* deputyNominee;

@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* url;

@property (nonatomic, retain) NSString* userId;  // who submit

@property (nonatomic, readonly) NSDate *creationDate;

@property (nonatomic, retain) NSString* doc_type;

@end
