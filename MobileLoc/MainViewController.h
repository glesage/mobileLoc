//
//  MainViewController.h
//  mobileloc
//
//  Created by GEOFFROY LESAGE on 2/7/14.
//  Copyright (c) 2014 GeoffroyLesage. All rights reserved.
//

#import "SettingsViewController.h"

#import <CoreData/CoreData.h>

@interface MainViewController : UIViewController <SettingsViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet __weak UITableView *placeTable;
    NSMutableArray *places;
}

@property (weak, nonatomic) IBOutlet UITableView *placeTable;

@end
