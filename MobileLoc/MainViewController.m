//
//  MainViewController.m
//  mobileloc
//
//  Created by GEOFFROY LESAGE on 2/7/14.
//  Copyright (c) 2014 GeoffroyLesage. All rights reserved.
//

#import "MainViewController.h"

#import "LocationManager.h"
#import "DataManager.h"
#import "PlaceCell.h"

/* 
 * Time interval during which all alerts are ignored
 * (as they are most probably bugs due to location or network activity)
 */
#define NOTIFICATION_INTERVAL 2

@interface MainViewController ()

@end


@implementation MainViewController

@synthesize placeTable;

    
// Displays an alertView using the given title and message
-(void)alertWithTitle:(NSString*)title andMessage:(NSString*)message {
    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:title
                                                     message:message
                                                    delegate:self
                                           cancelButtonTitle:@"Ok"
                                           otherButtonTitles:nil];
    [alertV show];
}
    
/*
 * Instanciates the places container
 * Initializes the location & data singletons
 */
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    places = [[NSMutableArray alloc] init];
    
    [LocationManager sharedManager];
	[DataManager sharedManager];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [notificationTimer invalidate];
}

/*
 * When view appeared, watches following notifications:
 * - GOT_NEW_PLACES: When new places have been fetched and saved
 * - DMGR_PROBLEM: When a problem has occured somewhere
 * - APP_DID_BECOME_ACTIVE: When the app has become active
 */
    
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self checkGetPlaces];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newPlacesFetched) name:GOT_NEW_PLACES object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotProblem:) name:DMGR_PROBLEM object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchPlaces) name:@"APP_DID_BECOME_ACTIVE" object:nil];
}
-(void)fetchPlaces {
    [[DataManager sharedManager] fetchNearPlaces];
}
// Gets all places from data manager if none are currently in the 'places' container
-(void)checkGetPlaces {
    if (!places || places.count < 1) [self getAllPlaces];
}


#pragma mark - Data Handlers

-(void)newPlacesFetched
{
    [self getAllPlaces];
}
/*
 * Called when new places have been found
 * 
 * Removes all places currently in the 'places' container
 * Asks for the data manager for all known places
 * Calls to create table cells
 * Reloads the table view to show all place cells
 */
-(void)getAllPlaces
{
    [places removeAllObjects];
    [places addObjectsFromArray:[[DataManager sharedManager] getAllPlaces]];
    
    [self createTableCells];
    [placeTable reloadData];
}

-(void)setDontNotifyYet {
    dontNotifyYet = NO;
}
/*
 * Called when a problem notification is received
 * 
 * Checks if the user was just notified of a problem
 * if so, then it ignore the update as it is most probably eronerous
 *
 * if not, it checks for the validity of the error message
 * if it is valid, it prompts the user with it
 * otherwise it gives a generic message (worse case)
 */
-(void)gotProblem:(NSNotification*)notification
{
    if (dontNotifyYet) return;
    dontNotifyYet = YES;
    
    if (notificationTimer) [notificationTimer invalidate];
    notificationTimer = [NSTimer scheduledTimerWithTimeInterval:NOTIFICATION_INTERVAL
                                                         target:self
                                                       selector:@selector(setDontNotifyYet)
                                                       userInfo:nil
                                                        repeats:NO];
    NSDictionary *userInfo = notification.userInfo;
    if (userInfo[@"message"]) {
        [self alertWithTitle:@"Something went wrong..."
                  andMessage:[notification.userInfo objectForKey:@"message"]];
    }
    else [self alertWithTitle:@"Something went wrong..."
                   andMessage:@"Unfortunately, even we're not too sure what it is /:"];
}


#pragma mark - Settings & Map Views

- (void)settingsViewControllerDidFinish:(SettingsViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mapViewControllerDidFinish:(MapViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showSettings"]) {
        [[segue destinationViewController] setDelegate:self];
    }
    else if ([[segue identifier] isEqualToString:@"showMap"]) {
        [[segue destinationViewController] setDelegate:self];
        [(MapViewController*)[segue destinationViewController] setPlaces:[NSArray arrayWithArray:places]];
    }
}



#pragma mark - Place Cells business

/*
 * Manages the cell creation
 */
-(void)createTableCells
{
    NSMutableArray *tmpPlacesCells = [NSMutableArray arrayWithCapacity:places.count];
    for (NSDictionary *place in places) {
        [tmpPlacesCells addObject:[self createCellForPlace:place]];
    }
    placesCells = [[NSArray alloc] initWithArray:tmpPlacesCells];
}

/*
 * Creates the table cell for a given place
 *
 * Also handles the types icons
 */
