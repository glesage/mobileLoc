//
//  DataManager.m
//  mobileloc
//
//  Created by GEOFFROY LESAGE on 2/7/14.
//  Copyright (c) 2014 GeoffroyLesage. All rights reserved.
//

#import "DataManager.h"
#import "LocationManager.h"

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
        dataStorage = [[DataStorage alloc] init];
        
        placeFetcher = [[PlaceFetcher alloc] init];
        [placeFetcher setDelegate:self];

        //[placeFetcher fetchPlacesAround:[[LocationManager sharedManager] getCurrentLocation]];
        //Test home location
        [placeFetcher fetchPlacesAround:[[CLLocation alloc] initWithLatitude:41.942 longitude:-87.645]];
    }
    return self;
}

-(NSArray*)getAllPlaces {
    return [dataStorage getAllPlaces];
}


# pragma mark - PlaceFetcherDelegate

-(void)pfGotAllPlaces:(NSArray *)places {
    [dataStorage savePlaces:places];
    [[NSNotificationCenter defaultCenter] postNotificationName:GOT_NEW_PLACES
                                                        object:nil];
}

-(void)pfFailedToGetPlaces:(NSError *)error {
    [[NSNotificationCenter defaultCenter] postNotificationName:UNABLE_TO_FETCH_PLACES
                                                        object:@{ @"error" : error.description }];
}

-(void)pfTimedOut {
    [[NSNotificationCenter defaultCenter] postNotificationName:UNABLE_TO_FETCH_PLACES
                                                        object:@{ @"message" : @"Took too long to fetch places :(" }];
}

@end
