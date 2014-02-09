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

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadAllSettings];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self saveAllSettings];
}

- (IBAction)done:(id)sender
{
    [self.delegate settingsViewControllerDidFinish:self];
    [self saveAllSettings];
}


#pragma mark - Actions

- (IBAction)distanceSliderChanged:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:(int)distanceSlider.value forKey:@"distance"];
    
    [distanceLabel setText:[NSString stringWithFormat:@"%.0f m", distanceSlider.value]];
    
}
- (IBAction)switchChanged:(UISwitch*)sender {
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
    [defaults setBool:!googleSwitch.on      forKey:@"no-google"];
    [defaults setBool:!foursquareSwitch.on  forKey:@"no-fsq"];
    
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
    
    if ([defaults boolForKey:@"no-google"])      [googleSwitch       setOn:![defaults boolForKey:@"no-google"]];
    if ([defaults boolForKey:@"no-foursquare"])  [foursquareSwitch   setOn:![defaults boolForKey:@"no-fsq"]];
}

@end
