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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *test = [defaults stringForKey:@"defaultContactName"];
    
    NSLog(@"%@", test);
    
    self.defaultCompanyNameBox.text = [defaults stringForKey:@"defaultCompanyName"];
    
    self.defaultContactNameBox.text = [defaults stringForKey:@"defaultContactName"];

    self.defaultAddressBox.text = [defaults stringForKey:@"defaultAddress"];
    
    self.defaultCityBox.text = [defaults stringForKey:@"defaultCity"];
    
    self.defaultStateBox.text = [defaults stringForKey:@"defaultState"];
    
    self.defaultZipBox.text = [defaults stringForKey:@"defaultZip"];
    
    self.defaultPhoneBox.text = [defaults stringForKey:@"defaultPhone"];
    
    self.defaultEmailBox.text = [defaults stringForKey:@"defaultEmail"];

    
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.defaultCompanyName = @"";
    self.key = @"defaultCompanyName";
    [defaults setObject:self.defaultCompanyName forKey:self.key];
    self.defaultCompanyNameBox.text = [defaults stringForKey:@"defaultContactName"];

    
    self.defaultContactName = @"";
    self.key = @"defaultContactName";
    [defaults setObject:self.defaultContactName forKey:self.key];
    self.defaultContactNameBox.text = [defaults stringForKey:@"defaultContactName"];
    
    self.defaultAddress = @"";
    self.key = @"defaultAddress";
    [defaults setObject:self.defaultAddress forKey:self.key];
    self.defaultAddressBox.text = [defaults stringForKey:@"defaultAddress"];
    
    self.defaultCity = @"";
    self.key = @"defaultCity";
    [defaults setObject:self.defaultCity forKey:self.key];
    self.defaultCityBox.text = [defaults stringForKey:@"defaultCity"];
    
    self.defaultState = @"MN";
    self.key = @"defaultState";
    [defaults setObject:self.defaultState forKey:self.key];
    self.defaultStateBox.text = [defaults stringForKey:@"defaultState"];
    
    self.defaultZip = @"";
    self.key = @"defaultZip";
    [defaults setObject:self.defaultZip forKey:self.key];
    self.defaultZipBox.text = [defaults stringForKey:@"defaultZip"];
    
    self.defaultPhone = @"";
    self.key = @"defaultPhone";
    [defaults setObject:self.defaultPhone forKey:self.key];
    self.defaultPhoneBox.text = [defaults stringForKey:@"defaultPhone"];
    
    
    self.defaultEmail = @"";
    self.key = @"defaultEmail";
    [defaults setObject:self.defaultEmail forKey:self.key];
    self.defaultEmailBox.text = [defaults stringForKey:@"defaultemail"];
    
    self.defaultDrate = @"0.77";
    self.key = @"defaultdrate";
    [defaults setObject:self.defaultDrate forKey:self.key];
    self.defaultDrateBox.text =[defaults stringForKey:@"defaultdrate"];
    
    self.defaultNorth = @"6349425";
    self.key = @"defaultnorth";
    [defaults setObject:self.defaultNorth forKey:self.key];
    self.defaultNorthBox.text = [defaults stringForKey:@"defaultnorth"];
    
    self.defaultWest = @"-10874639";
    self.key = @"defaultwest";
    [defaults setObject:self.defaultWest forKey:self.key];
    self.defaultWestBox.text = [defaults stringForKey:@"defaultwest"];
    
    self.defaultSouth = @"5330544";
    self.key = @"defaultsouth";
    [defaults setObject:self.defaultSouth forKey:self.key];
    self.defaultSouthBox.text = [defaults stringForKey:@"defaultsouth"];
    
    self.defaultNorth = @"-9900890";
    self.key = @"defaultnorth";
    [defaults setObject:self.defaultNorth forKey:self.key];
    self.defaultNorthBox.text = [defaults stringForKey:@"defaultnorth"];
    
    
}

- (IBAction)saveDefaults:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"%@", self.defaultCompanyNameBox.text);
    
    self.defaultCompanyName = self.defaultCompanyNameBox.text;
    self.key = @"defaultCompanyName";
    [defaults setObject:self.defaultCompanyName forKey:self.key];
    
    self.defaultContactName = @"";
    self.key = @"defaultContactName";
    [defaults setObject:self.defaultContactName forKey:self.key];
    
    self.defaultAddress = @"";
    self.key = @"defaultAddress";
    [defaults setObject:self.defaultAddress forKey:self.key];
    
    self.defaultCity = @"";
    self.key = @"defaultCity";
    [defaults setObject:self.defaultCity forKey:self.key];

    self.defaultState = @"MN";
    self.key = @"defaultState";
    [defaults setObject:self.defaultState forKey:self.key];
    
    self.defaultZip = @"";
    self.key = @"defaultZip";
    [defaults setObject:self.defaultZip forKey:self.key];
    
    self.defaultPhone = @"";
    self.key = @"defaultPhone";
    [defaults setObject:self.defaultPhone forKey:self.key];
    
    self.defaultEmail = @"";
    self.key = @"defaultEmail";
    [defaults setObject:self.defaultEmail forKey:self.key];
    
    self.defaultDrate = @"0.77";
    self.key = @"defaultdrate";
    [defaults setObject:self.defaultDrate forKey:self.key];
    
    self.defaultNorth = @"6349425";
    self.key = @"defaultnorth";
    [defaults setObject:self.defaultNorth forKey:self.key];
    
    self.defaultWest = @"-10874639";
    self.key = @"defaultwest";
    [defaults setObject:self.defaultWest forKey:self.key];
    
    self.defaultSouth = @"5330544";
    self.key = @"defaultsouth";
    [defaults setObject:self.defaultSouth forKey:self.key];
    
    self.defaultNorth = @"-9900890";
    self.key = @"defaultnorth";
    [defaults setObject:self.defaultNorth forKey:self.key];
}
@end
