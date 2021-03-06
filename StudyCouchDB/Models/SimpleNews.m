//
//  SimpleNews.m
//  StudyCouchDB
//
//  Created by d d on 12-3-22.
//  Copyright (c) 2012年 d. All rights reserved.
//

#import "SimpleNews.h"

@class DeputyNominee;
@implementation SimpleNews


@dynamic deputyNominee;

@dynamic title;
@dynamic url;

@dynamic userId;

@dynamic creationDate;
@dynamic doc_type;

+ (SimpleNews*) addNewsLinkWithDatabase:(CouchDatabase*)database 
                              forDeputy:(NSString*)deputyId
                             title:(NSString*)aTitle
                           newsLink:(NSString*)aLink
                             userId:(NSString*)theUserIdentity
                        creationDate:(NSDate*)creationDate {
    NSDictionary* properties = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSString stringWithFormat:@"%@",aTitle], @"title",
                                [NSString stringWithFormat:@"%@",aLink], @"link",
                                [NSString stringWithFormat:@"%@",theUserIdentity], @"userId",
                                [RESTBody JSONObjectWithDate: creationDate], @"creationDate",
                                nil];
    
    CouchDocument* document = [[database untitledDocument] retain];
    RESTOperation* op = [document putProperties: properties];
    if (![op wait]) {
        // TODO: report error
        NSLog(@"Creating SimpleNews document failed! %@", op.error);
        return nil;
    }
    return (SimpleNews*)[self modelForDocument:document];
}


//-(void)setDeputyNominee:(DeputyNominee *)deputyNominee {
//    [self setValue: [[deputyNominee document] documentID] ofProperty:@"deputyNominee"];
//}
//
//-(DeputyNominee*)deputyNominee {
//    NSString *docID = [self getValueOfProperty:@"deputyNominee"];
//    DeputyNominee *dn = [DeputyNominee ];
//}


- (void)dealloc {
//    [title release];
//    [newsLink release];
//    [userId release];
//    [creationDate release];
    [super dealloc];
}


- (NSDate*) creationDate {
    NSString* dateString = [self getValueOfProperty: @"creationDate"];
    return [RESTBody dateWithJSONObject: dateString];
}


@end
