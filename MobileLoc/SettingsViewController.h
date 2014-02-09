//
//  FlipsideViewController.h
//  mobileloc
//
//  Created by GEOFFROY LESAGE on 2/7/14.
//  Copyright (c) 2014 GeoffroyLesage. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SettingsViewController;

@protocol SettingsViewControllerDelegate
- (void)settingsViewControllerDidFinish:(SettingsViewController *)controller;
@end


@interface SettingsViewController : UIViewController {
    IBOutlet UISlider *distanceSlider;
    IBOutlet UILabel *distanceLabel;
    
    IBOutlet UISwitch *openSwitch;
    IBOutlet UISegmentedControl *providerSC;
}

@property (weak, nonatomic) id <SettingsViewControllerDelegate> delegate;

- (IBAction)distanceSliderChanged:(id)sender;
- (IBAction)providerChanged:(id)sender;
- (IBAction)done:(id)sender;

@end
