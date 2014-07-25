//
//  FarmAnnotation.m
//  xamp-iPhone
//
//  Created by sky on 14-7-21.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import "FarmAnnotation.h"

@implementation FarmAnnotation

-(id)initWithCoordinate:(CLLocationCoordinate2D)coordinate{
    self=[super init];
    if(self){
        self.coordinate=coordinate;
    }
    return self;
}

@end
