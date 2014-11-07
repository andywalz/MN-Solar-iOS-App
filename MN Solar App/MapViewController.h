//
//  ViewController.h
//  MN Solar App
//
//  Created by Andy Walz on 11/1/14.
//  Copyright (c) 2014 MN Solar Suitability Team. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <ArcGIS/ArcGIS.h>

@interface MapViewController : UIViewController
@property (strong, nonatomic) IBOutlet AGSMapView *mapView;
@property (nonatomic, strong) AGSGraphicsLayer *graphicsLayer;
@property (nonatomic, strong) AGSLocator *locator;
@property (nonatomic, strong) AGSCalloutTemplate *calloutTemplate;


- (IBAction)basemapChanged:(id)sender;
@end

