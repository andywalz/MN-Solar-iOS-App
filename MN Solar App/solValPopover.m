//
//  solValPopover.m
//  MN Solar App
//
//  Created by Chris Martin on 11/30/14.
//  Copyright (c) 2014 MN Solar Suitability Team. All rights reserved.
//

#import "solValPopover.h"
#import "MapViewController.h"

@interface solValPopover ()

@end

@implementation solValPopover

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@", self.solPotentialPopover);
    // Do any additional setup after loading the view.
    self.solarOrange = [UIColor colorWithRed:(242.0/255.0) green:(199.0/255.0) blue:(46.0/255.0) alpha:1.0f];
    
    if ([self.solPotentialPopover isEqualToString:@"[ Optimal ]"]){
        NSLog(@"Optimal");
        self.optLabel.textColor = self.solarOrange;
        self.optDesc.textColor = self.solarOrange;
    }
    
    else if ([self.solPotentialPopover isEqualToString:@"[ Good ]"]){
        NSLog(@"Good");
        self.goodLabel.textColor = self.solarOrange;
        self.goodDesc.textColor = self.solarOrange;
        
    }
    
    else {
        NSLog(@"Poor");
        self.poorLabel.textColor = self.solarOrange;
        self.poorDesc.textColor = self.solarOrange;
    }
    
    
    
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

@end
