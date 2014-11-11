//
//  ViewController.m
//  MN Solar App
//
//  Created by Andy Walz on 11/1/14.
//  Copyright (c) 2014 MN Solar Suitability Team. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController () <AGSMapViewLayerDelegate, AGSQueryTaskDelegate>

- (IBAction)exitHere:(UIStoryboardSegue *)sender;

@end

@implementation MapViewController

int graphicCount = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // set the delegate for the map view
    self.mapView.layerDelegate = self;
    
    
    
    //add new layer
    AGSTiledMapServiceLayer* newBasemapLayer = [AGSTiledMapServiceLayer tiledMapServiceLayerWithURL:[NSURL URLWithString:@"http://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer"]];
    [self.mapView insertMapLayer:newBasemapLayer withName:@"Basemap Tiled Layer" atIndex:0];
    
    //zoom to an area
    AGSEnvelope *envelope = [AGSEnvelope envelopeWithXmin:-10874639 ymin:5330544 xmax:-9900890  ymax:6349425  spatialReference:self.mapView.spatialReference];
    [self.mapView zoomToEnvelope:envelope animated:YES];
    
    //add solar layer
    NSURL* url = [NSURL URLWithString: @"http://us-dspatialgis.oit.umn.edu:6080/arcgis/rest/services/solar/Solar/ImageServer"];
    AGSImageServiceLayer* solarLayer = [AGSImageServiceLayer imageServiceLayerWithURL: url];
    
    [self.mapView insertMapLayer:solarLayer withName:@"Solar Tiled Layer" atIndex:1];
    //solarLayer.visible = NO;
    //[self drawSolar];
    
    
    
    
    //create an instance of a tiled map service layer
    /*AGSTiledMapServiceLayer *tiledLayer = [[AGSTiledMapServiceLayer alloc] initWithURL:[NSURL URLWithString:@"http://services.arcgisonline.com/ArcGIS/rest/services/Canvas/World_Light_Gray_Base/MapServer"]];*/
    
    //Add it to the map view
    //[self.mapView addMapLayer:tiledLayer withName:@"Tiled Layer"];
    
    //initialize the operation queue which will make webservice requests in the background
    self.queue = [[NSOperationQueue alloc] init];
    
    //Set the touch delegate so we can respond when user taps on the map
    self.mapView.touchDelegate = self;
    
    //Prepare the view we will display while loading weather information
    self.loadingView =  [[[NSBundle mainBundle] loadNibNamed:@"LoadingView" owner:nil options:nil] objectAtIndex:0];
    
    
    
}

#pragma mark AGSMapViewLayerDelegate methods

-(void) mapViewDidLoad:(AGSMapView*)mapView {
    
    //enable wrap around
    [self.mapView enableWrapAround];
    
    // Enable location display on the map
    [self.mapView.locationDisplay startDataSource];
    self.mapView.locationDisplay.autoPanMode = AGSLocationDisplayAutoPanModeDefault;
    
    [mapView.locationDisplay startDataSource];
    
    
}


- (void)mapView:(AGSMapView *)mapView didClickAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint features:(NSDictionary *)features{
    
    //Cancel any outstanding operations for previous webservice requests
    [self.queue cancelAllOperations];
    
    
    //Show an activity indicator while we initiate a new request
    //self.mapView.callout.customView = self.loadingView;
    //[self.mapView.callout showCalloutAt:mappoint screenOffset:CGPointZero animated:YES];
    
    //NSLog(@"%@", mappoint);
    
    //Convert Web Mercator to LatLong
    
    AGSPoint* utm15Point = (AGSPoint*) [[AGSGeometryEngine defaultGeometryEngine] projectGeometry:mappoint toSpatialReference:[AGSSpatialReference spatialReferenceWithWKID:26915]];
    
    //NSLog(@"%f, %f", latLong.x, latLong.y);
    
    //EUSA query test
    NSURL* url = [NSURL URLWithString: @"http://us-dspatialgis.oit.umn.edu:6080/arcgis/rest/services/solar/solar_fgdb/MapServer/0"];
    //AGSQueryTask* queryTask = [[AGSQueryTask alloc] initWithURL: url];
    //self.queryTask.delegate = self;
    
    //AGSQuery* query = [AGSQuery query];
    
    self.queryTask = [AGSQueryTask queryTaskWithURL:url];
    self.queryTask.delegate = self;
    
    self.query = [AGSQuery query];
    self.query.outFields = [NSArray arrayWithObjects:@"*", nil];
    
    self.query.geometry = utm15Point;
    self.query.returnGeometry = NO;
    self.query.whereClause = @"1=1";
    //query.outFields = [NSArray arrayWithObjects:@"*",nil];
    //self.query.spatialRelationship =  AGSSpatialRelationshipIntersects;
    
    [self.queryTask executeWithQuery:self.query];
    
    //self.query = [AGSQuery query];
    NSLog(@"%@",self.query.geometry);
    
    //[queryTask executeWithQuery:query] ;
    
    //NSLog(@"%@", utm15Point);
    
    

    // Add graphics layer
    [self addPoint:mappoint];
    
    
    /*//Set up the parameters to send the webservice
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithDouble:utm15Point.x] forKey:@"x"];
    [params setObject:[NSNumber numberWithDouble:utm15Point.y] forKey:@"y"];
    //[params setObject:[NSNumber numberWithDouble:mappoint.y] forKey:@"y"];
    
    //Set up an operation for the current request
    NSURL* url = [NSURL URLWithString:@"http://us-dspatialgis.oit.umn.edu:6080/arcgis/rest/services/solar/Solar/ImageServer/query"];
    self.currentJsonOp = [[AGSJSONRequestOperation alloc]initWithURL:url queryParameters:params];
    self.currentJsonOp.target = self;
    self.currentJsonOp.action = @selector(operation:didSucceedWithResponse:);
    self.currentJsonOp.errorAction = @selector(operation:didFailWithError:);
    
    //Add operation to the queue to execute in the background
    [self.queue addOperation:self.currentJsonOp];*/
    
    
}

