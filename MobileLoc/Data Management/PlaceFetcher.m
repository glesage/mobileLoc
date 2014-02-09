//
//  PlaceFetcher.m
//  mobileloc
//
//  Created by ANDREW KUCHARSKI on 2/7/14.
//  Copyright (c) 2014 GeoffroyLesage. All rights reserved.
//

#import "PlaceFetcher.h"

#define FETCHING_TIME_OUT 30 //(seconds)


@implementation PlaceFetcher


- (id)init {
    self = [super init];
    if (self) {
        allPlaces = [[NSMutableArray alloc] init];
    }
    return self;
}


#pragma mark - Callbacks

/*
 * Instanciates all third party API fetchers
 * and calls to each to get places.
 *
 * Also starts the timeout timer to make sure 
 * the user does not wait too long...
 */
-(void)fetchPlacesAround:(CLLocation*)location
{
    [allPlaces removeAllObjects];
    
    notifiedForPlaces = NO;
    notifiedForImage = NO;
    
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    BOOL use_GOOGLE = ![defaults boolForKey:@"no-google"];
    BOOL use_FOURSQUARE = ![defaults boolForKey:@"no-fsq"];
    
     if (use_GOOGLE) {
         googlePlaces = [[GooglePlaces alloc] initWithLocation:location];
         [googlePlaces setDelegate:self];
         gotGP = FALSE;
     }
     else gotGP = TRUE; // Set to true so that we don't wait indefinitely in gotMorePlaces()

    if (use_FOURSQUARE) {
        fsq = [[Foursquare alloc] initWithLocation:location];
        [fsq setDelegate:self];
        gotFSQ = FALSE;
    }
    else gotFSQ = TRUE; // Set to true so that we don't wait indefinitely in gotMorePlaces()
    
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
-(void)reachedTimeout
{
    [googlePlaces cancelFetching];
    [fsq cancelFetching];
    
    [self.delegate pfTimedOut];
}

/*
 * Gets called everytime a third party returns places
 *
 * Checks if all third-parties have returned places
 * If so, it returns all the places to the delegate
 */
-(void)gotMorePlaces:(NSArray*)places
{
    @synchronized(allPlaces) {
        [allPlaces addObjectsFromArray:places];
    }
    
    if (gotGP && gotFSQ) //Once all third parties have responded, proceed
    {
        [timeOutTimer invalidate];
        timeOutTimer = nil;
        
        [self.delegate pfGotAllPlaces:allPlaces];
    }
}


/*
 * Instanciates all third-party API fetchers
 * and calls to each to get each place's image.
 */
-(void)fetchImagesForAllPlaces
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    BOOL use_GOOGLE = ![defaults boolForKey:@"no-google"];
    BOOL use_FOURSQUARE = ![defaults boolForKey:@"no-fsq"];
    
    if (use_GOOGLE) {
        [self fetchGPIForPlaces:allPlaces];
    }
    
    if (use_FOURSQUARE) {
        [self fetchFSQIForPlaces:allPlaces];
    }
    
    [allPlaces removeAllObjects];
}
// Call Google Places Images for fetching
-(void)fetchGPIForPlaces:(NSArray*)places {
    GooglePlaceImages *googlePlaceImages = [[GooglePlaceImages alloc] initWithPlaces:places];
    [googlePlaceImages setDelegate:self];
}
// Call Foursquare Images for fetching
-(void)fetchFSQIForPlaces:(NSArray*)places {
    FoursquareImages *fsqImages = [[FoursquareImages alloc] initWithPlaces:places];
    [fsqImages setDelegate:self];
}


# pragma mark - Third-party Place delegates

// GooglePlaces Delegate
-(void)gpGotPlaces:(NSArray *)places
{
    gotGP = YES;
    [self gotMorePlaces:places];
}
-(void)gpFailedToGetPlaces:(NSError *)error
{
    if (!notifiedForPlaces) [self.delegate pfFailedToGetPlaces:error.userInfo[@"message"]];
    notifiedForPlaces = YES;
    NSLog(@"Failed to get Google places - %@", error.description);
}

// Foursquare Delegate
-(void)fsqGotPlaces:(NSArray *)places
{
    gotFSQ = YES;
    [self gotMorePlaces:places];
}
-(void)fsqFailedToGetPlaces:(NSError *)error
{
    if (!notifiedForPlaces) [self.delegate pfFailedToGetPlaces:error.userInfo[@"message"]];
    notifiedForPlaces = YES;
    NSLog(@"Failed to get Foursquare places - %@", error.description);
}


# pragma mark - Third-party image delegate

// GooglePlaceImages Delegate
-(void)gpiGotImage:(UIImage*)image for:(NSString*)placeName
{
    if (!image) return;
    [self.delegate pfGotImage:image for:placeName];
}
-(void)gpiFailedToGetImage:(NSError *)error
{
    if (!notifiedForImage) [self.delegate pfFailedToGetPlaces:error.userInfo[@"message"]];
    notifiedForImage = YES;
    NSLog(@"Failed to get Google Place Image - %@", error.description);
}

// FoursquareImages Delegate
-(void)fsqiGotImage:(UIImage*)image for:(NSString*)placeName
{
    if (!image) return;
    [self.delegate pfGotImage:image for:placeName];
}
-(void)fsqiFailedToGetImage:(NSError *)error
{
    if (!notifiedForImage) [self.delegate pfFailedToGetImage:error.userInfo[@"message"]];
    notifiedForImage = YES;
    NSLog(@"Failed to get Foursquare Image - %@", error.description);
}


@end
