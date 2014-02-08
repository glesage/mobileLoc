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
-(NSArray*)getAllPlaces {
    NSMutableArray *places = [NSMutableArray array];
    for (Place *place in [Place MR_findAll]) {
        NSDictionary *placeDict;
        if (place.icon_rel) {
            Icon *placeImage = place.icon_rel;
            placeDict = @{
                              @"id" : place.objectID,
                              @"name" : place.name,
                              @"address" : place.address,
                              @"latitude" : place.latitude,
                              @"longitude" : place.longitude,
                              @"types" : place.types,
                              @"open" : place.open_now,
                              @"image" : [UIImage imageWithData:placeImage.icon]
                          };
        }
        else placeDict = @{
                               @"id" : place.objectID,
                               @"name" : place.name,
                               @"address" : place.address,
                               @"latitude" : place.latitude,
                               @"longitude" : place.longitude,
                               @"types" : place.types,
                               @"open" : place.open_now,
                            };
        [places addObject:[NSMutableDictionary dictionaryWithDictionary:placeDict]];
    }
    
    return [NSArray arrayWithArray:places];
}

-(UIImage*)getImageForPlace:(NSString*)placeId {
    NSArray *placeImages = [Icon MR_findByAttribute:@"placeId" withValue:placeId];
    if (placeImages.count < 1) return nil;
        
    Icon *placeIcon = placeImages[0];
    UIImage *placeImage = [UIImage imageWithData:placeIcon.icon];
    
    if (!placeImages) return nil;
    return placeImage;
}


/*
 * Data Insert & Update
 */
-(void)savePlaces:(NSArray*)places {
    
    NSMutableDictionary *currentPlaces = [NSMutableDictionary dictionary];
    for (Place *place in [Place MR_findAll]) {
        [currentPlaces setObject:place forKey:place.name];
    }
    for (NSDictionary *place in places) {
        Place *prevPlace = [currentPlaces objectForKey:place[@"name"]];
        
        if (!prevPlace) [self saveNewPlace:place];
        
        else if (![prevPlace.open_now isEqualToNumber:place[@"open"]]) {
            [prevPlace MR_deleteEntity];
        }
    }
    
    /*
    NSMutableArray *types = [NSMutableArray array];
    for (Place *place in [Place MR_findAll]) {
        NSArray *placeTypes = [place.types componentsSeparatedByString:@","];
        for (NSString *type in placeTypes) {
            if ([types containsObject:type]) continue;
            [types addObject:type];
        }
        //NSLog(@"Place : %@ - %@ - %@", place.name, place.address, place.types);
    }
    NSLog(@"types: %@", types);
     */
}
-(void)saveNewPlace:(NSDictionary*)newPlace
{
    Place *place = [Place MR_createEntity];
    
    [place setName:newPlace[@"name"]];
    [place setAddress:newPlace[@"address"]];
    [place setLatitude:[NSNumber numberWithFloat:[newPlace[@"latitude"] floatValue]]];
    [place setLatitude:[NSNumber numberWithFloat:[newPlace[@"longitude"] floatValue]]];
    [place setOpen_now:[NSNumber numberWithInt:[newPlace[@"open"] intValue]]];
    [place setTypes:[newPlace[@"types"] description]];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

-(void)saveImage:(UIImage*)image forPlace:(NSString*)placeName
{
    Icon *placeImage = [Icon MR_createEntity];
    [placeImage setIcon:UIImagePNGRepresentation(image)];
    
    Place *imagePlace = [Place MR_findFirstByAttribute:@"name" withValue:placeName];
    [imagePlace setIcon_rel:placeImage];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

-(void)cleanUpOnExit {
    [MagicalRecord cleanUp];
    NSLog(@"Cleaned up");
}

@end
