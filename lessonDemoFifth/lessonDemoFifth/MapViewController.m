//
//  MapViewController.m
//  lessonDemoFifth
//
//  Created by sky on 14-7-24.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import "MapViewController.h"
#import "FarmAnnotation.h"

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
            anView.image=[UIImage imageNamed:@"pin"];
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
        [mapview_ addAnnotation:farmAn];

    }
    
}


@end
