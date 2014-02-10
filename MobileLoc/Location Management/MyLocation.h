//
//  MyLocation.h
//  mobileloc
//
//  Created by GEOFFROY LESAGE on 2/7/14.
//  Copyright (c) 2014 GeoffroyLesage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

/*
 * This class is used as custom MKAnnotation for Maps
 *
 * It differs from the default in that it contains extra data for the annotation view.
 */
@interface MyLocation : NSObject <MKAnnotation> {
    NSString *_name;
    CLLocationCoordinate2D _coordinate;
}

@property (copy) NSString *name;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;


- (id)initWithName:(NSString*)name coordinate:(CLLocationCoordinate2D)coordinate;

@end