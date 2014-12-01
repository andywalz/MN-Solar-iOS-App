//
//  settingsViewController.m
//  MN Solar App
//
//  Created by Chris Martin on 11/30/14.
//  Copyright (c) 2014 MN Solar Suitability Team. All rights reserved.
//

#import "settingsViewController.h"

@interface settingsViewController ()

@end

@implementation settingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", [self.defaults stringForKey:@"defaultemail"]);
    
    self.defaults = [NSUserDefaults standardUserDefaults];
    
    self.defaultEmail = @"test@test.com";
    self.key = @"defaultemail";
    
    [self.defaults setObject:self.defaultEmail forKey:self.key];
    
    NSLog(@"%@", [self.defaults stringForKey:@"defaultemail"]);
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)resetDefaults:(id)sender {
    
    NSLog(@"Pressed restore defaults!");
    self.defaultEmail = @"installer@solar.com";
    self.key = @"defaultemail";
    
    [self.defaults setObject:self.defaultEmail forKey:self.key];
    
    self.defaultEmailBox.text = [self.defaults stringForKey:@"defaultemail"];
    
    
    self.defaultDrate = @"0.77";
    self.key = @"defaultdrate";
    [self.defaults setObject:self.defaultDrate forKey:self.key];
    
    self.defaultDrateBox.text = [self.defaults stringForKey:@"defaultdrate"];
    
    self.defaultNorth = @"6349425";
    self.key = @"defaultnorth";
    [self.defaults setObject:self.defaultNorth forKey:self.key];
    
    self.defaultNorthBox.text = [self.defaults stringForKey:@"defaultnorth"];
    
    self.defaultWest = @"-10874639";
    self.key = @"defaultwest";
    [self.defaults setObject:self.defaultWest forKey:self.key];
    
    self.defaultWestBox.text = [self.defaults stringForKey:@"defaultwest"];
    
    self.defaultSouth = @"5330544";
    self.key = @"defaultsouth";
    [self.defaults setObject:self.defaultSouth forKey:self.key];
    
    self.defaultSouthBox.text = [self.defaults stringForKey:@"defaultsouth"];
    
    self.defaultNorth = @"-9900890";
    self.key = @"defaultnorth";
    [self.defaults setObject:self.defaultNorth forKey:self.key];
    
    self.defaultNorthBox.text = [self.defaults stringForKey:@"defaultnorth"];
    
    
}
@end
