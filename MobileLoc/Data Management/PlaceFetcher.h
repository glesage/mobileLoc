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

#import "Foursquare.h"
#import "FoursquareImages.h"

@protocol PlaceFetcherDelegate
- (void)pfGotAllPlaces:(NSArray*)places;
- (void)pfFailedToGetPlaces:(NSString*)message;
- (void)pfGotImage:(UIImage*)image for:(NSString*)placeName;
- (void)pfFailedToGetImage:(NSString*)message;
- (void)pfTimedOut;

@end

@interface PlaceFetcher : NSObject <GooglePlacesDelegate, GooglePlaceImagesDelegate, FoursquareDelegate, FoursquareImagesDelegate>
{
    GooglePlaces *googlePlaces;
    BOOL gotGP;
    
    Foursquare *fsq;
    BOOL gotFSQ;
    
    BOOL notifiedForImage;
    BOOL notifiedForPlaces;
    
    NSTimer *timeOutTimer;
    
    NSMutableArray *allPlaces;
}

@property (weak, nonatomic) id <PlaceFetcherDelegate> delegate;

-(void)fetchPlacesAround:(CLLocation*)location;
-(void)fetchImagesForAllPlaces;

@end
