//
//  GooglePlaces.m
//  mobileloc
//
//  Created by ANDREW KUCHARSKI on 2/7/14.
//  Copyright (c) 2014 GeoffroyLesage. All rights reserved.
//

#import "GooglePlaces.h"


static NSString *const GP_BASE_URL = @"https://maps.googleapis.com/maps/api/place/nearbysearch/json";

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
             NSDictionary * places = (NSDictionary *)responseObject;
             [self.delegate gpGotPlaces:places];
         }
         failure:^(NSURLSessionDataTask *task, NSError *error) {
             [self.delegate gpFailedToGetPlaces:error];
         }];
}

-(void)cancelFetching {
    [[manager operationQueue] cancelAllOperations];
}

@end
