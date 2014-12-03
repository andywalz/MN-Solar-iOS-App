//
//  ReportSaveFormViewController.h
//  MN Solar App
//
//  Created by Andy Walz on 11/2/14.
//  Copyright (c) 2014 MN Solar Suitability Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportViewController.h"

@interface ReportSaveFormViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) ReportViewController *myReport;

- (IBAction)saveForm:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *myDate;
@property (weak, nonatomic) IBOutlet UITextField *myName;
@property (weak, nonatomic) IBOutlet UITextField *myLocation;
@property (weak, nonatomic) IBOutlet UITextView *myNotes;

@end
