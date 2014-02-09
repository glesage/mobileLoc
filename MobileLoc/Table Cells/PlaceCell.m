//
//  PlaceCell.m
//  mobileloc
//
//  Created by ANDREW KUCHARSKI on 2/8/14.
//  Copyright (c) 2014 GeoffroyLesage. All rights reserved.
//

#import "PlaceCell.h"
#import "DataManager.h"

#import <QuartzCore/QuartzCore.h>

@implementation PlaceCell

@synthesize nameLabel;
@synthesize icon;


-(void)observeImageUpdates {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotNewImage:) name:GOT_NEW_IMAGE object:nil];
}

-(void)setOpen:(BOOL)open {
    if (open) {
        [self.openLabel setText:@"OPEN"];
        [self.openLabel setTextColor:[UIColor colorWithRed:0.373 green:0.698 blue:0.255 alpha:0.9]];
    }
    else {
        [self.openLabel setText:@"CLOSED"];
        [self.openLabel setTextColor:[UIColor lightGrayColor]];
    }

}

-(void)setMainIcon:(UIImage*)image {
    icon.layer.cornerRadius = 10.0;
    icon.clipsToBounds = YES;
    
    [icon setImage:image];
}
-(void)gotNewImage:(NSNotification*)notification
{    
    if (![notification.userInfo objectForKey:@"image"]) return;
    if (![notification.userInfo objectForKey:@"placeName"]) return;
    
    UIImage *placeImage = notification.userInfo[@"image"];
    NSString *placeName = notification.userInfo[@"placeName"];
    
    if (![nameLabel.text isEqualToString:placeName]) return;
    
    [self setMainIcon:placeImage];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
