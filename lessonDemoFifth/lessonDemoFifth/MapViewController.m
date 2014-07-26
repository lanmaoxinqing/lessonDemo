//
//  MapViewController.m
//  lessonDemoFifth
//
//  Created by sky on 14-7-24.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import "MapViewController.h"
#import "FarmAnnotation.h"
#import "LocationService.h"
#import <CoreLocation/CoreLocation.h>

@interface MapViewController ()

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    mapview_.showsUserLocation=YES;
    UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPressMapView:)];
    [mapview_ addGestureRecognizer:longPress];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    [mapview_ setCenterCoordinate:userLocation.coordinate zoomLevel:11 animated:YES];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if([annotation isKindOfClass:[FarmAnnotation class]]){
        MKAnnotationView *anView=[mapView dequeueReusableAnnotationViewWithIdentifier:@"MKAnnotationView"];
        if(!anView){
            anView=[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MKAnnotationView"];
            anView.canShowCallout=YES;
            anView.image=[UIImage imageNamed:@"pin"];
//            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
//            label.backgroundColor=[UIColor greenColor];
//            label.text=@"左侧详情";
//            anView.leftCalloutAccessoryView=label;
        }
        anView.annotation=annotation;
        return anView;
    }
    return nil;
}

#pragma mark -
-(void)didLongPressMapView:(UILongPressGestureRecognizer *)recognizer{
    if(recognizer.state==UIGestureRecognizerStateBegan){
        CGPoint point=[recognizer locationInView:mapview_];
        CLLocationCoordinate2D coordinate=[mapview_ convertPoint:point toCoordinateFromView:mapview_];
        [mapview_ setCenterCoordinate:coordinate animated:YES];
        [mapview_ removeAnnotations:mapview_.annotations];
        FarmAnnotation *farmAn=[[FarmAnnotation alloc] initWithCoordinate:coordinate];
        LocationService *locationService=[[LocationService alloc] init];
        CLLocation *location=[[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        [locationService startGeoCoding:location withCompleteHandle:^(NSArray *address) {
            farmAn.title=[address componentsJoinedByString:@""];
            [mapview_ addAnnotation:farmAn];
        }];
    }
    
}


@end
