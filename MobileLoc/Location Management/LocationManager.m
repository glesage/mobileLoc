//
//  LocationManager.m
//  mobileloc
//
//  Created by ANDREW KUCHARSKI on 2/7/14.
//  Copyright (c) 2014 GeoffroyLesage. All rights reserved.
//

#import "LocationManager.h"

#define METERS_TO_MILES 0.000621371


@implementation LocationManager


static LocationManager *sharedLocManager;

+ (LocationManager *)sharedManager;
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        sharedLocManager = [[LocationManager alloc] init];
    }
    return sharedLocManager;
}

- (id)init {
    self = [super init];
    if (self) {
        locationManager = [[CLLocationManager alloc] init];
        [locationManager startUpdatingLocation];
    }
    return self;
}

-(CLLocation*)getCurrentLocation {
    CLLocation *currentLocation = [[locationManager location] copy];
    return currentLocation;
}
-(int)distanceBetweenCurrentAnd:(CLLocation*)to {
    return [[NSNumber numberWithDouble:[to distanceFromLocation:locationManager.location]] intValue];
}
-(NSString*)userFriendlyDistanceMiles:(int)distanceMeters
{
    double distance = distanceMeters * METERS_TO_MILES;
    
    if (distance < 1) return [NSString stringWithFormat:@"%.2f miles away", distance];
    if (distance < 5) return [NSString stringWithFormat:@"%.1f miles away", distance];
    return [NSString stringWithFormat:@"%.0f miles away", distance];
}

@end
