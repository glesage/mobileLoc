//
//  PlaceFetcher.m
//  mobileloc
//
//  Created by ANDREW KUCHARSKI on 2/7/14.
//  Copyright (c) 2014 GeoffroyLesage. All rights reserved.
//

#import "PlaceFetcher.h"

#define FETCHING_TIME_OUT 5 //(seconds)


@implementation PlaceFetcher


- (id)init {
    self = [super init];
    if (self) {
        allPlaces = [[NSMutableDictionary alloc] init];
    }
    return self;
}

/*
 * Instanciates all third party API fetchers
 * and calls to each to get places.
 *
 * Also starts the timeout timer to make sure 
 * the user does not wait too long...
 */
-(void)fetchPlacesAround:(CLLocation*)location {
    googlePlaces = [[GooglePlaces alloc] initWithLocation:location];
    [googlePlaces setDelegate:self];
    gotGP = FALSE;
    
    timeOutTimer = [NSTimer scheduledTimerWithTimeInterval:FETCHING_TIME_OUT
                                                    target:self
                                                  selector:@selector(reachedTimeout)
                                                  userInfo:nil
                                                   repeats:NO];
}

/*
 * Cancel all fetching jobs
 * and notify the delegate of the timeout
 */
-(void)reachedTimeout {
    [googlePlaces cancelFetching];
    
    [self.delegate pfTimedOut];
}

/*
 * Gets called everytime a third party returns places
 *
 * Checks if all third parties have returned places
 * If so, it returns all the places to the delegate
 */
-(void)gotMorePlaces:(NSDictionary*)places {
    @synchronized(allPlaces) {
        [allPlaces addEntriesFromDictionary:places];
    }
    
    if (gotGP) //Once all third parties have responded, proceed
    {
        [timeOutTimer invalidate];
        timeOutTimer = nil;
        
        [self.delegate pfGotAllPlaces:allPlaces];
    }
}


# pragma mark - GooglePlacesDelegate

-(void)gpGotPlaces:(NSDictionary *)places {
    gotGP = YES;
    NSLog(@"Got Google places");
    [self gotMorePlaces:places];}

-(void)gpFailedToGetPlaces:(NSError *)error {
    NSLog(@"Failed to get Google places - %@", error.description);
}


@end
