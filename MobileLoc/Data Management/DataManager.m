//
//  DataManager.m
//  mobileloc
//
//  Created by GEOFFROY LESAGE on 2/7/14.
//  Copyright (c) 2014 GeoffroyLesage. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

@synthesize placeFetcher;


static DataManager *sharedDataManager;

+ (DataManager *)sharedManager;
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        sharedDataManager = [[DataManager alloc] init];
    }
    return sharedDataManager;
}

- (id)init {
    self = [super init];
    if (self) {
        NSLog(@"Inited!!");
    }
    return self;
}

@end
