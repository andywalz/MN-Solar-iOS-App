//
//  resultsDrawer.m
//  MN Solar App
//
//  Created by Chris Martin on 11/21/14.
//  Copyright (c) 2014 MN Solar Suitability Team. All rights reserved.
//

#import "resultsDrawer.h"

@interface resultsDrawer ()

@end

@implementation resultsDrawer

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)dismissResultsDrawer:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
