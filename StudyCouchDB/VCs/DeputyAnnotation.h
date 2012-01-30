//
//  DeputyAnnotation.h
//  StudyCouchDB
//
//  Created by d d on 12-1-30.
//  Copyright (c) 2012年 d. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef enum {
    // male
    DeputyAnnotationTypePreviousNomineeMale = 0,     // once nomineed, but not elected.
    DeputyAnnotationTypePreviousElectedMale, // elected before but not the latest, in the history
    DeputyAnnotationTypeLatestNomineeMale,
    DeputyAnnotationTypeLatestElectedMale,
    // female
    DeputyAnnotationTypePreviousNomineeFemale,     // once nomineed, but not elected.
    DeputyAnnotationTypePreviousElectedFemale, // elected before but not the latest, in the history
    DeputyAnnotationTypeLatestNomineeFemale,
    DeputyAnnotationTypeLatestElectedFemale
    
}DeputyAnnotationType;


@interface DeputyAnnotation : NSObject <MKAnnotation> {
    CLLocationCoordinate2D coordinate;
    NSString* title;
    NSString* subtitle;
    DeputyAnnotationType deputyAnnotationType;
}

@property(nonatomic) CLLocationCoordinate2D coordinate;
@property(nonatomic, copy) NSString* title;
@property(nonatomic, copy) NSString* subtitle;
@property(nonatomic) DeputyAnnotationType deputyAnnotationType;

-(id)initWithCoordinate:(CLLocationCoordinate2D)incoord ;

@end
