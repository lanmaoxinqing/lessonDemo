//
//  FarmAnnotation.h
//  xamp-iPhone
//
//  Created by sky on 14-7-21.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FarmAnnotation : NSObject<MKAnnotation>

@property(nonatomic,assign)CLLocationCoordinate2D coordinate;
@property(nonatomic,copy) NSString *title;

-(id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end
