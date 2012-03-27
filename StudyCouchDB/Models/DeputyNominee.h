//
//  Representative.h
//  StudyCouchDB
//
//  Created by d d on 12-3-27.
//  Copyright (c) 2012年 d. All rights reserved.
//

// NOTE:
// model after the demo project, Callout Demo from http://goo.gl/8OTHu 

// NOTE: 
// according to the CouchCocoa docs, I plan not to include declare instance variables to embrace coming undeclared new properties loaded from the documents.

#import <Foundation/Foundation.h>
#import <CouchCocoa/CouchCocoa.h>

@interface DeputyNominee : CouchModel {  // IDEA: later inheritance should like DeputyNominee < CommunityMember < CouchModel for reusing on general data.
    
}

@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *area_name;
@property(nonatomic, retain) NSString *area_number;
@property(nonatomic, readonly) NSDate *created_at;
@property BOOL is_report_gsp;
@property(nonatomic, retain) NSString *lat_lng;   // TODO: how to persist CLLocationCoordinate2D here?


// TODO:IDEA: like SCM or Wiki modification, each update on document(s) should have a message bundled. 


+ (DeputyNominee*)addDeputyNomineeWithDatabase:(CouchDatabase*)database 
                                          name:(NSString*)name
                                     area_name:(NSString*)area_name
                                   area_number:(NSString*)area_number
                                 is_report_gsp:(BOOL)is_report_gsp
                                        lat_lng:(NSString*)lat_lng
                                    created_at:(NSDate*)creationDate;



@end
