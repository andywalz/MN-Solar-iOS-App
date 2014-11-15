//
//  ViewController.m
//  MN Solar App
//
//  Created by Andy Walz on 11/1/14.
//  Copyright (c) 2014 MN Solar Suitability Team. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController () <AGSMapViewLayerDelegate, AGSQueryTaskDelegate, AGSGeoprocessorDelegate>

- (IBAction)exitHere:(UIStoryboardSegue *)sender;

@end

@implementation MapViewController

int graphicCount = 0;
bool isHidden = YES;

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
    self.solarLayer = [AGSImageServiceLayer imageServiceLayerWithURL: url];
    
    [self.mapView insertMapLayer:self.solarLayer withName:@"Solar Tiled Layer" atIndex:1];
    
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
    
    //Convert Web Mercator to UTM15
    
    self.utm15Point = (AGSPoint*) [[AGSGeometryEngine defaultGeometryEngine] projectGeometry:mappoint toSpatialReference:[AGSSpatialReference spatialReferenceWithWKID:26915]];
    
    self.wgsPoint = (AGSPoint*) [[AGSGeometryEngine defaultGeometryEngine] projectGeometry:mappoint toSpatialReference:[AGSSpatialReference wgs84SpatialReference]];
    
    // Add graphics layer
    [self addPoint:mappoint];
    
    //EUSA query test
    NSURL* EUSAURL = [NSURL URLWithString: @"http://us-dspatialgis.oit.umn.edu:6080/arcgis/rest/services/solar/solar_fgdb/MapServer/0"];
    
    self.queryTask = [AGSQueryTask queryTaskWithURL:EUSAURL];
    self.queryTask.delegate = self;
    self.query = [AGSQuery query];
    self.query.outFields = [NSArray arrayWithObjects:@"*", nil];
    self.query.geometry = self.utm15Point;
    self.query.returnGeometry = NO;
    self.query.whereClause = @"1=1";
    
    [self.queryTask executeWithQuery:self.query];
    
    //dsm query test
    NSURL* dsmURL = [NSURL URLWithString: @"http://us-dspatialgis.oit.umn.edu:6080/arcgis/rest/services/solar/MN_DSM/ImageServer"];
    
    self.dsmqueryTask = [AGSQueryTask queryTaskWithURL:dsmURL];
    self.dsmqueryTask.delegate = self;
    self.dsmquery = [AGSQuery query];
    self.dsmquery.outFields = [NSArray arrayWithObjects:@"*", nil];
    self.dsmquery.geometry = self.utm15Point;
    self.dsmquery.returnGeometry = NO;
    self.dsmquery.whereClause = @"1=1";
    
    [self.dsmqueryTask executeWithQuery:self.dsmquery];
    
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



- (void) queryTask:(AGSQueryTask*)queryTask operation:(NSOperation *)op didExecuteWithFeatureSetResult:(AGSFeatureSet *)featureSet{
    
    AGSGraphic *feature = [featureSet.features objectAtIndex:0];
    NSString *fullName = [feature attributeAsStringForKey:@"FULL_NAME"];
    NSString *phone = [feature attributeAsStringForKey:@"PHONE"];
    NSString *temp = [feature attributeAsStringForKey:@"Name"];
    
    self.dsmname = temp;
    
    
    if (!fullName && !self.dsmname){
        NSLog(@"No Data!");
        
    }else{
        
        if (!fullName){
            // Error checking doesn't work, currently crashes outside MN
            NSLog(@"DSMName: %@",self.dsmname);
            [self gpTool];
        }
        else {
            NSLog(@"Name: %@, Phone: %@",fullName, phone);
        };
    
        
    }
}


- (void) queryTask:(AGSQueryTask*)queryTask operation:(NSOperation*)	op didFailWithError:(NSError *)error{
    NSLog(@"Error: %@",error);
    /*   //Error encountered while invoking webservice. Alert user
     self.mapView.callout.hidden = YES;
     UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Sorry"
     message:[error localizedDescription]
     delegate:nil cancelButtonTitle:@"OK"
     otherButtonTitles:nil];
     [av show];*/
}

