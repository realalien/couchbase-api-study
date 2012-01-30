//
//  DeputyAnnotationView.m
//  StudyCouchDB
//
//  Created by d d on 12-1-30.
//  Copyright (c) 2012年 d. All rights reserved.
//

#import "DeputyAnnotationView.h"
#define kWidth 34
#define kHeight 34
#define kBorder 1


@implementation DeputyAnnotationView

@synthesize imageView;

-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    DeputyAnnotation* anno = (DeputyAnnotation*)annotation;
    
    if ([anno deputyAnnotationType] == DeputyAnnotationTypePreviousNomineeMale) {
        self = [super initWithAnnotation:anno reuseIdentifier:reuseIdentifier];
        self.frame = CGRectMake(0, 0, kWidth, kHeight);
        self.backgroundColor = [UIColor clearColor];
        imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"male_previous_nominee.png"]];
        imageView.frame = CGRectMake(kBorder, kBorder, kWidth - 2*kBorder, kHeight - 2*kBorder);
        [self addSubview:imageView];
        
    }else if ([anno deputyAnnotationType] == DeputyAnnotationTypePreviousElectedMale) {
        self = [super initWithAnnotation:anno reuseIdentifier:reuseIdentifier];
        self.frame = CGRectMake(0, 0, kWidth, kHeight);
        self.backgroundColor = [UIColor clearColor];
        imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"male_previous_elected.png"]];
        imageView.frame = CGRectMake(kBorder, kBorder, kWidth - 2*kBorder, kHeight - 2*kBorder);
        [self addSubview:imageView];
    }else if ([anno deputyAnnotationType] == DeputyAnnotationTypeLatestNomineeMale) {
        self = [super initWithAnnotation:anno reuseIdentifier:reuseIdentifier];
        self.frame = CGRectMake(0, 0, kWidth, kHeight);
        self.backgroundColor = [UIColor clearColor];
        imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"male_current_nominee.png"]];
        imageView.frame = CGRectMake(kBorder, kBorder, kWidth - 2*kBorder, kHeight - 2*kBorder);
        [self addSubview:imageView];

    }else if ([anno deputyAnnotationType] == DeputyAnnotationTypeLatestElectedMale) {
        self = [super initWithAnnotation:anno reuseIdentifier:reuseIdentifier];
        self.frame = CGRectMake(0, 0, kWidth, kHeight);
        self.backgroundColor = [UIColor clearColor];
        imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"male_current_elected.png"]];
        imageView.frame = CGRectMake(kBorder, kBorder, kWidth - 2*kBorder, kHeight - 2*kBorder);
        [self addSubview:imageView];
        
    }
    // female
    else if ([anno deputyAnnotationType] == DeputyAnnotationTypePreviousNomineeFemale) {
        self = [super initWithAnnotation:anno reuseIdentifier:reuseIdentifier];
        self.frame = CGRectMake(0, 0, kWidth, kHeight);
        self.backgroundColor = [UIColor clearColor];
        imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"female_previous_nominee.png"]];
        imageView.frame = CGRectMake(kBorder, kBorder, kWidth - 2*kBorder, kHeight - 2*kBorder);
        [self addSubview:imageView];
        
    }else if ([anno deputyAnnotationType] == DeputyAnnotationTypePreviousElectedFemale) {
        self = [super initWithAnnotation:anno reuseIdentifier:reuseIdentifier];
        self.frame = CGRectMake(0, 0, kWidth, kHeight);
        self.backgroundColor = [UIColor clearColor];
        imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"female_previous_elected.png"]];
        imageView.frame = CGRectMake(kBorder, kBorder, kWidth - 2*kBorder, kHeight - 2*kBorder);
        [self addSubview:imageView];
    }else if ([anno deputyAnnotationType] == DeputyAnnotationTypeLatestNomineeFemale) {
        self = [super initWithAnnotation:anno reuseIdentifier:reuseIdentifier];
        self.frame = CGRectMake(0, 0, kWidth, kHeight);
        self.backgroundColor = [UIColor clearColor];
        imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"female_current_nominee.png"]];
        imageView.frame = CGRectMake(kBorder, kBorder, kWidth - 2*kBorder, kHeight - 2*kBorder);
        [self addSubview:imageView];
        
    }else if ([anno deputyAnnotationType] == DeputyAnnotationTypeLatestElectedFemale) {
        self = [super initWithAnnotation:anno reuseIdentifier:reuseIdentifier];
        self.frame = CGRectMake(0, 0, kWidth, kHeight);
        self.backgroundColor = [UIColor clearColor];
        imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"female_current_elected.png"]];
        imageView.frame = CGRectMake(kBorder, kBorder, kWidth - 2*kBorder, kHeight - 2*kBorder);
        [self addSubview:imageView];
    }
    
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    
    return self;
}


@end
