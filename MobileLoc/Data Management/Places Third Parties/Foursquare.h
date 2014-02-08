//
//  Foursquare.h
//  mobileloc
//
//  Created by ANDREW KUCHARSKI on 2/7/14.
//  Copyright (c) 2014 GeoffroyLesage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import <FSOAuth.h>


static NSString *const FSQ_SEARCH_URL = @"https://maps.googleapis.com/maps/api/place/nearbysearch/json";
static NSString *const FSQ_TOKEN_URL =  @"https://foursquare.com/oauth2/access_token";
static NSString *const FSQ_AUTH_URL =   @"https://foursquare.com/oauth2/authorize";
static NSString *const FSQ_CALLBK_URL = @"mobileloc://foursquare";


#define FSQ_CLIENT_ID       @"RPPYZMX1QLH43BDZFTBXODYIZBSOX33GJC4C155OAWITBZRQ"
#define FSQ_CLIENT_SECRET   @"314N0WTLQZHVDLRAE40OU5REPLTPHJVTGQFJTBK5ORWY2CK2"


@protocol FoursquareDelegate
- (void)fsqGotPlaces:(NSArray*)places;
- (void)fsqFailedToGetPlaces:(NSError*)error;

@end

@interface Foursquare : NSObject

@property (weak, nonatomic) id <FoursquareDelegate> delegate;

-(id)initWithLocation:(CLLocation*)location;
-(void)cancelFetching;

@end
