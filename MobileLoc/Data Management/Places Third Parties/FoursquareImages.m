//
//  Foursquare.m
//  mobileloc
//
//  Created by GEOFFROY LESAGE on 2/7/14.
//  Copyright (c) 2014 GeoffroyLesage. All rights reserved.
//

#import "FoursquareImages.h"

#import <Foursquare2.h>


@implementation FoursquareImages


-(id)initWithPlaces:(NSArray*)places {
    self = [super init];
    
    [Foursquare2 setupFoursquareWithClientId:FSQ_CLIENT_ID
                                      secret:FSQ_CLIENT_SECRET
                                 callbackURL:FSQ_CALLBK_URL];
    
    if (self) [self fetchFoursquareImagesFor:places];
    return self;
}

-(void)fetchFoursquareImagesFor:(NSArray*)places
{
    manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFImageResponseSerializer serializer];
    
    for (NSDictionary *place in places)
    {
        if (!place[@"icon"] || [place[@"icon"] isEqualToString:@"-"]) continue;
        if (![place[@"source"] isEqualToString:@"foursquare"]) continue;
        [self fetchImageForPlace:place];
    }
}

/*
 * Queries Foursquare for the photo image of a given place
 */
-(void)fetchImageForPlace:(NSDictionary*)place {
    
    [Foursquare2 venueGetPhotos:place[@"icon"]
                             limit:@1
                            offset:@0
                          callback:^(BOOL success, id result){
                              if (success) {
                                  NSArray *images = [(NSDictionary*)result valueForKeyPath:@"response.photos.items"];
                                  if (!images || images.count < 1) return;
                                  
                                  NSString *urlString = [NSString stringWithFormat:@"%@%@x%@%@",
                                                         images[0][@"prefix"],
                                                         images[0][@"height"],
                                                         images[0][@"width"],
                                                         images[0][@"suffix"]];
                                  
                                  [manager GET:[[NSURL URLWithString:urlString] absoluteString]
                                    parameters:nil
                                       success:^(NSURLSessionDataTask *task, id responseObject) {
                                           //responseObject is a UImage
                                           [self.delegate fsqiGotImage:responseObject for:place[@"name"]];
                                       }
                                       failure:^(NSURLSessionDataTask *task, NSError *error) {
                                           [self.delegate fsqiFailedToGetImage:[NSError errorWithDomain:@"com.gl.mobileloc" code:7
                                                                                               userInfo:@{
                                                                                                          @"message" : @"Could not get Foursquare images",
                                                                                                          @"error": error
                                                                                                          }
                                                                                ]
                                            ];
                                       }];
                                  
                              } else {
                                  [self.delegate fsqiFailedToGetImage:[NSError errorWithDomain:@"com.gl.mobileloc" code:7
                                                                                      userInfo:@{
                                                                                                 @"message" : @"Could not get Foursquare images",
                                                                                                 @"error": result
                                                                                                 }
                                                                       ]
                                   ];
                              }
                          }];
}

@end
