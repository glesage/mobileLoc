//
//  LocationManager.m
//  mobileloc
//
//  Created by GEOFFROY LESAGE on 2/7/14.
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

/*
 * Instanciates class
 * Instanciates the CLLocationManager object
 * Starts updating location
 */
- (id)init {
    self = [super init];
    if (self) {
        locationManager = [[CLLocationManager alloc] init];
        [locationManager startUpdatingLocation];
    }
    return self;
}

/*
 * Full check for location
 *
 * This is called by any class who wishes to make sure user location is:
 * - Authorized
 * - Enabled
 * - Available
 *
 * Returns TRUE if it is, FALSE if not
 */
-(BOOL)locationEnabled {
    BOOL locationAuthorized = ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized);
    BOOL locationEnabled = [CLLocationManager locationServicesEnabled];
    BOOL locationAvail = (locationManager.location != nil);
    return (locationAuthorized && locationEnabled && locationAvail);
}

// Returns a copy of the current location object
-(CLLocation*)getCurrentLocation
    {
    CLLocation *currentLocation = [[locationManager location] copy];
    return currentLocation;
}

    // Returns the distance between the current location and a given location
-(int)distanceBetweenCurrentAnd:(CLLocation*)to
    {
    return [[NSNumber numberWithDouble:[to distanceFromLocation:locationManager.location]] intValue];
}
    
// Returns a user friendly formated distance text, using miles as unit
-(NSString*)userFriendlyDistanceMiles:(int)distanceMeters
{
    double distance = distanceMeters * METERS_TO_MILES;
    
    if (distance < 1) return [NSString stringWithFormat:@"%.2f miles away", distance];
    if (distance < 5) return [NSString stringWithFormat:@"%.1f miles away", distance];
    return [NSString stringWithFormat:@"%.0f miles away", distance];
}

@end