-(PlaceCell*)createCellForPlace:(NSDictionary*)placeData
{
    static NSString *CellIdentifier = @"placeTableCell";
    PlaceCell *cell = [placeTable dequeueReusableCellWithIdentifier:@"placeTableCell"];
    if (!cell) {
        cell = [[PlaceCell alloc] initWithStyle:UITableViewCellStyleDefault
                                reuseIdentifier:CellIdentifier];
    }
    [cell observeImageUpdates];
    
    // Setup the Cell content
    [cell.nameLabel setText:placeData[@"name"]];
    
    // Main Photo
    if (placeData[@"image"]) [cell setMainIcon:placeData[@"image"]];
    
    // Open Status
    if ([placeData[@"source"] isEqualToString:@"foursquare"])
        [cell.openLabel setText:@"-"];
    else [cell setOpen:[placeData[@"open"] boolValue]];
    
    // Distance
    [cell.distanceLabel setText:[self getDistanceLabelForPlace:placeData]];
    
    // Types
    NSArray *types = [placeData[@"types"] componentsSeparatedByString:@","];
    NSString *type = [self getFormattedType:types[0]];
    
    [cell.typeLabel setText:type];
    UIImage *imgForType = [self imageForType:types[0]];
    if (imgForType) [cell.typeIcon setImage:imgForType];
    
    [cell.type2Icon setHidden:YES];
    [cell.type3Icon setHidden:YES];
    
    // If the place has multiple types, we show the extra type icons,
    // and shift the type label
    if (types.count > 1 && ![types[1] isEqualToString:@"establishment"])
        // Establishment is default from Google Places
        //so no need to show it unless it is the only type available
    {
        
        // Shift the typeLabel to the right
        [cell.typeLabel setTransform:CGAffineTransformMakeTranslation(24, 0)];
        CGRect typeFrame = cell.typeLabel.frame;
        [cell.typeLabel setFrame:CGRectMake(typeFrame.origin.x,
                                            typeFrame.origin.y,
                                            typeFrame.size.width-12,
                                            typeFrame.size.height)];
        
        // Show the second type icon
        [cell.type2Icon setHidden:NO];
        UIImage *imgForType = [self imageForType:types[1]];
        if (imgForType) [cell.type2Icon setImage:imgForType];
        
        // Append this second type to the label
        NSString *secondType = [self getFormattedType:types[1]];
        [cell.typeLabel setText:[NSString stringWithFormat:@"%@, %@", cell.typeLabel.text, secondType]];
        
        if (types.count > 2 && ![types[2] isEqualToString:@"establishment"])
        {
            
            // Shift the typeLabel to the right even more
            [cell.typeLabel setTransform:CGAffineTransformMakeTranslation(48, 0)];
            CGRect typeFrame = cell.typeLabel.frame;
            [cell.typeLabel setFrame:CGRectMake(typeFrame.origin.x,
                                                typeFrame.origin.y,
                                                typeFrame.size.width-24,
                                                typeFrame.size.height)];
            
            // Show the third type icon
            [cell.type3Icon setHidden:NO];
            UIImage *imgForType = [self imageForType:types[2]];
            if (imgForType) [cell.type3Icon setImage:imgForType];
            
            // Append this third type to the label
            NSString *thirdType = [self getFormattedType:types[2]];
            [cell.typeLabel setText:[NSString stringWithFormat:@"%@, %@", cell.typeLabel.text, thirdType]];
        }
    }
    return cell;
}
// UTILITIES for CELL CREATION //
-(UIImage*)imageForType:(NSString*)type {
    return [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", type]];
}
-(NSString*)getFormattedType:(NSString*)type {
    type = [type stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                         withString:[[type substringToIndex:1] uppercaseString]];
    type = [type stringByReplacingOccurrencesOfString:@"_"
                                           withString:@" "];
    return type;
}
/*
 * Creates distance label for a given place
 * Checks if the source is foursquare and uses the distance provided if so
 * Calls the location manager to create a user friendly distance text
 */
-(NSString*)getDistanceLabelForPlace:(NSDictionary*)place
    {
    int distance = 0;
    if ([place[@"source"] isEqualToString:@"foursquare"]) distance = [place[@"distance"] intValue];
    else {
        CLLocation *placeLoc = [[CLLocation alloc] initWithLatitude:[place[@"latitude"] doubleValue]
                                                          longitude:[place[@"longitude"] doubleValue]];
        
        distance = [[LocationManager sharedManager] distanceBetweenCurrentAnd:placeLoc];
    }
    
    return [[LocationManager sharedManager] userFriendlyDistanceMiles:distance];
}
// END UTILITIES //


#pragma mark - TableView Delegate & Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return placesCells.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [placesCells objectAtIndex:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
