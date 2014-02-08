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

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"open"])        [openSwitch setOn:[defaults boolForKey:@"open"]];
    
    if ([defaults objectForKey:@"distance"])    [distanceSlider setValue:[defaults floatForKey:@"distance"]];
    if ([defaults objectForKey:@"distance"])    [distanceLabel setText:[NSString stringWithFormat:@"%d m",
                                                                        [defaults integerForKey:@"distance"]]];
    
    if ([defaults objectForKey:@"no-google"])      [googleSwitch       setOn:![defaults boolForKey:@"no-google"]];
    if ([defaults objectForKey:@"no-foursquare"])  [foursquareSwitch   setOn:![defaults boolForKey:@"no-fsq"]];
}


#pragma mark - Actions

- (IBAction)distanceSliderChanged:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:(int)distanceSlider.value forKey:@"distance"];
    
    [distanceLabel setText:[NSString stringWithFormat:@"%.0f m", distanceSlider.value]];
    
}
- (IBAction)switchChanged:(UISwitch*)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (sender == openSwitch) {
        if (sender.on)  [defaults setBool:YES forKey:@"open"];
        else            [defaults setBool:NO forKey:@"open"];
        return;
    }
    if (sender == googleSwitch){
        if (sender.on)  [defaults setBool:NO forKey:@"no-google"];
        else            [defaults setBool:YES forKey:@"no-google"];
        return;
    }
    if (sender == foursquareSwitch){
        if (sender.on)  [defaults setBool:NO forKey:@"no-fsq"];
        else            [defaults setBool:YES forKey:@"no-fsq"];
    }
}
- (IBAction)done:(id)sender
{
    [self.delegate settingsViewControllerDidFinish:self];
}

@end
