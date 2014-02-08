//
//  LocationManager.m
//  mobileloc
//
//  Created by ANDREW KUCHARSKI on 2/7/14.
//  Copyright (c) 2014 GeoffroyLesage. All rights reserved.
//

#import "LocationManager.h"

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

@end
