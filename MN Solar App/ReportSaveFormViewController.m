//
//  ReportSaveFormViewController.m
//  MN Solar App
//
//  Created by Andy Walz on 11/2/14.
//  Copyright (c) 2014 MN Solar Suitability Team. All rights reserved.
//

#import "ReportSaveFormViewController.h"

@interface ReportSaveFormViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)backToReport:(id)sender;
- (IBAction)takePhoto:(id)sender;

@end

@implementation ReportSaveFormViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSDateFormatter *formatter;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"M/d/yyyy"];
    
    self.myDate.text = [formatter stringFromDate:[NSDate date]];
    self.myNotes.text = self.myReport.customNotes;
    self.myLocation.text = self.myReport.savedData.text;
    
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

- (IBAction)backToReport:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)takePhoto:(id)sender {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                              message:@"Device has no camera, do not click + add photo"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    }

    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}
- (IBAction)saveForm:(id)sender {
    //show alert if we didn't get results
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                    message:@"Your report has been saved to bookmarks."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [alert show];
    
    self.myReport.customNotes = self.myNotes.text;
    self.myReport.customName = self.myName.text;
    self.myReport.customDate = self.myDate.text;
    self.myReport.customAddress = self.myLocation.text;
    
    
    self.myReport.savedData.text = [NSString stringWithFormat:@"%@ %@", self.myName.text, self.myLocation.text];
    self.myReport.reportNotes.text = [NSString stringWithFormat:@"NOTES: %@", self.myNotes.text];
    self.myReport.location.text = [NSString stringWithFormat:@"%@  Date: %@", self.myDate.text];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
