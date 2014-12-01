//
//  settingsViewController.h
//  MN Solar App
//
//  Created by Chris Martin on 11/30/14.
//  Copyright (c) 2014 MN Solar Suitability Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface settingsViewController : UIViewController

@property (strong, nonatomic) NSUserDefaults *defaults;
@property (strong, nonatomic) NSString *defaultEmail;
@property (strong, nonatomic) IBOutlet UITextField *defaultEmailBox;
@property (strong, nonatomic) NSString *defaultDrate;
@property (strong, nonatomic) IBOutlet UITextField *defaultDrateBox;
@property (strong, nonatomic) NSString *defaultNorth;
@property (strong, nonatomic) IBOutlet UITextField *defaultNorthBox;
@property (strong, nonatomic) NSString *defaultWest;
@property (strong, nonatomic) IBOutlet UITextField *defaultWestBox;
@property (strong, nonatomic) NSString *defaultSouth;
@property (strong, nonatomic) IBOutlet UITextField *defaultSouthBox;
@property (strong, nonatomic) NSString *defaultEast;
@property (strong, nonatomic) IBOutlet UITextField *defaultEastBox;
@property (strong, nonatomic) NSString *key;
- (IBAction)resetDefaults:(id)sender;

@end
