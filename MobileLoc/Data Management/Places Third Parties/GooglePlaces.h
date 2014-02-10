//
//  GooglePlaces.h
//  mobileloc
//
//  Created by GEOFFROY LESAGE on 2/7/14.
//  Copyright (c) 2014 GeoffroyLesage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


static NSString *const GP_BASE_URL = @"https://maps.googleapis.com/maps/api/place/nearbysearch/json";
static NSString *const GPP_BASE_URL = @"https://maps.googleapis.com/maps/api/place/photo";

#define GP_API_KEY @"AIzaSyCtuWWbAibU_Qg8Bbq9udqHrNNE2FD4Ias"


@protocol GooglePlacesDelegate
- (void)gpGotPlaces:(NSArray*)places;
- (void)gpFailedToGetPlaces:(NSError*)error;

@end

@interface GooglePlaces : NSObject {
    AFHTTPSessionManager *manager;
}

@property (weak, nonatomic) id <GooglePlacesDelegate> delegate;

-(id)initWithLocation:(CLLocation*)location;
-(void)cancelFetching;

@end
