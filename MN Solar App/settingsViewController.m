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

//NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", [self.defaults stringForKey:@"defaultemail"]);
    
    self.defaults = [NSUserDefaults standardUserDefaults];
    
    /*self.defaultEmail = @"test@test.com";
    self.key = @"defaultemail";
    
    [self.defaults setObject:self.defaultEmail forKey:self.key];
    
    NSLog(@"%@", [self.defaults stringForKey:@"defaultemail"]);*/
    
    self.defaultCompanyName = @"TruNorth Solar";
    self.key = @"defaultCompanyName";
    [self.defaults setObject:self.defaultCompanyName forKey:self.key];
    self.defaultCompanyNameBox.text = [self.defaults stringForKey:@"defaultCompanyName"];
    
    self.defaultContactName = @"Marty Morud";
    self.key = @"defaultContactName";
    [self.defaults setObject:self.defaultContactName forKey:self.key];
    self.defaultContactNameBox.text = [self.defaults stringForKey:@"defaultContactName"];
    
    self.defaultAddress = @"5301 Edina Industrial Blvd #2";
    self.key = @"defaultAddress";
    [self.defaults setObject:self.defaultAddress forKey:self.key];
    self.defaultAddressBox.text = [self.defaults stringForKey:@"defaultAddress"];
    
    self.defaultCity = @"Minneapolis";
    self.key = @"defaultCity";
    [self.defaults setObject:self.defaultCity forKey:self.key];
    self.defaultCityBox.text = [self.defaults stringForKey:@"defaultCity"];
    
    self.defaultState = @"MN";
    self.key = @"defaultState";
    [self.defaults setObject:self.defaultState forKey:self.key];
    self.defaultStateBox.text = [self.defaults stringForKey:@"defaultState"];
    
    self.defaultZip = @"55439";
    self.key = @"defaultZip";
    [self.defaults setObject:self.defaultZip forKey:self.key];
    self.defaultZipBox.text = [self.defaults stringForKey:@"defaultZip"];
    
    self.defaultPhone = @"612-888-9599";
    self.key = @"defaultPhone";
    [self.defaults setObject:self.defaultPhone forKey:self.key];
    self.defaultPhoneBox.text = [self.defaults stringForKey:@"defaultPhone"];
    
    
    self.defaultEmail = @"MMorud@TruNorthSolar.com";
    self.key = @"defaultemail";
    [self.defaults setObject:self.defaultEmail forKey:self.key];
    self.defaultEmailBox.text = [self.defaults stringForKey:@"defaultemail"];
    
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
    
    self.defaultCompanyName = @"";
    self.key = @"defaultCompanyName";
    [self.defaults setObject:self.defaultCompanyName forKey:self.key];
    self.defaultCompanyNameBox.text = [self.defaults stringForKey:@"defaultCompanyName"];
    
    self.defaultContactName = @"";
    self.key = @"defaultContactName";
    [self.defaults setObject:self.defaultContactName forKey:self.key];
    self.defaultContactNameBox.text = [self.defaults stringForKey:@"defaultContactName"];
    
    self.defaultAddress = @"";
    self.key = @"defaultAddress";
    [self.defaults setObject:self.defaultAddress forKey:self.key];
    self.defaultAddressBox.text = [self.defaults stringForKey:@"defaultAddress"];
    
    self.defaultCity = @"";
    self.key = @"defaultCity";
    [self.defaults setObject:self.defaultCity forKey:self.key];
    self.defaultCityBox.text = [self.defaults stringForKey:@"defaultCity"];
    
    self.defaultState = @"MN";
    self.key = @"defaultState";
    [self.defaults setObject:self.defaultState forKey:self.key];
    self.defaultStateBox.text = [self.defaults stringForKey:@"defaultState"];
    
    self.defaultZip = @"";
    self.key = @"defaultZip";
    [self.defaults setObject:self.defaultZip forKey:self.key];
    self.defaultZipBox.text = [self.defaults stringForKey:@"defaultZip"];
    
    self.defaultPhone = @"";
    self.key = @"defaultPhone";
    [self.defaults setObject:self.defaultPhone forKey:self.key];
    self.defaultPhoneBox.text = [self.defaults stringForKey:@"defaultPhone"];
    
    
    self.defaultEmail = @"";
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

- (IBAction)saveDefaults:(id)sender {
    self.defaultCompanyName = self.defaultCompanyNameBox;
    self.key = @"defaultCompanyName";
    [self.defaults setObject:self.defaultCompanyName forKey:self.key];
    self.defaultCompanyNameBox.text = [self.defaults stringForKey:@"defaultCompanyName"];
    [self.defaults synchronize];
    
    /*self.defaultContactName = @"";
    self.key = @"defaultContactName";
    [self.defaults setObject:self.defaultContactName forKey:self.key];
    self.defaultContactNameBox.text = [self.defaults stringForKey:@"defaultContactName"];
    
    self.defaultAddress = @"";
    self.key = @"defaultAddress";
    [self.defaults setObject:self.defaultAddress forKey:self.key];
    self.defaultAddressBox.text = [self.defaults stringForKey:@"defaultAddress"];
    
    self.defaultCity = @"";
    self.key = @"defaultCity";
    [self.defaults setObject:self.defaultCity forKey:self.key];
    self.defaultCityBox.text = [self.defaults stringForKey:@"defaultCity"];
    
    self.defaultState = @"MN";
    self.key = @"defaultState";
    [self.defaults setObject:self.defaultState forKey:self.key];
    self.defaultStateBox.text = [self.defaults stringForKey:@"defaultState"];
    
    self.defaultZip = @"";
    self.key = @"defaultZip";
    [self.defaults setObject:self.defaultZip forKey:self.key];
    self.defaultZipBox.text = [self.defaults stringForKey:@"defaultZip"];
    
    self.defaultPhone = @"";
    self.key = @"defaultPhone";
    [self.defaults setObject:self.defaultPhone forKey:self.key];
    self.defaultPhoneBox.text = [self.defaults stringForKey:@"defaultPhone"];
    
    
    self.defaultEmail = @"";
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
    
    self.defaultNorthBox.text = [self.defaults stringForKey:@"defaultnorth"];*/
}
@end
