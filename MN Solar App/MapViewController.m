//
//  ViewController.m
//  MN Solar App
//
//  Created by Andy Walz on 11/1/14.
//  Copyright (c) 2014 MN Solar Suitability Team. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController () <AGSMapViewLayerDelegate>

- (IBAction)exitHere:(UIStoryboardSegue *)sender;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // set the delegate for the map view
    self.mapView.layerDelegate = self;
    
    //create an instance of a tiled map service layer
    /*AGSTiledMapServiceLayer *tiledLayer = [[AGSTiledMapServiceLayer alloc] initWithURL:[NSURL URLWithString:@"http://services.arcgisonline.com/ArcGIS/rest/services/Canvas/World_Light_Gray_Base/MapServer"]];*/
    
    //Add it to the map view
    //[self.mapView addMapLayer:tiledLayer withName:@"Tiled Layer"];
    
}

#pragma mark AGSMapViewLayerDelegate methods

-(void) mapViewDidLoad:(AGSMapView*)mapView {
    
    //enable wrap around
    [self.mapView enableWrapAround];
    
    // Enable location display on the map
    [self.mapView.locationDisplay startDataSource];
    self.mapView.locationDisplay.autoPanMode = AGSLocationDisplayAutoPanModeDefault;
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)exitHere:(UIStoryboardSegue *)sender {
    //Excute this code upon unwinding
}

- (IBAction)basemapChanged:(id)sender {
    
    NSURL* basemapURL ;
    UISegmentedControl* segControl = (UISegmentedControl*)sender;
    switch (segControl.selectedSegmentIndex) {
        case 0: //gray
            basemapURL = [NSURL URLWithString:@"http://services.arcgisonline.com/ArcGIS/rest/services/Canvas/World_Light_Gray_Base/MapServer"];
            break;
        case 1: //oceans
            basemapURL = [NSURL URLWithString:@"http://services.arcgisonline.com/ArcGIS/rest/services/Ocean_Basemap/MapServer"];
            break;
        case 2: //nat geo
            basemapURL = [NSURL URLWithString:@"http://services.arcgisonline.com/ArcGIS/rest/services/NatGeo_World_Map/MapServer"];
            break;
        case 3: //topo
            basemapURL = [NSURL URLWithString:@"http://services.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer"];
            break;
        case 4: //sat
            basemapURL = [NSURL URLWithString:@"http://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer"];
            break;
        default:
            break;
    }
    //remove existing basemap layer
    [self.mapView removeMapLayerWithName:@"Basemap Tiled Layer"];
    
    //add new layer
    AGSTiledMapServiceLayer* newBasemapLayer = [AGSTiledMapServiceLayer tiledMapServiceLayerWithURL:basemapURL];
    [self.mapView insertMapLayer:newBasemapLayer withName:@"Basemap Tiled Layer" atIndex:0];

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    //Hide the keyboard
    [searchBar resignFirstResponder];
    
    if(!self.graphicsLayer){
        //Add a graphics layer to the map. This layer will hold geocoding results
        self.graphicsLayer = [AGSGraphicsLayer graphicsLayer];
        [self.mapView addMapLayer:self.graphicsLayer withName:@"Results"];
        
        //Assign a simple renderer to the layer to display results as pushpins
        AGSPictureMarkerSymbol* pushpin = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"BluePushpin.png"];
        pushpin.offset = CGPointMake(9,16);
        pushpin.leaderPoint = CGPointMake(-9,11);
        AGSSimpleRenderer* renderer = [AGSSimpleRenderer simpleRendererWithSymbol:pushpin];
        self.graphicsLayer.renderer = renderer;
    }else{
        //Clear out previous results if we already have a graphics layer
        [self.graphicsLayer removeAllGraphics];
    }
    
    
    if(!self.locator){
        //Create the AGSLocator pointing to the geocode service on ArcGIS Online
        //Set the delegate so that we are informed through AGSLocatorDelegate methods
        self.locator = [AGSLocator locatorWithURL:[NSURL URLWithString:@"http://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer"]];
        //self.locator.delegate = self;   //Chris I had to comment this out to make it work
    }
    
    //Set the parameters
    AGSLocatorFindParameters* params = [[AGSLocatorFindParameters alloc]init];
    params.text = searchBar.text;
    params.outFields = @[@"*"];
    params.outSpatialReference = self.mapView.spatialReference;
    
    //Kick off the geocoding operation.
    //This will invoke the geocode service on a background thread.
    [self.locator findWithParameters:params];
    
    
}

- (void)locator:(AGSLocator *)locator operation:(NSOperation *)op didFind:(NSArray *)results {
    if (results == nil || [results count] == 0)
    {
        //show alert if we didn't get results
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Results"
                                                        message:@"No Results Found"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];
    }
    else
    {
        //Add a graphic for each result
        for (AGSLocatorFindResult* result in results) {
            AGSGraphic* graphic = result.graphic;
            [self.graphicsLayer addGraphic:graphic];
        }
        
        //Zoom in to the results
        AGSMutableEnvelope *extent = [self.graphicsLayer.fullEnvelope mutableCopy];
        [extent expandByFactor:1.5];
        [self.mapView zoomToEnvelope:extent animated:YES];
    }
}



@end
