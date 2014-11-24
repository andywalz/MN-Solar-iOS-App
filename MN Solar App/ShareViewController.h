//
//  ShareViewController.h
//  MN Solar App
//
//  Created by Andy Walz on 11/23/14.
//  Copyright (c) 2014 MN Solar Suitability Team. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface ShareViewController : UIViewController <MFMailComposeViewControllerDelegate> // Add the delegate

- (IBAction)mailReport:(id)sender;

@end