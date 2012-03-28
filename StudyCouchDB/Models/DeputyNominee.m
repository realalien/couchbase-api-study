//
//  Representative.m
//  StudyCouchDB
//
//  Created by d d on 12-3-27.
//  Copyright (c) 2012年 d. All rights reserved.
//

#import "DeputyNominee.h"

@implementation DeputyNominee


@dynamic area_name;
@dynamic area_number;
@dynamic created_at;
@dynamic is_report_gps;
@dynamic lat_lng;   // TODO: how to persist CLLocationCoordinate2D here?
@dynamic name;


+ (DeputyNominee*)addDeputyNomineeWithDatabase:(CouchDatabase*)database 
                                          name:(NSString*)name
                                     area_name:(NSString*)area_name
                                   area_number:(NSString*)area_number
                                 is_report_gps:(BOOL)is_report_gps
                                       lat_lng:(NSString*)lat_lng
                                    created_at:(NSDate*)creationDate{
    NSDictionary* properties = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSString stringWithFormat:@"%@",name],             @"name",
                                [NSString stringWithFormat:@"%@",area_name],        @"area_name",
                                [NSString stringWithFormat:@"%@",area_number],      @"area_number",
                                [NSNumber numberWithBool:is_report_gps],            @"is_report_gps",
                                [NSString stringWithFormat:@"%@",lat_lng],          @"lat_lng",
                                [RESTBody JSONObjectWithDate: creationDate],        @"created_at",
                                @"human", @"doc_type",
                                nil];
    
    CouchDocument* document = [[database untitledDocument] retain];
    RESTOperation* op = [document putProperties: properties];
    
    // blocking style
    if (![op wait]) {
        // TODO: report error
        NSLog(@"Creating DeputyNominee document failed! %@", op.error);
        return nil;
    }
    
//    // non-blocking style, Q:TODO: but we can't make sure to return a valid model object.
//    [op onCompletion: ^{
//        [document release]; // TODO: research on best place for release.
//        if (op.error){
//            // [self showErrorAlert: @"Couldn't save the new item" forOperation: op];
//            //return  nil;
//        }else {
//            // TODO: handle the different responses from the server side. e.g. add more 
//            // [self showAlert:@"保存成功！" tag:kTagAlertSaveDocumentSuccess];
//        }
//        // Re-run the query:
//        //            [self.dataSource.query start];
//    }];
//    [op start];
    
    
    return (DeputyNominee*)[self modelForDocument:document];
}


- (NSDate*) creationDate {
    NSString* dateString = [self getValueOfProperty: @"created_at"];
    return [RESTBody dateWithJSONObject: dateString];
}


+(NSMutableArray *)countByAreaNameAreaNumberFromDatabase:(CouchDatabase*)database
                                       withGroupingLevel:(NSInteger)levelOfGrouping
                                                startKey:(id)aStartKey
                                                  endKey:(id)aEndKey {
    
    CouchDesignDocument* design = [database designDocumentWithName: @"nominees"];
    
    // a simple map/reduce function
    [design defineViewNamed: @"count_nominees_by_area_name" 
                        map: @"function(doc){\
     if (doc.area_name && doc.area_number && doc.name)\
     emit([doc.area_name, doc.area_number], 1 ); \
     } "
                     reduce:@"function(key, values, rereduce) {\
     return sum(values);\
     }"
     ];
    
    CouchQuery* query = [design queryViewNamed: @"count_nominees_by_area_name"];
    query.groupLevel = levelOfGrouping;
    query.startKey = aStartKey;
    query.endKey = aEndKey;
    
    //    [query start];
    NSLog(@"total count: %d", query.rows.count);
    
    NSMutableArray *ret = [[NSMutableArray alloc]init];
    
    // Q: TODO: shall I cache the data or request everytime?
    // A: 
    for (int i=0; i< query.rows.count; i++) {
        CouchQueryRow *row = [query.rows rowAtIndex:i];
        //NSLog(@"row %d  =>  %@ : %@ ",i, [row.key description], [row.value description]  );
        //[ret setValue:[row.value description]forKey:[row.key description]];
        [ret addObject:row]; // NOTE: it looks like the data structure is loose, i.e. not enforce any attributes! What's the best practice here?
    }
    
    return [ret autorelease];
}

+(NSMutableArray *)loadNomineesFromDatabase:(CouchDatabase*)database
                                 byAreaName:(NSString*)area_name 
                              andAreaNumber:(NSString*)area_number{
    CouchDesignDocument* design = [database designDocumentWithName: @"nominees"];
    
    // TODO: is it ok to add the nominees data into the key? Test in tempview!
    [design defineViewNamed: @"list_nominees_by_area_name_area_number_name" 
                        map: @"function(doc){\
     if (doc.area_name && doc.area_number && doc.name){ \
        emit([doc.area_name, doc.area_number, doc.name], doc ); \
     } \
     }"
     ];
    
    CouchQuery* query = [design queryViewNamed: @"list_nominees_by_area_name_area_number_name"];
    // NOTE:
    //  to filter using just key=, all parts of the complex key must be specified or you will get a null result, as key= is looking for an exact match.
    // REF: http://ryankirkman.github.com/2011/03/30/advanced-filtering-with-couchdb-views.html
    //    query.keys = [NSArray arrayWithObjects: area_name, [NSArray array], nil ];
    query.startKey = [NSArray arrayWithObjects:area_name, area_number, nil] ;
    query.endKey = [NSArray arrayWithObjects: area_name, area_number, [NSDictionary dictionary], nil ];
    //    query.groupLevel = 3;
    
    NSLog(@"total count: %d", query.rows.count);
    
    NSMutableArray *ret = [[NSMutableArray alloc]init];
    
    // Q: TODO: shall I cache the data or request everytime?
    // A: 
    for (int i=0; i< query.rows.count; i++) {
        CouchQueryRow *row = [query.rows rowAtIndex:i];
        //NSLog(@"row %d  =>  %@ : %@ ",i, [row.key description], [row.value description]  );
        //[ret setValue:[row.value description]forKey:[row.key description]];
        [ret addObject: [DeputyNominee modelForDocument:row.document ]]; // NOTE: it looks like the data structure is loose, i.e. not enforce any attributes! What's the best practice here?
    }
    
    return ret;
}


+(NSMutableArray *)loadAllNomineesFromDatabase:(CouchDatabase*)database{
    return [DeputyNominee loadNomineesFromDatabase:database byAreaName:nil andAreaNumber:nil ];
}


@end
