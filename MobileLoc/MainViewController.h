//
//  MainViewController.h
//  mobileloc
//
//  Created by GEOFFROY LESAGE on 2/7/14.
//  Copyright (c) 2014 GeoffroyLesage. All rights reserved.
//

#import "SettingsViewController.h"
#import "MapViewController.h"

#import <CoreData/CoreData.h>

@interface MainViewController : UIViewController <SettingsViewControllerDelegate, MapViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet __weak UITableView *placeTable;
    IBOutlet UIToolbar *toolbar;
    NSMutableArray *places;
}

@property (weak, nonatomic) IBOutlet UITableView *placeTable;

@end
