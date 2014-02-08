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
@synthesize imageLoad;


-(void)observeImageUpdates {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotNewImage:) name:GOT_NEW_IMAGE object:nil];
}

-(void)gotNewImage:(NSNotification*)notification {
    if (![notification.userInfo objectForKey:@"image"]) return;
    if (![notification.userInfo objectForKey:@"placeName"]) return;
    
    UIImage *placeImage = notification.userInfo[@"image"];
    NSString *placeName = notification.userInfo[@"placeName"];
    
    if (![nameLabel.text isEqualToString:placeName]) return;
    
    icon.layer.cornerRadius = 10.0;
    icon.clipsToBounds = YES;
    
    [icon setImage:placeImage];
    [imageLoad stopAnimating];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
