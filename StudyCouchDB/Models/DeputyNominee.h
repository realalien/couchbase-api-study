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
@property(nonatomic, readonly) NSDate *created_at;  // TODO: this property is not supposed to be set at the client side but the server side, how to set the property at the server side?
@property bool is_report_gps;
@property(nonatomic, retain) NSString *lat_lng;   // TODO: how to persist CLLocationCoordinate2D here?


@property(nonatomic, readonly) NSString *doc_type; // Q: does that mean either we set the property either at the server side or in the class self? Then how to? A: 

// TODO:IDEA: like SCM or Wiki modification, each update on document(s) should have a message bundled. 


+ (DeputyNominee*)addDeputyNomineeWithDatabase:(CouchDatabase*)database 
                                          name:(NSString*)name
                                     area_name:(NSString*)area_name
                                   area_number:(NSString*)area_number
                                 is_report_gps:(BOOL)is_report_gps
                                        lat_lng:(NSString*)lat_lng
                                    created_at:(NSDate*)creationDate;


+(NSMutableArray *)countAreaNumberGroupByAreaNameFromDatabase:(CouchDatabase*)database;
//                                                  forAreaName:(NSString*)areaName;
    
    
+(NSMutableArray *)countNomineesByAreaNameAreaNumberFromDatabase:(CouchDatabase*)database
                                       withGroupingLevel:(NSInteger)levelOfGrouping
                                                startKey:(id)aStartKey
                                                  endKey:(id)aEndKey;

+(NSMutableArray *)loadNomineesFromDatabase:(CouchDatabase*)database
                                 byAreaName:(NSString*)area_name 
                                 andAreaNumber:(NSString*)area_number;

+(NSMutableArray *)loadAllNomineesFromDatabase:(CouchDatabase*)database;


@end
