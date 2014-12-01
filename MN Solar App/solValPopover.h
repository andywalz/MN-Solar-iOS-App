//
//  solValPopover.h
//  MN Solar App
//
//  Created by Chris Martin on 11/30/14.
//  Copyright (c) 2014 MN Solar Suitability Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MapViewController;


@interface solValPopover : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *optLabel;
@property (strong, nonatomic) IBOutlet UILabel *optDesc;
@property (strong, nonatomic) IBOutlet UILabel *goodLabel;
@property (strong, nonatomic) IBOutlet UILabel *goodDesc;
@property (strong, nonatomic) IBOutlet UILabel *poorLabel;
@property (strong, nonatomic) IBOutlet UILabel *poorDesc;


@property (strong, nonatomic) NSString *solPotentialPopover;

@property (strong,nonatomic) UIColor *solarOrange;


@end
