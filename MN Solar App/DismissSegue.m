//
//  DismissSegue.m
//  MN Solar App
//
//  Created by Andy Walz and Chris Martin on 11/21/14.
//  Copyright (c) 2014 MN Solar Suitability Team. All rights reserved.
//


#import "DismissSegue.h"

@implementation DismissSegue

- (void)perform {
    UIViewController *sourceViewController = self.sourceViewController;
    [sourceViewController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
}
@end
