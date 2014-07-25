//
//  LocationService.m
//  lessonDemoFifth
//
//  Created by sky on 14-7-24.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import "LocationService.h"

@implementation LocationService

-(void)startLocationWithCompleteHandle:(void (^)(CLLocation *))handle{
    isLocate_=NO;
    if(!manager_){
        manager_=[CLLocationManager new];
        manager_.delegate=self;
    }
    [manager_ startUpdatingLocation];
    _handle=handle;
}

-(void)startGeoCoding:(CLLocation *)location withCompleteHandle:(void (^)(NSArray *))handle{
    if(!coder_){
        coder_=[CLGeocoder new];
    }
    [coder_ reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if(placemarks && error==nil){
            CLPlacemark *placemark=placemarks[0];
            NSArray *address=@[placemark.country?placemark.country:[NSNull null],placemark.administrativeArea?placemark.administrativeArea:[NSNull null],placemark.locality?placemark.locality:[NSNull null],placemark.subLocality?placemark.subLocality:[NSNull null],placemark.thoroughfare?placemark.thoroughfare:[NSNull null]];
            if(handle)
                handle(address);
        }else{
            if(handle){
                handle(nil);
            }
        }
    }];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    if(!isLocate_){
        [manager_ stopUpdatingLocation];
        isLocate_=YES;
        if(_handle){
            _handle(locations[0]);
        }
    }
}



@end
