//
//  LocationService.h
//  lessonDemoFifth
//
//  Created by sky on 14-7-24.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^LocationHandle)(CLLocation *location);

@interface LocationService : NSObject<CLLocationManagerDelegate>{
    BOOL isLocate_;
    CLLocationManager *manager_;
    CLGeocoder *coder_;
}
@property(nonatomic,strong) LocationHandle handle;

-(void)startLocationWithCompleteHandle:(LocationHandle)handle;
-(void)startGeoCoding:(CLLocation *)location withCompleteHandle:(void (^)(NSArray *address))handle;


@end
