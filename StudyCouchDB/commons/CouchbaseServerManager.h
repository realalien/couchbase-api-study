//
//  CouchbaseServerManager.h
//  StudyCouchDB
//
//  Created by d d on 12-1-29.
//  Copyright (c) 2012年 d. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Couchbase/CouchbaseMobile.h>
#import <CouchCocoa/CouchCocoa.h>

@class CouchEmbeddedServer;

@interface CouchbaseServerManager : NSObject

+(CouchbaseServerManager*) sharedInstance ;
+(CouchEmbeddedServer *)getServer;
+(CouchDatabase *)getDeputyDB ;

@property (nonatomic, retain) CouchEmbeddedServer *server; // TODO: make it private!

@end
