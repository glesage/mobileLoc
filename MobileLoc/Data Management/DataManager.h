//
//  DataManager.h
//  mobileloc
//
//  Created by GEOFFROY LESAGE on 2/7/14.
//  Copyright (c) 2014 GeoffroyLesage. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PlaceFetcher.h"
#import "DataStorage.h"

#define GOT_NEW_PLACES @"GNP_NOTIF"
#define UNABLE_TO_FETCH_PLACES @"UTFP_NOTIF"
#define GOT_NEW_IMAGE @"GNI_NOTIF"

@interface DataManager : NSObject <PlaceFetcherDelegate> {
    PlaceFetcher *placeFetcher;
    DataStorage *dataStorage;
}

+ (DataManager *)sharedManager;
-(NSArray*)getAllPlaces;

@end
