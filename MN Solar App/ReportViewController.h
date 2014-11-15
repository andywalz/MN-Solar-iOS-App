//
//  ReportViewController.h
//  MN Solar App
//
//  Created by Andy Walz on 11/2/14.
//  Copyright (c) 2014 MN Solar Suitability Team. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <ArcGIS/ArcGIS.h>

@interface ReportViewController : UIViewController <AGSMapViewTouchDelegate>
@property (strong, nonatomic) IBOutlet AGSMapView *minimapView;

@property (weak, nonatomic) IBOutlet UIView *minMapView;
@property (nonatomic, strong) AGSPoint *thePin;
@property (weak, nonatomic) IBOutlet UIWebView *reportWeb;

@end
