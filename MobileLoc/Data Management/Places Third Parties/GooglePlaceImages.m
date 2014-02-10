//
//  GooglePlaceImages.m
//  mobileloc
//
//  Created by GEOFFROY LESAGE on 2/8/14.
//  Copyright (c) 2014 GeoffroyLesage. All rights reserved.
//

#import "GooglePlaceImages.h"


@implementation GooglePlaceImages

-(id)initWithPlaces:(NSArray*)places {
    self = [super init];
    if (self) [self fetchGooglePlaceImagesFor:places];
    return self;
}

-(void)fetchGooglePlaceImagesFor:(NSArray*)places {
    manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFImageResponseSerializer serializer];
    
    for (NSDictionary *place in places)
    {
        if (!place[@"icon"] || [place[@"icon"] isEqualToString:@"-"]) continue;
        if (![place[@"source"] isEqualToString:@"google"]) continue;
        [self fetchImageForPlace:place];
    }
}

/*
 * Queries Google Places for the photo image of a given place
 */
-(void)fetchImageForPlace:(NSDictionary*)place {
    
    [manager GET:[[NSURL URLWithString:GPP_BASE_URL] absoluteString]
      parameters:@{
                    @"key": GP_API_KEY,
                    @"photoreference": place[@"icon"],
                    @"maxheight": @"80",
                    @"sensor": @"true"
                   }
         success:^(NSURLSessionDataTask *task, id responseObject) {
             //responseObject is a UImage
             [self.delegate gpiGotImage:responseObject for:place[@"name"]];
         }
         failure:^(NSURLSessionDataTask *task, NSError *error) {
             [self.delegate gpiFailedToGetImage:[NSError errorWithDomain:@"com.gl.mobileloc" code:6
                                                                userInfo:@{
                                                                           @"message" : @"Could not get Google images",
                                                                           @"error": error
                                                                           }
                                                 ]
              ];
         }];
}

@end
