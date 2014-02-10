//
//  LocationManager.h
//  mobileloc
//
//  Created by GEOFFROY LESAGE on 2/7/14.
//  Copyright (c) 2014 GeoffroyLesage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject {
    CLLocationManager *locationManager;
}

+ (LocationManager *)sharedManager;

-(CLLocation*)getCurrentLocation;
-(BOOL)locationEnabled;

-(int)distanceBetweenCurrentAnd:(CLLocation*)to;
-(NSString*)userFriendlyDistanceMiles:(int)distanceMeters;

@end
