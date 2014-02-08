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

@interface MainViewController ()

@end


@implementation MainViewController

@synthesize placeTable;


-(void)alertWithTitle:(NSString*)title andMessage:(NSString*)message {
    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:title
                                                     message:message
                                                    delegate:self
                                           cancelButtonTitle:@"Ok"
                                           otherButtonTitles:nil];
    [alertV show];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    places = [[NSMutableArray alloc] init];
    
    //Initialize the manager singletons: location polling & data files
    [LocationManager sharedManager];
	[DataManager sharedManager];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [toolbar setFrame:CGRectMake(160, 0, 320, 66)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotNewPlaces) name:GOT_NEW_PLACES object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unableToFetchPlaces:) name:UNABLE_TO_FETCH_PLACES object:nil];
}


#pragma mark - Data Handlers

-(void)gotNewPlaces {
    [places addObjectsFromArray:[[DataManager sharedManager] getAllPlaces]];
    [placeTable reloadData];
}

-(void)unableToFetchPlaces:(NSNotification*)notification {
    
    if ([notification.userInfo objectForKey:@"message"]) {
        [self alertWithTitle:@"Unable to fetch places"
                  andMessage:[notification.userInfo objectForKey:@"message"]];
    }
    else [self alertWithTitle:@"Unable to fetch places" andMessage:nil];
    
    if ([notification.userInfo objectForKey:@"error"]) {
        NSString *error = [notification.userInfo objectForKey:@"error"];
        NSLog(@"Failed to fetch places: %@", error);
    }
}


#pragma mark - Settings View

- (void)settingsViewControllerDidFinish:(SettingsViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showSettings"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}


#pragma mark - TableView Delegate & Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return places.count;
}

/*
 * Creates the cells to display
 *
 * Also handles the types label formatting and icons showing
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"placeTableCell";
    
    PlaceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"placeTableCell"];
    if (!cell) {
        cell = [[PlaceCell alloc] initWithStyle:UITableViewCellStyleDefault
                                reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *placeData = [places objectAtIndex:indexPath.row];
    [cell.nameLabel setText:placeData[@"name"]];
    
    if (placeData[@"open"]) {
        [cell.openLabel setText:@"OPEN"];
        [cell.openLabel setTextColor:[UIColor colorWithRed:0.373 green:0.698 blue:0.255 alpha:0.9]];
    }
    
    // Types business
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
    
    [cell.distanceLabel setText:@"Quite close!"];
    
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
// END UTILITIES //

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
