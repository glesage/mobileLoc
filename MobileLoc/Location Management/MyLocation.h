//
//  MyLocation.h
//  mobileloc
//
//  Created by ANDREW KUCHARSKI on 2/7/14.
//  Copyright (c) 2014 GeoffroyLesage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyLocation : NSObject <MKAnnotation> {
    NSString *_name;
    CLLocationCoordinate2D _coordinate;
}

@property (copy) NSString *name;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;


- (id)initWithName:(NSString*)name coordinate:(CLLocationCoordinate2D)coordinate;

@end