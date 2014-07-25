//
//  MapViewController.h
//  lessonDemoFifth
//
//  Created by sky on 14-7-24.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKMapView+ZoomLevel.h"

@interface MapViewController : UIViewController<MKMapViewDelegate>{
    IBOutlet MKMapView *mapview_;
}

@end
