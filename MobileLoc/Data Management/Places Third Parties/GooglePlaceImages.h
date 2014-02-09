//
//  GooglePlaceImages.h
//  mobileloc
//
//  Created by ANDREW KUCHARSKI on 2/8/14.
//  Copyright (c) 2014 GeoffroyLesage. All rights reserved.
//

#import "GooglePlaces.h"

@protocol GooglePlaceImagesDelegate
- (void)gpiGotImage:(UIImage*)image for:(NSString*)placeName;
- (void)gpiFailedToGetImage:(NSError*)error;

@end

@interface GooglePlaceImages : NSObject {
    AFHTTPSessionManager *manager;
}

@property (weak, nonatomic) id <GooglePlaceImagesDelegate> delegate;

-(id)initWithPlaces:(NSArray*)places;

@end
