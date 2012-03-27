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
@dynamic is_report_gsp;
@dynamic lat_lng;   // TODO: how to persist CLLocationCoordinate2D here?
@dynamic name;


+ (DeputyNominee*)addDeputyNomineeWithDatabase:(CouchDatabase*)database 
                                          name:(NSString*)name
                                     area_name:(NSString*)area_name
                                   area_number:(NSString*)area_number
                                 is_report_gsp:(BOOL)is_report_gsp
                                       lat_lng:(NSString*)lat_lng
                                    created_at:(NSDate*)creationDate{
    NSDictionary* properties = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSString stringWithFormat:@"%@",name],             @"name",
                                [NSString stringWithFormat:@"%@",area_name],        @"area_name",
                                [NSString stringWithFormat:@"%@",area_number],      @"area_number",
                                [NSNumber numberWithBool:is_report_gsp],            @"is_report_gsp",
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


@end
