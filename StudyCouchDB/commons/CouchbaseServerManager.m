//
//  CouchbaseServerManager.m
//  StudyCouchDB
//
//  Created by d d on 12-1-29.
//  Copyright (c) 2012年 d. All rights reserved.
//

// TODO: to handle the db connection problem gracefully!

#import "CouchbaseServerManager.h"
#import "Foundation-AddsOn.h"


#define kDeputyNominees @"deputy-nominees"

#define USE_COUCHBASE 1

// The name of the database the app will use.
#define kDatabaseName @"school-monitoring"

// The default remote database URL to sync with, if the user hasn't set a different one as a pref.
//#define kDefaultSyncDbURL @"http://couchbase.iriscouch.com/grocery-sync"

// Set this to 1 to install a pre-built database from a ".couch" resource file on first run.
#define INSTALL_CANNED_DATABASE 0

// Define this to use a server at a specific URL, instead of the embedded Couchbase Mobile.
// This can be useful for debugging, since you can use the admin console (futon) to inspect
// or modify the database contents.
//#define USE_REMOTE_SERVER @"http://localhost:5984/"
#define USE_REMOTE_SERVER @"http://192.168.3.128:5984/"



@implementation CouchbaseServerManager


@synthesize server;

// ----------   singleton implementation -----------
static CouchbaseServerManager *sharedInstance = nil;

- (id) init {
	self = [super init]; if (self != nil){
		/* Do NOT allocate/initialize other objects here that might use 
		 the BookShelfManager's sharedInstance as that will create an infinite loop */
	} 
	return(self);
}

- (void) initializeSharedInstance{
    /* Allocate/initialize your values here as we are sure this method gets called 
	 only AFTER the instance of CouchbaseServerManager has been created through the [sharedInstance] class method */
    
#ifdef USE_COUCHBASE    
    // ---------------------  Couchbase server setup  ---------------------
#ifdef kDefaultSyncDbURL
    // Register the default value of the pref for the remote database URL to sync with:
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *appdefaults = [NSDictionary dictionaryWithObject:kDefaultSyncDbURL
                                                            forKey:@"syncpoint"];
    [defaults registerDefaults:appdefaults];
    [defaults synchronize];
#endif
    
    // Couchbase database setup
    //    CouchbaseMobile* cb = [[CouchbaseMobile alloc] init];
    //    cb.delegate = self;
    //    NSAssert([cb start], @"Couchbase didn't start: Error = %@", cb.error);
    
    [CouchbaseMobile class];  // prevents dead-stripping  // Q: what's that?
    
    CouchEmbeddedServer* theServer;
#ifdef USE_REMOTE_SERVER
    theServer = [[CouchEmbeddedServer alloc] initWithURL: [NSURL URLWithString: USE_REMOTE_SERVER]];
#else
    theServer = [[CouchEmbeddedServer alloc] init];
#endif
    self.server = theServer;

    [theServer release];
    
    [server start: ^{  // ... this block runs later on when the server has started up:
        if (server.error) {
            [self showAlert: @"Couldn't start Couchbase." error: server.error fatal: YES];
            return;
        }else{
            NSLog(@"Server started!");
        }
        
//        self.database = [server databaseNamed: kDatabaseName];
        
#if !INSTALL_CANNED_DATABASE && !defined(USE_REMOTE_SERVER)
        // Create the database on the first run of the app.
        NSError* error;
        if (![self.database ensureCreated: &error]) {
            [self showAlert: @"Couldn't create local database." error: error fatal: YES];
            return;
        }
#endif
        
//        database.tracksChanges = YES;
        
    }];
    
#endif  
    
}

+(CouchEmbeddedServer *)getServer {
    return [CouchbaseServerManager sharedInstance].server;
}

+ (CouchbaseServerManager *)sharedInstance{
	@synchronized(self){ 
		if (sharedInstance == nil){
			sharedInstance = [[self alloc] init]; 
			/* Now initialize the shared instance */ 
			[sharedInstance initializeSharedInstance];
		} 
		return(sharedInstance);
	} 
}	

+(CouchDatabase *)getDeputyDB {
    return [[CouchbaseServerManager getServer] databaseNamed:kDeputyNominees ];
}

- (NSUInteger) retainCount{
	return(NSUIntegerMax);
}

//- (void)release{ 
//	/* Don't call super here. The shared instance should
//     not be deallocated */
//}	

- (id) autorelease{
	return(self);
}

- (id) retain{
	return(self);
}


- (void) dealloc {
	
	[super dealloc];
}




@end
