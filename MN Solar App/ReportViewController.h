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

@property (nonatomic, strong) AGSGraphicsLayer *graphicsLayer;
@property (nonatomic, strong) AGSPoint *thePin;
@property (weak, nonatomic) IBOutlet UIWebView *reportWeb;
@property (strong, nonatomic) IBOutlet AGSMapView *minSolarMap;

@end
