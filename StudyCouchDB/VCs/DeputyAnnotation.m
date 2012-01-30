//
//  DeputyAnnotation.m
//  StudyCouchDB
//
//  Created by d d on 12-1-30.
//  Copyright (c) 2012年 d. All rights reserved.
//

#import "DeputyAnnotation.h"

@implementation DeputyAnnotation

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;
@synthesize deputyAnnotationType;


-(id)init{
    return self;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D)incoord {
    coordinate = incoord;
    return self;
}

@end