-(void)addPoint:(AGSPoint*) mappoint{
    
    graphicCount+=1;
    //NSLog(@"%@", mappoint);
    AGSGraphicsLayer* myGraphicsLayer = [AGSGraphicsLayer graphicsLayer];
    [self.mapView addMapLayer:myGraphicsLayer withName:@"Graphics Layer"];
    
    //create a marker symbol to be used by our Graphic
    AGSSimpleMarkerSymbol *myMarkerSymbol =
    [AGSSimpleMarkerSymbol simpleMarkerSymbol];
    myMarkerSymbol.color = [UIColor blueColor];
    //myMarkerSymbol.size ={70};
    
    
    
    //Create an AGSPoint (which inherits from AGSGeometry) that
    //defines where the Graphic will be drawn
    AGSPoint* myMarkerPoint =
    [AGSPoint pointWithX:mappoint.x
                       y:mappoint.y
        spatialReference:[AGSSpatialReference wgs84SpatialReference]];
    
    //Create the Graphic, using the symbol and
    //geometry created earlier
    AGSGraphic* myGraphic =
    [AGSGraphic graphicWithGeometry:myMarkerPoint
                             symbol:myMarkerSymbol
                         attributes:nil];
    
    
    if(graphicCount>1){
        //NSLog(@"DELETING OLD GRAPHICS");
        [self.graphicsLayer removeAllGraphics];
        graphicCount=0;
    }
    
    
    //Add the graphic to the Graphics layer
    [myGraphicsLayer addGraphic:myGraphic];
    //NSLog(@"%lu", myGraphicsLayer.graphicsCount);
    //NSLog(@"%i", graphicCount);
    
    

}

- (void)operation:(NSOperation*)op didSucceedWithResponse:(NSDictionary *)solarInfo {
    //The webservice was invoked successfully.
    //Print the response to see what the JSON payload looks like.
    NSLog(@"%@", solarInfo);
    
    /*If we got any weather information
    if([weatherInfo objectForKey:@"weatherObservation"]!=nil){
        NSString* station = [[weatherInfo objectForKey:@"weatherObservation"] objectForKey:@"stationName"];
        NSString* clouds = [[weatherInfo objectForKey:@"weatherObservation"] objectForKey:@"clouds"];
        NSString* temp = [[weatherInfo objectForKey:@"weatherObservation"] objectForKey:@"temperature"];
        NSString* humidity = [[weatherInfo objectForKey:@"weatherObservation"] objectForKey:@"humidity"];
        //Hide the progress indicator, display weather information
        self.mapView.callout.customView = nil;
        self.mapView.callout.title = station;
        self.mapView.callout.detail = [NSString stringWithFormat:@"%@\u00B0c, %@%% Humidity, Condition:%@",temp,humidity,clouds];
    }else {
        //display the message returned by the webservice
        self.mapView.callout.customView = nil;
        self.mapView.callout.title = [[weatherInfo objectForKey:@"status"] objectForKey:@"message"];
        self.mapView.callout.detail = @"";
    } */
}

