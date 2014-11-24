//
//  ViewController.h
//  MN Solar App
//
//  Created by Andy Walz on 11/1/14.
//  Copyright (c) 2014 MN Solar Suitability Team. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <ArcGIS/ArcGIS.h>
#import "GCGeocodingService.h"
#import "Reachability.h"

#import "ReportViewController.h"

@interface MapViewController : UIViewController <AGSMapViewTouchDelegate, UITextFieldDelegate>

// Internet connection check
@property(weak,nonatomic) Reachability *internetReachableFoo;

@property (strong, nonatomic) IBOutlet AGSMapView *mapView;
@property (weak, nonatomic) IBOutlet UISwitch *solarSwitch;
- (IBAction)solarSwitchToggle:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *solarOn;
@property (weak, nonatomic) IBOutlet UILabel *solarOff;



@property (weak, nonatomic) IBOutlet UIView *loadingIconView;

@property (weak, nonatomic) IBOutlet UILabel *statusMsgLabel;
@property (nonatomic, strong) AGSGraphicsLayer *graphicsLayer;
@property (nonatomic, strong) AGSGraphicsLayer *myGraphicsLayer;
@property (nonatomic, weak) AGSGraphic *pushpin;
@property (nonatomic,weak) UIImage *pushpinImg;


@property (nonatomic, strong) AGSLocator *locator;
@property (nonatomic, strong) AGSCalloutTemplate *calloutTemplate;
@property (nonatomic, strong) AGSJSONRequestOperation* currentJsonOp;
@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) UIView* loadingView;

@property(nonatomic, strong)AGSQueryTask* queryTask;
@property(nonatomic,strong)AGSQuery* query;
@property(nonatomic,strong) NSString* eusaFULL_NAME;
@property(nonatomic,strong) NSString* eusaSTREET;
@property(nonatomic,strong) NSString* eusaCITY;
@property(nonatomic,strong) NSString* eusaZIP;
@property(nonatomic,strong) NSString* eusaPHONE;
@property(nonatomic,strong) NSString* eusaWEBSITE;
@property(nonatomic,strong) NSString* eusaELEC_COMP;


@property(nonatomic,strong) AGSPoint *utm15Point;
@property(nonatomic,strong)AGSPoint *wgsPoint;
@property(nonatomic,strong)AGSPoint *geocodePoint;
@property(nonatomic,strong)AGSPoint *geocodePointWeb;

@property (nonatomic, strong) AGSGeoprocessor *geoprocessor;
@property (nonatomic,weak) NSString * solarValue;
@property (nonatomic,weak) NSString * solarHours;
@property (nonatomic,weak) NSMutableArray * solarValueArray;
@property (nonatomic,strong) NSMutableArray * solarValueArrayNum;
@property (nonatomic,strong) NSMutableArray * solarValueArrayNumkwh;
@property (nonatomic, weak) NSMutableArray * solarHoursArray;
@property (nonatomic, strong) NSMutableArray * solarHoursArrayNum;
@property (nonatomic, strong) NSMutableArray * solarHoursArrayNumFloat;

@property(nonatomic,weak)AGSImageServiceLayer *solarLayer;

@property (weak, nonatomic) IBOutlet UIView *resultsDrawer;
- (IBAction)hideResultsDrawer:(id)sender;
@property(nonatomic,strong)NSString* dsmTile;
@property(nonatomic, strong)AGSQueryTask* dsmqueryTask;
@property(nonatomic,strong)AGSQuery* dsmquery;
@property(nonatomic,weak)NSString* dsmname;
@property (weak, nonatomic) IBOutlet UITextField *searchBar;

@property (weak, nonatomic) IBOutlet UILabel *maxIns;
@property (weak, nonatomic) IBOutlet UILabel *maxHrs;
@property (weak, nonatomic) IBOutlet UILabel *totalIns;
@property (weak, nonatomic) IBOutlet UILabel *totalHrs;
@property (weak, nonatomic) IBOutlet UILabel *dailyHrs;
@property (weak, nonatomic) IBOutlet UILabel *daillyIns;

@property (strong, nonatomic) NSNumber *maxInsVal;
@property (strong, nonatomic) NSNumber *maxHrsVal;
@property (strong, nonatomic) NSNumber *totalInsVal;
@property (strong, nonatomic) NSNumber *totalHrsVal;
@property (weak, nonatomic) IBOutlet UILabel *solPotential;

@property (weak, nonatomic) IBOutlet UIButton *solarToggle;
- (IBAction)solarToggle:(id)sender;

@property (weak,nonatomic) NSString *geocodeAddress;


- (IBAction)geocodeSearch:(id)sender;

- (IBAction)basemapChanged:(id)sender;



// DEBUG

@property (weak, nonatomic) IBOutlet UIButton *zoomIn;
- (IBAction)zoomIn:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *zoomOut;
- (IBAction)zoomOut:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *logGeocode;

- (IBAction)logGeocodeValue:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *debugLabel;
@property (weak, nonatomic) IBOutlet UILabel *debugBackground;
@property (weak, nonatomic) IBOutlet UIButton *showResults;


@end

