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
        //[Place MR_truncateAll];
        
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
-(NSArray*)getAllPlaces
{
    NSMutableArray *places = [NSMutableArray array];
    for (Place *place in [Place MR_findAll])
    {        
        NSDictionary *placeDict;
        if (place.icon_rel) {
            Icon *placeImage = place.icon_rel;
            placeDict = @{
                              @"id" : place.objectID,
                              @"name" : place.name,
                              @"distance" : place.distance,
                              @"latitude" : place.latitude,
                              @"longitude" : place.longitude,
                              @"types" : place.types,
                              @"source" : place.source,
                              @"open" : place.open_now,
                              @"image" : [UIImage imageWithData:placeImage.icon]
                          };
        }
        else placeDict = @{
                               @"id" : place.objectID,
                               @"name" : place.name,
                               @"distance" : place.distance,
                               @"latitude" : place.latitude,
                               @"longitude" : place.longitude,
                               @"types" : place.types,
                               @"source" : place.source,
                               @"open" : place.open_now,
                            };
        [places addObject:[NSMutableDictionary dictionaryWithDictionary:placeDict]];
    }
    
    return [NSArray arrayWithArray:places];
}


/*
 * Data Insert & Update
 */
-(BOOL)savePlaces:(NSArray*)places {
    
    NSMutableDictionary *currentPlaces = [NSMutableDictionary dictionary];
    for (Place *place in [Place MR_findAll]) {
        [currentPlaces setObject:place forKey:place.name];
    }
    
    BOOL savedATLeastOne = NO;
    
    for (NSDictionary *place in places) {
        Place *prevPlace = [currentPlaces objectForKey:place[@"name"]];
        
        if (!prevPlace) {
            [self saveNewPlace:place];
            savedATLeastOne = YES;
        }
        
        else if (![prevPlace.open_now isEqualToNumber:place[@"open"]]) {
            [prevPlace MR_deleteEntity];
            [self saveNewPlace:place];
            savedATLeastOne = YES;
        }
    }
    return savedATLeastOne;
}
-(void)saveNewPlace:(NSDictionary*)newPlace
{
    Place *place = [Place MR_createEntity];
    
    [place setName:     newPlace[@"name"]];
    [place setDistance: newPlace[@"distance"]];
    [place setSource:   newPlace[@"source"]];
    [place setTypes:    [newPlace[@"types"] description]];
    
    [place setLatitude: [NSNumber numberWithFloat:  [newPlace[@"latitude"] floatValue]]];
    [place setLongitude:[NSNumber numberWithFloat:  [newPlace[@"longitude"] floatValue]]];
    [place setOpen_now: [NSNumber numberWithInt:    [newPlace[@"open"] intValue]]];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

-(void)saveImage:(UIImage*)image forPlace:(NSString*)placeName
{
    Icon *placeImage = [Icon MR_createEntity];
    [placeImage setIcon:UIImagePNGRepresentation(image)];
    
    Place *place = [Place MR_findFirstByAttribute:@"name" withValue:placeName];
    [place setIcon_rel:placeImage];

    [placeImage setPlaces_rel:place];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

-(void)cleanUpOnExit {
    [MagicalRecord cleanUp];
    NSLog(@"Cleaned up");
}

@end