- (void)drawSolar{
    //add solar layer
    /*NSURL* url = [NSURL URLWithString: @"http://us-dspatialgis.oit.umn.edu:6080/arcgis/rest/services/solar/Solar/ImageServer"];
    AGSImageServiceLayer* solarLayer = [AGSImageServiceLayer imageServiceLayerWithURL: url];
    
    [self.mapView insertMapLayer:solarLayer withName:@"Solar Tiled Layer" atIndex:1];*/
    
    
    
    
    /*if (self.solarLayer.visible){
        NSLog(@"Visible solar");
        solarLayer.visible = NO;
        NSLog(@"Hiding solar");
    }else{
        solarLayer.visible = YES;
        NSLog(@"Showing solar");
    }*/
    
}

- (void)operation:(NSOperation*)op didFailWithError:(NSError *)error {
    //Error encountered while invoking webservice. Alert user
    self.mapView.callout.hidden = YES;
    UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                 message:[error localizedDescription] 
                                                delegate:nil cancelButtonTitle:@"OK" 
                                       otherButtonTitles:nil];
    [av show];
}

- (void) queryTask:(AGSQueryTask*)queryTask operation:(NSOperation *)op didExecuteWithFeatureSetResult:(AGSFeatureSet *)featureSet{
    
    AGSGraphic *feature = [featureSet.features objectAtIndex:0];
    NSString *fullName = [feature attributeAsStringForKey:@"FULL_NAME"];
    NSString *phone = [feature attributeAsStringForKey:@"PHONE"];
    
    NSLog(@"Name: %@, Phone: %@",fullName, phone);
}

- (void) queryTask:(AGSQueryTask*)queryTask operation:(NSOperation*)op didExecuteWithRelatedFeatures:(NSDictionary*) relatedFeatures {
    
    NSLog(@"queryTask 2executed");
    
}

- (void) queryTask:(AGSQueryTask*)queryTask operation:(NSOperation*)	op didFailRelationshipQueryWithError: (NSError*)	error {
    NSLog(@"Error: %@",error);
    /*   //Error encountered while invoking webservice. Alert user
     self.mapView.callout.hidden = YES;
     UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Sorry"
     message:[error localizedDescription]
     delegate:nil cancelButtonTitle:@"OK"
     otherButtonTitles:nil];
     [av show];*/
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)exitHere:(UIStoryboardSegue *)sender {
    //Excute this code upon unwinding
}


- (IBAction)solarToggle:(id)sender {
    [self drawSolar];
    NSLog(@"SolarToggle");
    
}

- (IBAction)basemapChanged:(id)sender {
    
    NSURL* basemapURL ;
    UISegmentedControl* segControl = (UISegmentedControl*)sender;
    switch (segControl.selectedSegmentIndex) {
        case 0: //gray
            
            //solarLayer.hidden = YES;
            basemapURL = [NSURL URLWithString:@"http://us-dspatialgis.oit.umn.edu:6080/arcgis/rest/services/solar/Solar/ImageServer"];
            
            break;
        case 1: //aerial
            basemapURL = [NSURL URLWithString:@"http://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer"];
            break;
        case 2: //Streets
            basemapURL = [NSURL URLWithString:@"http://services.arcgisonline.com/arcgis/rest/services/World_Street_Map/MapServer"];
            break;
        default:
            break;
    }
    
    //remove existing basemap layer
    [self.mapView removeMapLayerWithName:@"Basemap Tiled Layer"];
    
    if([[basemapURL absoluteString] isEqualToString:@"http://us-dspatialgis.oit.umn.edu:6080/arcgis/rest/services/solar/Solar/ImageServer"]){
        AGSImageServiceLayer* solarLayer = [AGSImageServiceLayer imageServiceLayerWithURL: basemapURL];
        if (solarLayer.visible==YES){
            solarLayer.visible = NO;
            NSLog(@"HIDING SOLAR");
        }
        else{
            solarLayer.visible = YES;
            [self.mapView insertMapLayer:solarLayer withName:@"Solar Tiled Layer" atIndex:1];
            NSLog(@"SHOWING SOLAR");
        }
        
    }else{
    
        //add new layer
        AGSTiledMapServiceLayer* newBasemapLayer = [AGSTiledMapServiceLayer tiledMapServiceLayerWithURL:basemapURL];
        [self.mapView insertMapLayer:newBasemapLayer withName:@"Basemap Tiled Layer" atIndex:0];
        NSLog(@"CHANGING BASEMAP");
    }

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



- (IBAction)zoomIn:(id)sender {
    [self.mapView zoomIn:YES];
}

- (IBAction)zoomOut:(id)sender {
    [self.mapView zoomOut:YES];
}
@end
