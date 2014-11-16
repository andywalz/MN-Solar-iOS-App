//
//  MenuViewController.h
//  MN Solar App
//
//  Created by Andy Walz on 11/2/14.
//  Copyright (c) 2014 MN Solar Suitability Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong,nonatomic) UIImage *image;

@property(strong,nonatomic) UIImagePickerController *picker;
- (IBAction)takePhoto:(id)sender;
- (IBAction)selectPhoto:(UIButton *)sender;



@end
