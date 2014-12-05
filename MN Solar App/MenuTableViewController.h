//
//  MenuTableViewController.h
//  MN Solar App
//
//  Created by Andy Walz on 11/2/14.
//  Copyright (c) 2014 MN Solar Suitability Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"

@interface MenuTableViewController : UITableViewController

@property (weak,nonatomic) MapViewController *mainMapVC;

@property (weak, nonatomic) IBOutlet UILabel *layerCounties;
@property (weak, nonatomic) IBOutlet UILabel *layerEUSA;
@property (weak, nonatomic) IBOutlet UILabel *layerSolarInstalls;
@property (weak, nonatomic) IBOutlet UILabel *layerTiles;

- (IBAction)toggleCounties:(id)sender;
- (IBAction)toggleEUSA:(id)sender;
- (IBAction)toggleSolarInstalls:(id)sender;
- (IBAction)toggleTiles:(id)sender;

@end
