//
//  ReportViewController.h
//  MN Solar App
//
//  Created by Andy Walz on 11/2/14.
//  Copyright (c) 2014 MN Solar Suitability Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>

@class MapViewController;

@interface ReportViewController : UIViewController
@property (strong, nonatomic) MapViewController *mainMapView;

@property (strong, nonatomic) IBOutlet AGSMapView *solarLocMap;
@property (strong, nonatomic) IBOutlet AGSMapView *satLocMap;
@property (strong, nonatomic) IBOutlet UIWebView *monthInsWV;
@property (strong, nonatomic) IBOutlet UIWebView *monthSunHrsWV;

//Labels
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *savedData;
@property (weak, nonatomic) IBOutlet UILabel *insolTotal;
@property (weak, nonatomic) IBOutlet UILabel *insolDaily;
@property (weak, nonatomic) IBOutlet UILabel *solPotential;
@property (weak, nonatomic) IBOutlet UILabel *sunHrTotal;
@property (weak, nonatomic) IBOutlet UILabel *sunHrDaily;
@property (weak, nonatomic) IBOutlet UILabel *EUSA;


@end
