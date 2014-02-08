//
//  DataStorage.h
//  mobileloc
//
//  Created by ANDREW KUCHARSKI on 2/7/14.
//  Copyright (c) 2014 GeoffroyLesage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataStorage : NSObject <NSFetchedResultsControllerDelegate>

-(BOOL)savePlaces:(NSArray*)places;
-(void)saveImage:(UIImage*)image forPlace:(NSString*)placeName;

-(NSArray*)getAllPlaces;

@end
