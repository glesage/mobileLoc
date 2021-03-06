//
//  PlaceCell.h
//  mobileloc
//
//  Created by GEOFFROY LESAGE on 2/8/14.
//  Copyright (c) 2014 GeoffroyLesage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIImageView *typeIcon;
@property (weak, nonatomic) IBOutlet UIImageView *type2Icon;
@property (weak, nonatomic) IBOutlet UIImageView *type3Icon;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *openLabel;

-(void)observeImageUpdates;
-(void)setMainIcon:(UIImage*)image;
-(void)setOpen:(BOOL)open;

@end