-(void) gpTool{
    //NSLog(@"gpTool%@",self.dsmname);
    
    NSString *fullTileName = [NSString stringWithFormat:@"%@.img", self.dsmname];
    
    NSURL* gpURL = [NSURL URLWithString: @"http://us-dspatialgis.oit.umn.edu:6080/arcgis/rest/services/solar/SolarPointQuery_fast/GPServer/Script"];
    //NSLog(@"%f", self.wgsPoint.x);
    //NSLog(@"%f", self.wgsPoint.y);
    //NSLog(@"%@",fullTileName);
    
    // Build geoprocessor
    self.geoprocessor = [AGSGeoprocessor geoprocessorWithURL:gpURL];
    
    self.geoprocessor.delegate = self;
    
    // Geoprocessor build parameters
    AGSGPParameterValue *pointX = [AGSGPParameterValue parameterWithName:@"Point_X" type:AGSGPParameterTypeDouble value:[NSNumber numberWithDouble:self.wgsPoint.x]];
    AGSGPParameterValue *pointY = [AGSGPParameterValue parameterWithName:@"Point_Y" type:AGSGPParameterTypeDouble value:[NSNumber numberWithDouble:self.wgsPoint.y]];
    AGSGPParameterValue *tile = [AGSGPParameterValue parameterWithName:@"File_Name" type:AGSGPParameterTypeString value:fullTileName];
    
    // GP Parameters to array
    NSArray *params = [NSArray arrayWithObjects:pointX, pointY,tile, nil];
    
    // Run GP tool with no asynch delay
    //geoprocessor.interval = 20;
    //[geoprocessor executeWithParameters:params];
    
    //Run GP tool with asych delay
    self.geoprocessor.interval = 10;
    [self.geoprocessor submitJobWithParameters:params];
    
    NSString *results = @"21865.1328496\n39619.3044974\n84117.1905997\n126159.758433\n167013.891821\n175695.394165\n174199.414434\n143438.383851\n97395.6361771\n51997.4207866\n25002.0289475\n16517.4218279\n";
    
    // Split string into array
    NSMutableArray *resultsArray = [results componentsSeparatedByString: @"\n"];
    
    // Remove blank item from end of array
    [resultsArray removeObjectAtIndex:12];
    //NSLog(@"%@", resultsArray);
}

//this is the delegate method that gets called when job completes successfully
- (void)geoprocessor:(AGSGeoprocessor *)geoprocessor operation:(NSOperation *)op didSubmitJob:(AGSGPJobInfo *)jobInfo {
    
    NSLog(@"Geoprocessing Job Submitted!");
    //update status
    //self.statusMsgLabel.text = @"Geoprocessing Job Submitted!";
}

//this is the delegate method that gets called when gp job completes successfully.
- (void)geoprocessor:(AGSGeoprocessor *) geoprocessor operation:(NSOperation *) op jobDidSucceed:(AGSGPJobInfo *) jobInfo {
    
    NSLog(@"Geoprocessing Job Succeeded!");
    
    //job succeed..query result data
    //[geoprocessor queryResultData:jobInfo.jobId paramName:@"outerg_shp"];
}

- (void)geoprocessor:(AGSGeoprocessor *) geoprocessor operation:(NSOperation *) op jobDidFail:(AGSGPJobInfo *) jobInfo {
    
    NSLog(@"Geoprocessing Job Failed!");
    
    /*for (AGSGPMessage* msg in jobInfo.messages) {
        NSLog(@"%@", msg.description);
    }
    
    //update staus
    self.statusMsgLabel.text = @"Job Failed!";
    
    //reset the status
    [self performSelector:@selector(changeStatusLabel:) withObject:@"Tap on the map to get the spill analysis" afterDelay:4];*/
}


/*- (void) geoprocessor:(AGSGeoprocessor*) geoprocessor   operation:(NSOperation*) op didExecuteWithResults:(NSArray*) results  messages:(NSArray*) messages {
    
    NSLog(@"GP tool returned results");
    //for (AGSGPParameterValue* param in results) {
        //NSLog(@"Parameter: %@, Value: %@", param.name,param.value);
    //}
}

-(void) geoprocessor:(AGSGeoprocessor*) geoprocessor operation:(NSOperation *)op didExecuteWithFeatureSetResult:(AGSFeatureSet *)featureSet{
    NSLog(@"GP returned second results");
}

- (void)geoprocessor:(AGSGeoprocessor *)geoprocessor operation:(NSOperation*)op ofType:(AGSGPAsyncOperationType)opType didFailWithError:(NSError *)error forJob:(NSString*)jobId {
    NSLog(@"Error: %@",error);
}*/

/*- (void) geoprocessor:(AGSGeoprocessor*) geoprocessor operation:(AGSGPRequestOperation*)op jobDidFail:(AGSJobInfo*) jobInfo {
    for (AGSGPMessage* msg in jobInfo.messages) {
        NSLog(@"%@", msg.description);
    }
}*/

-(void) dsmqueryTask:(AGSQueryTask *)dsmqueryTask operation:(NSOperation *)op didExecuteWithFeatureSetResult:(AGSFeatureSet *)featureSet{
    NSLog(@"dsmquery");
}

