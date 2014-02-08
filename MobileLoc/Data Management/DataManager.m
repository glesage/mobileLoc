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

        [placeFetcher fetchPlacesAround:[[LocationManager sharedManager] getCurrentLocation]];
    }
    return self;
}

-(NSArray*)getAllPlaces {
    return [dataStorage getAllPlaces];
}


# pragma mark - PlaceFetcherDelegate

-(void)pfGotAllPlaces:(NSArray *)places
{
    if (![dataStorage savePlaces:places]) return; // If no new places have been saved, no need to change the UI!
    
    // Otherwise, inform the world that we've got news
    [[NSNotificationCenter defaultCenter] postNotificationName:GOT_NEW_PLACES
                                                        object:nil];
    // Then proceed to fetch images
    [placeFetcher fetchImagesForAllPlaces];
}

-(void)pfFailedToGetPlaces:(NSError *)error {
    [[NSNotificationCenter defaultCenter] postNotificationName:UNABLE_TO_FETCH_PLACES
                                                        object:@{ @"error" : error.description }];
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

-(void)pfTimedOut {
    [[NSNotificationCenter defaultCenter] postNotificationName:UNABLE_TO_FETCH_PLACES
                                                        object:@{ @"message" : @"Took too long to fetch places :(" }];
}

@end
