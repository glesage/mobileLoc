//
//  MapViewController.h
//  mobileloc
//
//  Created by ANDREW KUCHARSKI on 2/8/14.
//  Copyright (c) 2014 GeoffroyLesage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@class MapViewController;

@protocol MapViewControllerDelegate
- (void)mapViewControllerDidFinish:(MapViewController *)controller;
@end


@interface MapViewController : UIViewController <MapViewControllerDelegate> {
    IBOutlet MKMapView *_mapView;
}

@property (strong, nonatomic) NSArray *places;
@property (weak, nonatomic) id <MapViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end