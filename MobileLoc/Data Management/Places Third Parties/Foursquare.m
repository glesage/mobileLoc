//
//  Foursquare.m
//  mobileloc
//
//  Created by GEOFFROY LESAGE on 2/7/14.
//  Copyright (c) 2014 GeoffroyLesage. All rights reserved.
//

#import "Foursquare.h"

#import <Foursquare2.h>


@implementation Foursquare

-(id)initWithLocation:(CLLocation*)location {
    self = [super init];
    
    [Foursquare2 setupFoursquareWithClientId:FSQ_CLIENT_ID
                                      secret:FSQ_CLIENT_SECRET
                                 callbackURL:FSQ_CALLBK_URL];
    
    if (self) [self fetchFoursquarePlacesAround:location.coordinate];
    return self;
}

/*
 * Queries Google Places for all places
 * within proximity of the given location
 */
-(void)fetchFoursquarePlacesAround:(CLLocationCoordinate2D)coordinates {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    int radius = 500;
    if ([defaults objectForKey:@"distance"]) radius = [[defaults objectForKey:@"distance"] intValue];
    
    [Foursquare2 venueSearchNearByLatitude:@(coordinates.latitude)
                                 longitude:@(coordinates.longitude)
                                     query:nil
                                     limit:nil
                                    intent:intentCheckin
                                    radius:@(radius)
                                categoryId:nil
                                  callback:^(BOOL success, id result){
                                      if (success) {
                                          NSArray *venues = [(NSDictionary*)result valueForKeyPath:@"response.venues"];
                                          NSArray *places = [self checkAndFormatPlaces:venues];
                                          [self.delegate fsqGotPlaces:places];
                                      } else {
                                          [self.delegate fsqFailedToGetPlaces:[NSError errorWithDomain:@"com.gl.mobileloc" code:7
                                                                                              userInfo:@{
                                                                                                         @"message" :@"Could not get Foursquare places",
                                                                                                         @"error" : result
                                                                                                         }
                                                                               ]
                                           ];
                                      }
                                  }];
}


/*
 * Goes through every place from the response object
 * and only keeps the elements which we care about,
 * as well as formats them properly (remove excess whitespace...)
 */
-(NSArray*)checkAndFormatPlaces:(NSArray*)rawPlaces {
    NSMutableArray *places = [NSMutableArray arrayWithCapacity:rawPlaces.count];
    
    for (NSDictionary *place in rawPlaces) {
        
        // Ignore the place if is not a dictionary (there are also status messages in the responseObject object)
        if (![place isKindOfClass:[NSDictionary class]]) continue;
        
        // Formatting the type string
        NSString *type = @"na";
        if (place[@"categories"] && [place[@"categories"] count] > 0) type = place[@"categories"][0][@"name"];
        type = [type lowercaseString];
        type = [type stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        
        NSDictionary *finalPlace = @{
                                     @"name" :      place[@"name"],
                                     @"latitude" :  place[@"location"][@"lat"],
                                     @"longitude" : place[@"location"][@"lng"],
                                     @"open" :      [NSNumber numberWithBool:NO],
                                     @"types" :     type,
                                     @"distance" :  place[@"location"][@"distance"],
                                     @"source" :    @"foursquare",
                                     @"icon" :      place[@"id"]
                                     };
        [places addObject:finalPlace];
    }
    return places;
}

-(void)cancelFetching {
    // Does nothing
}

@end
