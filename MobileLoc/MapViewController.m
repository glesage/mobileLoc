//
//  MapViewController.m
//  mobileloc
//
//  Created by ANDREW KUCHARSKI on 2/8/14.
//  Copyright (c) 2014 GeoffroyLesage. All rights reserved.
//

#import "MapViewController.h"
#import "LocationManager.h"
#import "MyLocation.h"


#define MAP_SPAN    500 // The default span of the map view
#define max(x,y)    (x > y ? x : y)
#define min(x,y)    (x < y ? x : y)


@interface MapViewController ()

@end

@implementation MapViewController

@synthesize places;


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setMapToUserLocation];
    [self plotPlaces];
}


#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate mapViewControllerDidFinish:self];
}


#pragma mark - Map View Delegate

-(void)setMapToUserLocation
{
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance([[LocationManager sharedManager] getCurrentLocation].coordinate,
                                                                       MAP_SPAN, MAP_SPAN);

    [_mapView setRegion:[_mapView regionThatFits:viewRegion] animated:YES];
    [UIView commitAnimations];
}

-(void)clearMap {
    [_mapView removeAnnotations:_mapView.annotations];
}
-(void)plotPlaces {
    for (NSDictionary *place in places) {
        
        NSString *placeName = [place objectForKey:@"name"];
        
        CLLocationCoordinate2D coordinates;
        coordinates.latitude = [place[@"latitude"] doubleValue];
        coordinates.longitude = [place[@"longitude"] doubleValue];
        MyLocation *annotation = [[MyLocation alloc] initWithName:placeName
                                                       coordinate:coordinates];
        [_mapView addAnnotation:annotation];
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"MyLocation";
    if ([annotation isKindOfClass:[MyLocation class]]) {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.rightCalloutAccessoryView = nil;
        
        return annotationView;
    }
    return nil;
}
-(void)mapViewControllerDidFinish:(MapViewController *)controller {
    NSLog(@"Finished");
}



@end
