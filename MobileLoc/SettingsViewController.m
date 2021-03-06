//
//  FlipsideViewController.m
//  mobileloc
//
//  Created by GEOFFROY LESAGE on 2/7/14.
//  Copyright (c) 2014 GeoffroyLesage. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController


#pragma mark - View Management

// Before appearing, calls to LOAD all settings to the widgets
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadAllSettings];
}

// Before disappearing, calls to SAVE all settings per the state of the widgets
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self saveAllSettings];
}

// When closed by user, calls to SAVE all settings per the state of the widgets
- (IBAction)done:(id)sender
{
    [self.delegate settingsViewControllerDidFinish:self];
    [self saveAllSettings];
}


#pragma mark - Actions

// Called when slider moved, saves value to NSUserDefaults
- (IBAction)distanceSliderChanged:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:(int)distanceSlider.value forKey:@"distance"];
    
    [distanceLabel setText:[NSString stringWithFormat:@"%.0f m", distanceSlider.value]];
    
}
// Called when user changes a setting and calls to SAVE all settings
- (IBAction)selectionMade:(id)sender {
    [self saveAllSettings];
}

/*
 * This will save all settings based on the sate of the widgets
 *
 * Since there are only a few items, we can affort to do this very often
 * So the settings will be saved no matter what
 */
-(void)saveAllSettings
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:(int)distanceSlider.value forKey:@"distance"];
    
    [defaults setBool:openSwitch.on         forKey:@"open"];
    if (providerSC.selectedSegmentIndex == 0)   [defaults setObject:@"google" forKey:@"provider"];
    else                                        [defaults setObject:@"foursquare" forKey:@"provider"];
    
    [defaults synchronize];
}

/*
 * Load all settings and set the widgets
 */
-(void)loadAllSettings
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults boolForKey:@"open"])        [openSwitch setOn:[defaults boolForKey:@"open"]];
    
    if ([defaults objectForKey:@"distance"])    [distanceSlider setValue:[defaults floatForKey:@"distance"]];
    if ([defaults objectForKey:@"distance"])    [distanceLabel setText:[NSString stringWithFormat:@"%d m",
                                                                        (int)[defaults integerForKey:@"distance"]]];
    if ([[defaults objectForKey:@"provider"] isEqualToString:@"google"])
         [providerSC setSelectedSegmentIndex:0];
    else [providerSC setSelectedSegmentIndex:1];
}

@end
