//
//  GooglePlaces.h
//  mobileloc
//
//  Created by ANDREW KUCHARSKI on 2/7/14.
//  Copyright (c) 2014 GeoffroyLesage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol GooglePlacesDelegate
- (void)gpGotPlaces:(NSDictionary*)places;
- (void)gpFailedToGetPlaces:(NSError*)error;

@end

@interface GooglePlaces : NSObject {
    AFHTTPSessionManager *manager;
}

@property (weak, nonatomic) id <GooglePlacesDelegate> delegate;

-(id)initWithLocation:(CLLocation*)location;
-(void)cancelFetching;

@end
