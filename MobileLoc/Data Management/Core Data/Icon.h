//
//  Icon.h
//  mobileloc
//
//  Created by ANDREW KUCHARSKI on 2/7/14.
//  Copyright (c) 2014 GeoffroyLesage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Icon : NSManagedObject

@property (nonatomic, retain) NSData * icon;
@property (nonatomic, retain) NSManagedObject *places;

@end
