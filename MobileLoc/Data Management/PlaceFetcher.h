//
//  PlaceFetcher.h
//  mobileloc
//
//  Created by ANDREW KUCHARSKI on 2/7/14.
//  Copyright (c) 2014 GeoffroyLesage. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GooglePlaces.h"
#import "GooglePlaceImages.h"

@protocol PlaceFetcherDelegate
- (void)pfGotAllPlaces:(NSArray*)places;
- (void)pfFailedToGetPlaces:(NSError*)error;
- (void)pfGotImage:(UIImage*)image for:(NSString*)placeName;
- (void)pfTimedOut;

@end

@interface PlaceFetcher : NSObject <GooglePlacesDelegate, GooglePlaceImagesDelegate> {
    GooglePlaces *googlePlaces;
    GooglePlaceImages *googlePlaceImages;
    BOOL gotGP;
    
    NSTimer *timeOutTimer;
    
    NSMutableArray *allPlaces;
}

@property (weak, nonatomic) id <PlaceFetcherDelegate> delegate;

-(void)fetchPlacesAround:(CLLocation*)location;
-(void)fetchImagesForAllPlaces;

@end
