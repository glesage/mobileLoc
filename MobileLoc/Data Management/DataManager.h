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

#define GOT_NEW_PLACES  @"GNP_NOTIF"
#define DMGR_PROBLEM    @"DMGRP_NOTIF"
#define GOT_NEW_IMAGE   @"GNI_NOTIF"

#define TIMEOUT_REPEATS 10

@interface DataManager : NSObject <PlaceFetcherDelegate> {
    PlaceFetcher *placeFetcher;
    DataStorage *dataStorage;
    
    int repeatCounter;
}

+ (DataManager *)sharedManager;
    
-(void)fetchNearPlaces;
-(NSArray*)getAllPlaces;

@end
