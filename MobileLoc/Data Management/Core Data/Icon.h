//
//  Icon.h
//  mobileloc
//
//  Created by ANDREW KUCHARSKI on 2/8/14.
//  Copyright (c) 2014 GeoffroyLesage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Place;

@interface Icon : NSManagedObject

@property (nonatomic, retain) NSData * icon;
@property (nonatomic, retain) Place *places_rel;

@end
