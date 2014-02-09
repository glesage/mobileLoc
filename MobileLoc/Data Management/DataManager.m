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
        
        repeatCounter = 0;
        [self fetchNearPlaces];
    }
    return self;
}

/*
 * Attempt to launch place fetching
 *
 * Checks for location services before for TIMEOUT_REPEATS number of times
 * If location is not enabled after this timer then STOP
 */
-(void)fetchNearPlaces {
    if (repeatCounter > TIMEOUT_REPEATS) {
        [self pfFailedToGetPlaces:[NSError errorWithDomain:@"com.gl.mobileloc"
                                                      code:1
                                                  userInfo:@{@"error" : @"Location services disabled"}]
         ];
        repeatCounter = 0;
        return;
    }
    if (![[LocationManager sharedManager] locationEnabled]) {
        repeatCounter++;
        [self performSelector:@selector(fetchNearPlaces) withObject:nil afterDelay:1];
        return;
    }
    [placeFetcher fetchPlacesAround:[[LocationManager sharedManager] getCurrentLocation]];
}

-(NSArray*)getAllPlaces {
    return [dataStorage getAllPlaces];
}


# pragma mark - PlaceFetcherDelegate

-(void)pfGotAllPlaces:(NSArray *)places
{
    // If no new places have been saved, no need to change anything,
    // and especially no need to fetch new images!
    if (![dataStorage savePlaces:places]) return;
    
    // Otherwise, inform the world that we've got news
    [[NSNotificationCenter defaultCenter] postNotificationName:GOT_NEW_PLACES object:nil];
    
    // Then proceed to fetch images (after a short delay to let the UI rest)
    [placeFetcher performSelector:@selector(fetchImagesForAllPlaces) withObject:nil afterDelay:0.1];
}

-(void)notifyDelegateOfProblem:(NSString*)message
{
    [[NSNotificationCenter defaultCenter] postNotificationName:DMGR_PROBLEM
                                                        object:@{ @"message" : message }];
}
-(void)pfFailedToGetPlaces:(NSString *)message
{
    [self notifyDelegateOfProblem:message];
}
-(void)pfFailedToGetImage:(NSString *)message
{
    [self notifyDelegateOfProblem:message];
}

-(void)pfGotImage:(UIImage *)image for:(NSString *)placeName {
    [dataStorage saveImage:image forPlace:placeName];
    [[NSNotificationCenter defaultCenter] postNotificationName:GOT_NEW_IMAGE
                                                        object:Nil
                                                      userInfo:@{
                                                                 @"image" : image,
                                                                 @"placeName" : placeName
                                                                }];
}

-(void)pfTimedOut
{
    [self notifyDelegateOfProblem:@"Took too long to fetch places :("];
}

@end
