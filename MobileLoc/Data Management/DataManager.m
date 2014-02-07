//
//  DataManager.m
//  mobileloc
//
//  Created by GEOFFROY LESAGE on 2/7/14.
//  Copyright (c) 2014 GeoffroyLesage. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager


static DataManager *sharedDataManager;

+ (DataManager *)sharedManager;
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        sharedDataManager = [[DataManager alloc] init];
    }
    return sharedDataManager;
}

- (id)init {
    self = [super init];
    if (self) {
        placeFetcher = [[PlaceFetcher alloc] init];
        [placeFetcher setDelegate:self];

        [placeFetcher fetchPlacesAround:[[CLLocation alloc] initWithLatitude:41.942 longitude:-87.645]]; // Test home location
    }
    return self;
}


# pragma mark - PlaceFetcherDelegate

-(void)pfGotAllPlaces:(NSDictionary *)places {
    NSLog(@"Got Google places - %@", places);
}

-(void)pfFailedToGetPlaces:(NSError *)error {
    NSLog(@"Failed to get Google places - %@", error.description);
}

-(void)pfTimedOut {
    NSLog(@"Time out bro!");
}

@end
