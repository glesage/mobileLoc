//
//  Foursquare.h
//  mobileloc
//
//  Created by GEOFFROY LESAGE on 2/7/14.
//  Copyright (c) 2014 GeoffroyLesage. All rights reserved.
//

#import "Foursquare.h"


@protocol FoursquareImagesDelegate
- (void)fsqiGotImage:(UIImage*)image for:(NSString*)placeName;
- (void)fsqiFailedToGetImage:(NSError*)error;

@end

@interface FoursquareImages : NSObject {
    AFHTTPSessionManager *manager;
}

@property (weak, nonatomic) id <FoursquareImagesDelegate> delegate;

-(id)initWithPlaces:(NSArray*)places;

@end
