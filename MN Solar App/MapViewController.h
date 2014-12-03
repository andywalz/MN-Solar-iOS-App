//
//  ViewController.h
//  MN Solar App
//
//  Created by Andy Walz and Chris Martin on 11/1/14.
//  Copyright (c) 2014 MN Solar Suitability Team. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <ArcGIS/ArcGIS.h>
#import "GCGeocodingService.h"
#import "Reachability.h"

#import "BookmarksTableViewController.h"
#import "ReportViewController.h"
#import "solValPopover.h"
#import "settingsViewController.h"
#import "MenuTableViewController.h"

@interface MapViewController : UIViewController <AGSMapViewTouchDelegate, UITextFieldDelegate, UIPopoverControllerDelegate>

//Map related properties
@property (strong, nonatomic) IBOutlet AGSMapView *mapView;
@property AGSEnvelope *defaultEnvelope;
@property (nonatomic, strong) AGSGraphicsLayer *graphicsLayer;
@property (nonatomic, strong) AGSGraphicsLayer *myGraphicsLayer;
@property (nonatomic, weak) AGSGraphic *pushpin;
@property (nonatomic, weak) AGSImageServiceLayer *solarLayer;

@property (nonatomic, weak) IBOutlet UISwitch *solarSwitch;
@property (nonatomic, weak) IBOutlet UILabel *solarOn;
@property (nonatomic, weak) IBOutlet UILabel *solarOff;
@property (nonatomic, weak) IBOutlet UIView *loadingIconView;
@property (nonatomic, weak) IBOutlet UILabel *statusMsgLabel;

@property (nonatomic,weak) UIImage *pushpinImg;
@property (nonatomic, strong) UIView* loadingView;
@property (nonatomic, weak) IBOutlet UIView *resultsDrawer;
@property (nonatomic, weak) IBOutlet UITextField *searchBar;
@property (nonatomic, weak) IBOutlet UILabel *solPotential;
@property (nonatomic, weak) IBOutlet UIButton *solarToggle;

@property (nonatomic, weak) NSString *layerCountiesStatus;


// Class and method properties
@property (nonatomic, weak) Reachability *internetReachableFoo;   // Internet connection check

@property (nonatomic, weak) NSString *geocodeAddress;
@property AGSEnvelope *zoomToEnvelop;

@property (nonatomic, strong) NSString* dsmTile;
@property (nonatomic, strong) AGSQueryTask* dsmqueryTask;
@property (nonatomic, strong) AGSQuery* dsmquery;
@property (nonatomic, weak) NSString* dsmname;

@property (nonatomic, strong) AGSPoint* pin;
@property (nonatomic, strong) AGSPoint *utm15Point;
@property (nonatomic, strong) AGSPoint *wgsPoint;
@property (nonatomic, strong) AGSPoint *geocodePoint;
@property (nonatomic, strong) AGSPoint *geocodePointWeb;

@property (nonatomic, strong) AGSLocator *locator;
@property (nonatomic, strong) AGSCalloutTemplate *calloutTemplate;
@property (nonatomic, strong) AGSJSONRequestOperation* currentJsonOp;
@property (nonatomic, strong) NSOperationQueue *queue;

@property (nonatomic, strong) AGSQueryTask* queryTask;
@property (nonatomic, strong) AGSQuery* query;
@property (nonatomic, strong) AGSGraphic *myFeature;
@property (nonatomic, strong) NSString* eusaFULL_NAME;
@property (nonatomic, strong) NSString* eusaSTREET;
@property (nonatomic, strong) NSString* eusaCITY;
@property (nonatomic, strong) NSString* eusaZIP;
@property (nonatomic, strong) NSString* eusaPHONE;
@property (nonatomic, strong) NSString* eusaWEBSITE;
@property (nonatomic, strong) NSString* eusaELEC_COMP;

@property (nonatomic, strong) AGSGeoprocessor *geoprocessor;
@property (nonatomic, weak) NSString * solarValue;
@property (nonatomic, weak) NSString * solarHours;
@property (nonatomic, weak) NSMutableArray * solarValueArray;
@property (nonatomic, strong) NSMutableArray * solarValueArrayNum;
@property (nonatomic, strong) NSMutableArray * solarValueArrayNumkwh;
@property (nonatomic, weak) NSMutableArray * solarHoursArray;
@property (nonatomic, strong) NSMutableArray * solarHoursArrayNum;
@property (nonatomic, strong) NSMutableArray * solarHoursArrayNumFloat;
@property (nonatomic, strong) NSString *myAddress;

// Results Drawer elements
@property (nonatomic, strong) NSNumber *maxInsVal;
@property (nonatomic, strong) NSNumber *maxHrsVal;
@property (nonatomic, strong) NSNumber *totalInsVal;
@property (nonatomic, strong) NSNumber *totalHrsVal;

@property (nonatomic, weak) IBOutlet UILabel *maxIns;
@property (nonatomic, weak) IBOutlet UILabel *maxHrs;
@property (nonatomic, weak) IBOutlet UILabel *totalIns;
@property (nonatomic, weak) IBOutlet UILabel *totalHrs;
@property (nonatomic, weak) IBOutlet UILabel *dailyHrs;
@property (nonatomic, weak) IBOutlet UILabel *daillyIns;


// Pointers to other classes
@property (strong,nonatomic) BookmarksTableViewController *bm;


// DEBUG Panel
@property (nonatomic, weak) IBOutlet UIButton *zoomIn;
@property (nonatomic, weak) IBOutlet UIButton *zoomOut;
@property (nonatomic, weak) IBOutlet UIButton *logGeocode;
@property (nonatomic, weak) IBOutlet UILabel *debugLabel;
@property (nonatomic, weak) IBOutlet UILabel *debugBackground;
@property (nonatomic, weak) IBOutlet UIButton *showResults;


// Public Methods
- (void)zoomToLocation:(AGSPoint *)point;


// Actions
- (IBAction)findLocation:(id)sender;
- (IBAction)hideResultsDrawer:(id)sender;
- (IBAction)solarToggle:(id)sender;
- (IBAction)goHomeButton:(id)sender;
- (IBAction)geocodeSearch:(id)sender;
- (IBAction)basemapChanged:(id)sender;
- (IBAction)zoomIn:(id)sender;
- (IBAction)zoomOut:(id)sender;
- (IBAction)logGeocodeValue:(id)sender;
- (IBAction)solarSwitchToggle:(id)sender;

@end
