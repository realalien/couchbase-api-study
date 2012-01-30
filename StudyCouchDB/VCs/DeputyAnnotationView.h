//
//  DeputyAnnotationView.h
//  StudyCouchDB
//
//  Created by d d on 12-1-30.
//  Copyright (c) 2012年 d. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "DeputyAnnotation.h"

@interface DeputyAnnotationView : MKAnnotationView {
    UIImageView* imageView;
}

@property (nonatomic, retain) UIImageView* imageView;

@end
