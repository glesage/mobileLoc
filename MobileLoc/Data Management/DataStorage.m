//
//  DataStorage.m
//  mobileloc
//
//  Created by ANDREW KUCHARSKI on 2/7/14.
//  Copyright (c) 2014 GeoffroyLesage. All rights reserved.
//

#import "DataStorage.h"

#import "Place.h"
#import "Icon.h"

@implementation DataStorage

- (id)init {
    self = [super init];
    if (self) {
        [MagicalRecord setupCoreDataStack];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(cleanUpOnExit)
                                                     name:@"APP_WILL_TERMINATE_NOTIF"
                                                   object:nil];
    }
    return self;
}

/*
 * Data Accessors
 */
/*
-(NSFetchedResultsController*)fetchedResultsController {
   
}
*/
 
/*
 * Data Insert & Update
 */
-(void)savePlaces:(NSArray*)places {
    
    for (NSDictionary *place in places) {
        [self saveNewPlace:place];
    }
    
    /*
    for (Place *place in [Place MR_findAll]) {
        NSLog(@"Place : %@ - %@ - %@", place.name, place.address, place.types);
    }
     */
}
-(void)saveNewPlace:(NSDictionary*)newPlace {
        
    Place *place = [Place MR_createEntity];
    
    [place setName:newPlace[@"name"]];
    [place setAddress:newPlace[@"address"]];
    [place setLatitude:[NSNumber numberWithFloat:[newPlace[@"latitude"] floatValue]]];
    [place setLatitude:[NSNumber numberWithFloat:[newPlace[@"longitude"] floatValue]]];
    [place setOpen_now:[NSNumber numberWithInt:[newPlace[@"open"] intValue]]];
    [place setTypes:[newPlace[@"types"] description]];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

-(void)cleanUpOnExit {
    [MagicalRecord cleanUp];
    NSLog(@"Cleaned up");
}

@end
