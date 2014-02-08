//
//  Place.h
//  mobileloc
//
//  Created by ANDREW KUCHARSKI on 2/8/14.
//  Copyright (c) 2014 GeoffroyLesage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Icon;

@interface Place : NSManagedObject

@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * open_now;
@property (nonatomic, retain) NSString * types;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSString * source;
@property (nonatomic, retain) Icon *icon_rel;

@end
