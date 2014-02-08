//
//  GooglePlaces.m
//  mobileloc
//
//  Created by ANDREW KUCHARSKI on 2/7/14.
//  Copyright (c) 2014 GeoffroyLesage. All rights reserved.
//

#import "GooglePlaces.h"


static NSString *const GP_BASE_URL = @"https://maps.googleapis.com/maps/api/place/nearbysearch/json";
static NSString *const GPP_BASE_URL = @"https://maps.googleapis.com/maps/api/place/photo";

#define GP_API_KEY @"AIzaSyCeABNGmxmHWXWt-0Jsq-lwzSJL7ZG_Omk"
#define SEARCH_RADIUS @"500"


@implementation GooglePlaces

-(id)initWithLocation:(CLLocation*)location {
    self = [super init];
    if (self) [self fetchGooglePlacesAround:location.coordinate];
    return self;
}

/*
 * Queries Google Places for all places
 * within SEARCH_RADIUS meters of the given location
 */
-(void)fetchGooglePlacesAround:(CLLocationCoordinate2D)coordinates {
    
    manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *coordinatesParam = [NSString stringWithFormat:@"%f, %f", coordinates.latitude, coordinates.longitude];
    
    [manager GET:[[NSURL URLWithString:GP_BASE_URL] absoluteString]
      parameters:@{
                       @"key": GP_API_KEY,
                       @"location": coordinatesParam,
                       @"radius": SEARCH_RADIUS,
                       @"sensor": @"true",
                       @"language": @"en"
                   }
         success:^(NSURLSessionDataTask *task, id responseObject) {
             NSDictionary *rawPlaces = (NSDictionary*)responseObject;
             [self.delegate gpGotPlaces:[self checkAndFormatPlaces:rawPlaces[@"results"]]];
         }
         failure:^(NSURLSessionDataTask *task, NSError *error) {
             [self.delegate gpFailedToGetPlaces:error];
         }];
}

/*
 * Goes through every place from the response object
 * and only keeps the elements which we care about,
 * as well as formats them properly (remove excess whitespace...)
 */
-(NSArray*)checkAndFormatPlaces:(NSDictionary*)rawPlaces {
    NSMutableArray *places = [NSMutableArray arrayWithCapacity:rawPlaces.count];
    
    for (NSDictionary *place in rawPlaces) {
        
        // Ignore the place if is not a dictionary (there are also status messages in the responseObject object)
        if (![place isKindOfClass:[NSDictionary class]]) continue;
        
        // Get & Format the place IMAGE, if any
        NSString *iconReference = @"-";
        if ([place[@"photos"] count] > 0) iconReference = place[@"photos"][0][@"photo_reference"];
        
        // Get & Format the OPEN property, if any
        NSNumber *openNow = [NSNumber numberWithBool:NO];
        if (place[@"opening_hours"] && place[@"opening_hours"][@"open_now"]) {
            openNow = [NSNumber numberWithInt:[place[@"opening_hours"][@"open_now"] intValue]];
        }
        
        // Get, Check & Format the place TYPE(s), if any
        NSMutableString *types = [NSMutableString stringWithString:@"-"];
        if (place[@"types"]) {
            id theTypes = place[@"types"];
            
            // If the place[@"types"] is a string, separate the types into an array
            if ([theTypes isKindOfClass:[NSString class]])
            {
                theTypes = [theTypes componentsSeparatedByString:@","];
            }
            // If the place[@"types"} is still not an array, then it must be invalid so skip it
            if (![theTypes isKindOfClass:[NSArray class]]) continue;
            
            for (NSString *type in theTypes) {
                [types appendFormat:@"%@,", [self trimWhiteSpaceFrom:type]];
            }
            
            types =  (NSMutableString*)[[types substringFromIndex:1] substringToIndex:types.length-2];
        }
        
        NSDictionary *finalPlace = @{
                                     @"name" : place[@"name"],
                                     @"latitude" : place[@"geometry"][@"location"][@"lat"],
                                     @"longitude" : place[@"geometry"][@"location"][@"lng"],
                                     @"address" : place[@"vicinity"],
                                     @"open" : openNow,
                                     @"types" : [NSString stringWithString:types],
                                     @"icon" : iconReference
                                     };
        [places addObject:finalPlace];
    }
    return places;
}
-(NSString*)trimWhiteSpaceFrom:(NSString*)inputString {
    return [inputString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

/*
 * Queries Google Places for the photo image of a given place
 */
-(void)queueImageFetchingForPlace:(NSDictionary*)place {
    manager.responseSerializer = [AFImageResponseSerializer serializer];
    
    NSString *imageReference = place[@"photos"][0][@"photo_reference"];
    [manager GET:[[NSURL URLWithString:GPP_BASE_URL] absoluteString]
      parameters:@{
                       @"key": GP_API_KEY,
                       @"photoreference": imageReference,
                       @"maxheight": @"80",
                       @"sensor": @"true"
                   }
         success:^(NSURLSessionDataTask *task, id responseObject) {
             //responseObject is a UImage
             //[place setObject:[self getImageForPlace:place] forKey:@"image"];
             //[place removeObjectForKey:@"photos"];
         }
         failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSLog(@"Failed to get image: %@", error.description);
         }];
}

-(void)cancelFetching {
    [[manager operationQueue] cancelAllOperations];
}

@end
