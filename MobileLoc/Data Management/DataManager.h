//
//  DataManager.h
//  mobileloc
//
//  Created by GEOFFROY LESAGE on 2/7/14.
//  Copyright (c) 2014 GeoffroyLesage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlaceFetcher.h"

@interface DataManager : NSObject <PlaceFetcherDelegate> {
    PlaceFetcher *placeFetcher;
}

+ (DataManager *)sharedManager;

@end
