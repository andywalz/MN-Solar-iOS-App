//
//  ReportViewController.h
//  MN Solar App
//
//  Created by Andy Walz on 11/2/14.
//  Copyright (c) 2014 MN Solar Suitability Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>
#import <MessageUI/MessageUI.h>
#import "QuartzCore/QuartzCore.h"

@class MapViewController;
@class settingsViewController;
@class ReportSaveFormViewController;

@interface ReportViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) MapViewController *mainMapView;
@property (weak, nonatomic) IBOutlet UIView *mainReportView;

@property (strong, nonatomic) IBOutlet AGSMapView *solarLocMap;
@property (weak, nonatomic) IBOutlet UIWebView *locWebMap;

@property (nonatomic, strong) AGSGraphicsLayer *graphicsLayer;
@property (nonatomic, strong) AGSPoint *thePin;

@property (weak, nonatomic) IBOutlet UIToolbar *reportToolbar;

@property (strong, nonatomic) IBOutlet UIWebView *monthInsWV;
@property (strong, nonatomic) IBOutlet UIWebView *monthSunHrsWV;

//Labels
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *savedData;
@property (weak, nonatomic) IBOutlet UILabel *insolTotal;
@property (weak, nonatomic) IBOutlet UILabel *insolDaily;
@property (weak, nonatomic) IBOutlet UILabel *insolTotal2;
@property (weak, nonatomic) IBOutlet UILabel *sunHrTotal2;

@property (weak, nonatomic) IBOutlet UILabel *solPotential;
@property (weak, nonatomic) IBOutlet UILabel *sunHrTotal;
@property (weak, nonatomic) IBOutlet UILabel *sunHrDaily;
@property (weak, nonatomic) IBOutlet UILabel *EUSA;

@property (weak, nonatomic) IBOutlet UILabel *janVal;
@property (weak, nonatomic) IBOutlet UILabel *febVal;
@property (weak, nonatomic) IBOutlet UILabel *marVal;
@property (weak, nonatomic) IBOutlet UILabel *aprVal;
@property (weak, nonatomic) IBOutlet UILabel *mayVal;
@property (weak, nonatomic) IBOutlet UILabel *junVal;
@property (weak, nonatomic) IBOutlet UILabel *julVal;
@property (weak, nonatomic) IBOutlet UILabel *augVal;
@property (weak, nonatomic) IBOutlet UILabel *sepVal;
@property (weak, nonatomic) IBOutlet UILabel *octVal;
@property (weak, nonatomic) IBOutlet UILabel *novVal;
@property (weak, nonatomic) IBOutlet UILabel *decVal;

@property (weak, nonatomic) IBOutlet UILabel *janHr;
@property (weak, nonatomic) IBOutlet UILabel *febHr;
@property (weak, nonatomic) IBOutlet UILabel *marHr;
@property (weak, nonatomic) IBOutlet UILabel *aprHr;
@property (weak, nonatomic) IBOutlet UILabel *mayHr;
@property (weak, nonatomic) IBOutlet UILabel *junHr;
@property (weak, nonatomic) IBOutlet UILabel *julHr;
@property (weak, nonatomic) IBOutlet UILabel *augHr;
@property (weak, nonatomic) IBOutlet UILabel *sepHr;
@property (weak, nonatomic) IBOutlet UILabel *novHr;
@property (weak, nonatomic) IBOutlet UILabel *decHr;
@property (weak, nonatomic) IBOutlet UILabel *octHr;

@property (weak, nonatomic) NSString *customName;
@property (weak, nonatomic) NSString *customNotes;
@property (weak, nonatomic) NSString *customDate;
@property (weak, nonatomic) NSString *customAddress;

@property (weak, nonatomic) IBOutlet UILabel *reportNotes;

@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet UILabel *installerContact;
@property (weak, nonatomic) IBOutlet UILabel *installerAddress;
@property (weak, nonatomic) IBOutlet UILabel *installerCityStateZip;
@property (weak, nonatomic) IBOutlet UILabel *installerPhoneEmail;
@property (weak, nonatomic) IBOutlet UILabel *installerEmail;




- (IBAction)installers:(id)sender;
- (IBAction)rebates:(id)sender;
- (IBAction)solPotButton:(id)sender;
- (IBAction)mailReport:(id)sender;



@end
