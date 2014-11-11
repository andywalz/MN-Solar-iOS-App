//
//  ViewController.h
//  MN Solar App
//
//  Created by Andy Walz on 11/1/14.
//  Copyright (c) 2014 MN Solar Suitability Team. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <ArcGIS/ArcGIS.h>

@interface MapViewController : UIViewController <AGSMapViewTouchDelegate>
@property (strong, nonatomic) IBOutlet AGSMapView *mapView;
@property (nonatomic, strong) AGSGraphicsLayer *graphicsLayer;
@property (nonatomic, strong) AGSLocator *locator;
@property (nonatomic, strong) AGSCalloutTemplate *calloutTemplate;
@property (nonatomic, strong) AGSJSONRequestOperation* currentJsonOp;
@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) UIView* loadingView;
@property(nonatomic, strong)AGSQueryTask* queryTask;
@property(nonatomic,strong)AGSQuery* query;

@property(nonatomic,strong)NSString* dsmTile;
@property(nonatomic, strong)AGSQueryTask* dsmqueryTask;
@property(nonatomic,strong)AGSQuery* dsmquery;
@property(nonatomic,weak)NSString* dsmname;


@property (weak, nonatomic) IBOutlet UIButton *zoomIn;
- (IBAction)zoomIn:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *zoomOut;
- (IBAction)zoomOut:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *solarToggle;
- (IBAction)solarToggle:(id)sender;


- (IBAction)basemapChanged:(id)sender;

@end