-(void)dsmqueryTask:(AGSQueryTask *)dsmqueryTask operation:(NSOperation *)op didFailWithError:(NSError *)error{
    NSLog(@"dsmerror");
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

-(void)addPoint:(AGSPoint*) mappoint{
    
    graphicCount+=1;
    //NSLog(@"%@", mappoint);
    AGSGraphicsLayer* myGraphicsLayer = [AGSGraphicsLayer graphicsLayer];
    [self.mapView addMapLayer:myGraphicsLayer withName:@"Graphics Layer"];
    
    AGSPictureMarkerSymbol* pushpin = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"BluePushpin.png"];
    pushpin.offset = CGPointMake(9,16);
    pushpin.leaderPoint = CGPointMake(-9,11);
    AGSSimpleRenderer* renderer = [AGSSimpleRenderer simpleRendererWithSymbol:pushpin];
    myGraphicsLayer.renderer = renderer;
    
    //create a marker symbol to be used by our Graphic
    AGSSimpleMarkerSymbol *myMarkerSymbol =
    [AGSSimpleMarkerSymbol simpleMarkerSymbol];
    myMarkerSymbol.color = [UIColor blueColor];
    
    [myMarkerSymbol setSize:CGSizeMake(10,10)];
    [myMarkerSymbol setOutline:[AGSSimpleLineSymbol simpleLineSymbolWithColor:[UIColor redColor] width:1]];
    
    
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
        NSLog(@"DELETING OLD GRAPHICS");
        [myGraphicsLayer removeAllGraphics];
        graphicCount=0;
    }
    
    //Add the graphic to the Graphics layer
    [myGraphicsLayer addGraphic:myGraphic];
    
}

/*- (IBAction)solarSwitch:(id)sender {
    isHidden = !isHidden;
    self.solarLayer.visible = isHidden;
}

//[self.solarSwitch addTarget:self
                  action:@selector(stateChanged:) forControlEvents:UIControlEventValueChanged];*/

- (IBAction)solarSwitchToggle:(id)sender {
    if ([self.solarSwitch isOn]){
        NSLog(@"Switch is on");
        self.solarLayer.visible = YES;
    }else{
        self.solarLayer.visible = NO;
    }
}


// ---------------------------------
//  COMPLETE FUNCTIONS
// ---------------------------------

// Zoom in button
- (IBAction)zoomIn:(id)sender {
    [self.mapView zoomIn:YES];
}

// Zoom out button
- (IBAction)zoomOut:(id)sender {
    [self.mapView zoomOut:YES];
}

// Solar toggle
- (IBAction)solarToggle:(id)sender {
    isHidden = !isHidden;
    self.solarLayer.visible = isHidden;
    
}

// Change basemaps
- (IBAction)basemapChanged:(id)sender {
    
    NSURL* basemapURL ;
    UISegmentedControl* segControl = (UISegmentedControl*)sender;
    switch (segControl.selectedSegmentIndex) {
        case 0: //gray
            basemapURL = [NSURL URLWithString:@"http://services.arcgisonline.com/ArcGIS/rest/services/Canvas/World_Light_Gray_Base/MapServer"];
            break;
        case 1: //aerial
            basemapURL = [NSURL URLWithString:@"http://services.arcgisonline.com/arcgis/rest/services/World_Imagery/MapServer"];
            break;
        case 2: //Streets
            basemapURL = [NSURL URLWithString:@"http://services.arcgisonline.com/arcgis/rest/services/World_Street_Map/MapServer"];
            break;
        default:
            break;
    }
    
    //remove existing basemap layer
    [self.mapView removeMapLayerWithName:@"Basemap Tiled Layer"];
    
    // Add new basemap
    AGSTiledMapServiceLayer* newBasemapLayer = [AGSTiledMapServiceLayer tiledMapServiceLayerWithURL:basemapURL];
    [self.mapView insertMapLayer:newBasemapLayer withName:@"Basemap Tiled Layer" atIndex:0];
    
}


// ---------------------------------
//  DEFAULT IOS FUNCTIONS
// ---------------------------------


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)exitHere:(UIStoryboardSegue *)sender {
    //Excute this code upon unwinding
}


// ---------------------------------
//  SAVED CODE
// ---------------------------------

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

- (void)operation:(NSOperation*)op didFailWithError:(NSError *)error {
    //Error encountered while invoking webservice. Alert user
    self.mapView.callout.hidden = YES;
    UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                 message:[error localizedDescription]
                                                delegate:nil cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
    [av show];
}


@end
