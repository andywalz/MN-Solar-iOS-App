//
//  ViewController.m
//  MN Solar App
//
//  Created by Andy Walz on 11/1/14.
//  Copyright (c) 2014 MN Solar Suitability Team. All rights reserved.
//

#import "MapViewController.h"
@class ReportViewController;
@class GCGeocodingService;
//@synthesize gs;

@interface MapViewController () <AGSMapViewLayerDelegate, AGSQueryTaskDelegate, AGSGeoprocessorDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *chartViewer;

- (IBAction)exitHere:(UIStoryboardSegue *)sender;

@end

@implementation MapViewController

bool isHidden = YES;
GCGeocodingService * myGC;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.resultsDrawer.hidden=isHidden;
    self.loadingIconView.hidden=YES;
    
    // Check for internet connection
    [self internetReachableFoo];
    
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
    
    // Create reference to GCGeocodingService class
    myGC = [[GCGeocodingService alloc] init];
    //NSString *address = @"1217 matilda st 55117";
    //[myGC geocodeAddress:address];
    
}

// Checks if we have an internet connection or not
- (void)testInternetConnection
{
    self.internetReachableFoo = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Internet is reachable
    self.internetReachableFoo.reachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Yayyy, we have the interwebs!");
        });
    };
    
    // Internet is not reachable
    self.internetReachableFoo.unreachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Someone broke the internet :(");
        });
    };
    
    [self.internetReachableFoo startNotifier];
}

#pragma mark AGSMapViewLayerDelegate methods

-(void) mapViewDidLoad:(AGSMapView*)mapView {
    
    //enable wrap around
    [self.mapView enableWrapAround];
    
    // Enable location display on the map
    //[self.mapView.locationDisplay startDataSource];
    //self.mapView.locationDisplay.autoPanMode = AGSLocationDisplayAutoPanModeDefault;

    // Enable user location
    //[self.mapView.locationDisplay startDataSource];
    
}

-(void) convertToWGS:(AGSPoint*)mappoint{
    self.wgsPoint = (AGSPoint*) [[AGSGeometryEngine defaultGeometryEngine] projectGeometry:mappoint toSpatialReference:[AGSSpatialReference wgs84SpatialReference]];
}

-(void) convertToUTM15:(AGSPoint*)mappoint{
    self.utm15Point = (AGSPoint*) [[AGSGeometryEngine defaultGeometryEngine] projectGeometry:mappoint toSpatialReference:[AGSSpatialReference spatialReferenceWithWKID:26915]];
}

- (void)mapView:(AGSMapView *)mapView didClickAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint features:(NSDictionary *)features{
    
    //Cancel any outstanding operations for previous webservice requests
    [self.queue cancelAllOperations];
    
    //Show an activity indicator while we initiate a new request
    //self.mapView.callout.customView = self.loadingView;
    //[self.mapView.callout showCalloutAt:mappoint screenOffset:CGPointZero animated:YES];
    
    //Convert Web Mercator to UTM15
    
    [self convertToUTM15:mappoint];
    
    [self convertToWGS:self.utm15Point];
    
    
    //self.wgsPoint = (AGSPoint*) [[AGSGeometryEngine defaultGeometryEngine] projectGeometry:mappoint toSpatialReference:[AGSSpatialReference wgs84SpatialReference]];
    
    // Add graphics layer
    [self addPoint:mappoint];
    
    // Run query
    [self runQueries];
    
    // Run GP tool
    //[self gpTool];

    
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

- (void) runQueries {
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
}

// EUSA query successful
- (void) queryTask:(AGSQueryTask*)queryTask operation:(NSOperation *)op didExecuteWithFeatureSetResult:(AGSFeatureSet *)featureSet{
    
    self.myFeature = [featureSet.features objectAtIndex:0];
    //AGSGraphic *feature = [featureSet.features objectAtIndex:0];
    NSLog(@"TTEST%@",self.myFeature);
    
    NSString *temp = [self.myFeature attributeAsStringForKey:@"Name"];

    NSString *uTemp = [self.myFeature attributeAsStringForKey:@"FULL_NAME"];
    
    if (!temp && !uTemp){
        NSLog(@"No Data!");
        
    }else{
        
        if (!uTemp){
            self.dsmname = temp;
            
            // Error checking doesn't work, currently crashes outside MN
            NSLog(@"DSMName: %@",self.dsmname);
            //[self gpTool];
        }
        else {
            
            self.eusaFULL_NAME = uTemp;
            NSString *fs = [self.myFeature attributeAsStringForKey:@"STREET"];
            self.eusaSTREET = fs;
            NSString *fc = [self.myFeature attributeAsStringForKey:@"CITY"];
            self.eusaCITY = fc;
            NSString *fz = [self.myFeature attributeAsStringForKey:@"ZIP"];
            self.eusaZIP = fz;
            NSString *fw =[self.myFeature attributeAsStringForKey:@"WEBSITE"];
            self.eusaWEBSITE = fw;
            NSString *fp = [self.myFeature attributeAsStringForKey:@"PHONE"];
            self.eusaPHONE = fp;
            
            NSLog(@"Name: %@, Phone: %@",self.eusaFULL_NAME, self.eusaPHONE);
            
        };
    
        
    }
    // NEEDS ERROR CHECKING - set variable in GCGeocoding
    [self gpTool];
}

// EUSA query fails
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


// DSM query successful
-(void) dsmqueryTask:(AGSQueryTask *)dsmqueryTask operation:(NSOperation *)op didExecuteWithFeatureSetResult:(AGSFeatureSet *)featureSet{
    NSLog(@"dsmquery");
}

// DSM query fail - CURRENTLY CRASHES APP WHEN FAIL
-(void)dsmqueryTask:(AGSQueryTask *)dsmqueryTask operation:(NSOperation *)op didFailWithError:(NSError *)error{
    NSLog(@"dsmerror");
}

#pragma mark Locator Methods #pragma mark -


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

#pragma mark Create Point #pragma mark -

-(void)addPoint:(AGSPoint*) mappoint{
    
    [self.myGraphicsLayer removeAllGraphics];

    self.myGraphicsLayer = [AGSGraphicsLayer graphicsLayer];
    [self.mapView addMapLayer:self.myGraphicsLayer withName:@"Graphics Layer"];
    
    AGSPictureMarkerSymbol* pushpin = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"bluepushpin"];
    //pushpin = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"zoomIn.png"];
    pushpin.offset = CGPointMake(0,15);
    //pushpin.leaderPoint = CGPointMake(-9,11);
    [pushpin setSize:CGSizeMake(20,30)];
    AGSSimpleRenderer* renderer = [AGSSimpleRenderer simpleRendererWithSymbol:pushpin];
    self.myGraphicsLayer.renderer = renderer;
    
    //create a marker symbol to be used by our Graphic
    /*AGSSimpleMarkerSymbol *myMarkerSymbol =
    [AGSSimpleMarkerSymbol simpleMarkerSymbol];
    myMarkerSymbol.color = [UIColor blueColor];
    
    [myMarkerSymbol setSize:CGSizeMake(10,10)];
    [myMarkerSymbol setOutline:[AGSSimpleLineSymbol simpleLineSymbolWithColor:[UIColor redColor] width:1]];*/
    
    //Create an AGSPoint (which inherits from AGSGeometry) that
    //defines where the Graphic will be drawn
    
    AGSPoint* myMarkerPoint =
    [AGSPoint pointWithX:mappoint.x
                       y:mappoint.y
        spatialReference:[AGSSpatialReference wgs84SpatialReference]];
    
    NSLog(@"%@", myMarkerPoint);
    
    //Create the Graphic, using the symbol and
    //geometry created earlier
    AGSGraphic* myGraphic =
    [AGSGraphic graphicWithGeometry:myMarkerPoint
                             symbol:pushpin
                         attributes:nil];
    
    //Add the graphic to the Graphics layer
    [self.myGraphicsLayer addGraphic:myGraphic];
    
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

- (bool) textFieldShouldReturn:(UITextField *)searchBar{
    [self.view endEditing:YES];
    [self geocodeSearch:(searchBar)];
    
    return YES;
}

#pragma mark Complete Methods #pragma mark -

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

- (IBAction)geocodeSearch:(id)sender {
    NSString *address = self.searchBar.text;
    NSLog(@"%@", address);
    [myGC geocodeAddress:address];
    
    NSLog(@"Address: %@", myGC.geocodeResults[@"address"]);
    
    NSLog(@"Trying to add pin");
    float x = [myGC.geocodeResults[@"lng"] floatValue];
    float y = [myGC.geocodeResults[@"lat"] floatValue];
    self.geocodePoint = [AGSPoint pointWithX:x
                                          y:y
                           spatialReference:[AGSSpatialReference wgs84SpatialReference]];
    self.geocodePointWeb = (AGSPoint*) [[AGSGeometryEngine defaultGeometryEngine] projectGeometry:self.geocodePoint toSpatialReference:[AGSSpatialReference webMercatorSpatialReference]];
    
    NSLog(@"Trying to zoom!");
    
    AGSEnvelope *envelope = [AGSEnvelope envelopeWithXmin:self.geocodePointWeb.x - 200 ymin:self.geocodePointWeb.y - 200 xmax:self.geocodePointWeb.x + 200  ymax:self.geocodePointWeb.y + 200 spatialReference:self.mapView.spatialReference];
    [self.mapView zoomToEnvelope:envelope animated:YES];
    
    [self addPoint:self.geocodePointWeb];
    
    [self convertToWGS:self.geocodePoint];
    [self convertToUTM15:self.geocodePoint];
    
    [self runQueries];
    
}

// change basemaps

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

- (IBAction)logGeocodeValue:(id)sender {
    //NSLog(@"%@", myGC.geocodeResults );
    NSLog(@"Address: %@", myGC.geocodeResults[@"address"]);
}

-(void) gpTool{
    
    NSLog(@"DSM Name ===== %@", self.dsmname);
    NSLog(@"IngpToolName: %@, Phone: %@",self.eusaFULL_NAME, self.eusaPHONE);

    self.loadingIconView.hidden=NO;
    //self.loadingView.hidden=NO;
    
    NSString *fullTileName = [NSString stringWithFormat:@"%@.img", self.dsmname];
    
    NSURL* gpURL = [NSURL URLWithString: @"http://us-dspatialgis.oit.umn.edu:6080/arcgis/rest/services/solar/SolarPointQuery_fast/GPServer/Script"];

    // Build geoprocessor
    self.geoprocessor = [AGSGeoprocessor geoprocessorWithURL:gpURL];
    
    self.geoprocessor.delegate = self;
    
    /*if (!self.wgsPoint.x){
        // Geoprocessor build parameters
        AGSGPParameterValue *pointX = [AGSGPParameterValue parameterWithName:@"PointX" type:AGSGPParameterTypeDouble value:[NSNumber numberWithDouble:self.geocodePointWeb.x]];
        AGSGPParameterValue *pointY = [AGSGPParameterValue parameterWithName:@"PointY" type:AGSGPParameterTypeDouble value:[NSNumber numberWithDouble:self.wgsPoint.y]];
        AGSGPParameterValue *tile = [AGSGPParameterValue parameterWithName:@"File_Name" type:AGSGPParameterTypeString value:fullTileName];
        
        // GP Parameters to array
        NSArray *params = [NSArray arrayWithObjects:pointX, pointY,tile, nil];
        // Run GP tool as synch
        //NSLog(@"About to fire GP tool");
        [self.geoprocessor executeWithParameters:params];
        
    }
    else{*/
    
    // Geoprocessor build parameters
    AGSGPParameterValue *pointX = [AGSGPParameterValue parameterWithName:@"PointX" type:AGSGPParameterTypeDouble value:[NSNumber numberWithDouble:self.wgsPoint.x]];
    AGSGPParameterValue *pointY = [AGSGPParameterValue parameterWithName:@"PointY" type:AGSGPParameterTypeDouble value:[NSNumber numberWithDouble:self.wgsPoint.y]];
    AGSGPParameterValue *tile = [AGSGPParameterValue parameterWithName:@"File_Name" type:AGSGPParameterTypeString value:fullTileName];
        
        // GP Parameters to array
        NSArray *params = [NSArray arrayWithObjects:pointX, pointY,tile, nil];
        // Run GP tool as synch
        //NSLog(@"About to fire GP tool");
        [self.geoprocessor executeWithParameters:params];
    //};
    
    
    
    
    
}

//this is the delegate method that gets called when GP completes successfully
- (void) geoprocessor:(AGSGeoprocessor*) geoprocessor   operation:(NSOperation*) op didExecuteWithResults:(NSArray*) results  messages:(NSArray*) messages {
    
    
    
    for (AGSGPParameterValue* param in results) {
        //NSLog(@"Parameter: %@", param.name);
        
        if ([param.name isEqualToString: @"Solar_Value"]){
            self.solarValue = param.value;
            NSNumber *sunInsolMax = 0;
            // Split string into array
            self.solarValueArray = [self.solarValue componentsSeparatedByString: @"\n"];
            
            // Remove blank item from end of array
            [self.solarValueArray removeObjectAtIndex:12];
            
            self.solarValueArrayNum = [[NSMutableArray alloc]init];
            self.solarValueArrayNumkwh = [[NSMutableArray alloc] init];
            
            // Convert string array to NSDecimalNumber array
            for (NSInteger i = 0, count = [self.solarValueArray count]; i < count; i++){

                NSNumber *convertToNum = [NSDecimalNumber decimalNumberWithString:self.solarValueArray[i]];
                
                [self.solarValueArrayNum addObject:convertToNum];
                
                float convertToNumFloat= [convertToNum floatValue];
                float kwh = convertToNumFloat/1000;
                NSNumber *kwhtoArray = [NSNumber numberWithFloat:kwh];
                [self.solarValueArrayNumkwh addObject:kwhtoArray];
                 };
            
            float totalInsValue;
            
            // Iterate kwh array, find sum, and find largest value
            for (NSInteger i = 0, count = [self.solarValueArrayNumkwh count]; i < count; i++){
      
                if (self.solarValueArrayNumkwh[i]>sunInsolMax){
                    sunInsolMax = self.solarValueArrayNumkwh[i];
                    self.maxInsVal = self.solarValueArrayNumkwh[i];
                };
                
                totalInsValue += [self.solarValueArrayNumkwh[i] floatValue];
                
            };
            
            self.totalInsVal = [NSNumber numberWithFloat:totalInsValue];
            self.maxIns.text = [self.maxInsVal stringValue];
            self.totalIns.text = [self.totalInsVal stringValue];
           // self.daillyIns.text = [[NSNumber numberWithDouble:(self.totalInsVal.doubleValue / 365.0)] stringValue];
            self.daillyIns.text = [NSString stringWithFormat:@"%0.3f", (self.totalInsVal.doubleValue / 365.0)];
            
            if(self.totalInsVal.doubleValue / 365.0 >= 2.7){
                self.solPotential.text = @"[ Optimal ]";
            }else if (self.totalInsVal.doubleValue / 365.0 >= 1.6){
                self.solPotential.text = @"[ Good ]";
            }else{
                self.solPotential.text = @"[ Poor ]";
            }
            
            
        }
        else if ([param.name isEqualToString: @"Solar_Hours"]){
            self.solarHours = param.value;
            NSNumber *sunHrMax = 0;
            // Split string into array
            self.solarHoursArray = [self.solarHours componentsSeparatedByString: @"\n"];
            
            // Remove blank item from end of array
            [self.solarHoursArray removeObjectAtIndex:12];
            
            self.solarHoursArrayNum = [[NSMutableArray alloc]init];
            self.solarHoursArrayNumFloat = [[NSMutableArray alloc]init];
            
            // Convert string array to NSDecimalNumber array
            for (NSInteger i = 0, count = [self.solarHoursArray count]; i < count; i++){
                NSNumber *convertToNum = [NSDecimalNumber decimalNumberWithString:self.solarHoursArray[i]];
                float convertToNumFloat = [convertToNum floatValue];
                NSNumber *sunHrs = [NSNumber numberWithFloat:convertToNumFloat];
                [self.solarHoursArrayNum addObject:convertToNum];
                [self.solarHoursArrayNumFloat addObject:sunHrs];
            };
            
            float totalSunHrValue;
            
            // Iterate kwh array, find sum, and find largest value
            for (NSInteger i = 0, count = [self.solarHoursArrayNumFloat count]; i < count; i++){
                
                if (self.solarHoursArrayNumFloat[i]>sunHrMax){
                    sunHrMax = self.solarHoursArrayNumFloat[i];
                    self.maxHrsVal = self.solarHoursArrayNumFloat[i];
                };
                
                totalSunHrValue += [self.solarHoursArrayNumFloat[i] floatValue];
                
            };
            
            /*// Iterate NSDecimalNumber array and find largest value
            for (NSInteger i = 0, count = [self.solarHoursArrayNum count]; i < count; i++){
                if ([self.solarHoursArrayNum[i] compare:sunHrMax]== NSOrderedDescending){
                    self.maxHrsVal = self.solarHoursArrayNum[i];
                    sunHrMax = self.solarHoursArrayNum[i];
                };
            };*/
            
            self.totalHrsVal = [NSNumber numberWithFloat:totalSunHrValue];
            self.maxHrs.text = [self.maxHrsVal stringValue];
            self.totalHrs.text = [self.totalHrsVal stringValue];
            self.dailyHrs.text = [NSString stringWithFormat:@"%0.3f", (self.totalHrsVal.doubleValue / 365.0)];
        };
        
        /* Change value label using kwh array (float) as string value
        self.janVal.text = [[self.solarValueArrayNumkwh objectAtIndex:0] stringValue];
        self.febVal.text = [[self.solarValueArrayNumkwh objectAtIndex:1] stringValue];
        self.marVal.text = [[self.solarValueArrayNumkwh objectAtIndex:2] stringValue];
        self.aprVal.text = [[self.solarValueArrayNumkwh objectAtIndex:3] stringValue];
        self.mayVal.text = [[self.solarValueArrayNumkwh objectAtIndex:4] stringValue];
        self.junVal.text = [[self.solarValueArrayNumkwh objectAtIndex:5] stringValue];
        self.julVal.text = [[self.solarValueArrayNumkwh objectAtIndex:6] stringValue];
        self.augVal.text = [[self.solarValueArrayNumkwh objectAtIndex:7] stringValue];
        self.sepVal.text = [[self.solarValueArrayNumkwh objectAtIndex:8] stringValue];
        self.octVal.text = [[self.solarValueArrayNumkwh objectAtIndex:9] stringValue];
        self.novVal.text = [[self.solarValueArrayNumkwh objectAtIndex:10] stringValue];
        self.decVal.text = [[self.solarValueArrayNumkwh objectAtIndex:11] stringValue];
        
        self.janHr.text = [self.solarHoursArray objectAtIndex:0];
        self.febHr.text = [self.solarHoursArray objectAtIndex:1];
        self.marHr.text = [self.solarHoursArray objectAtIndex:2];
        self.aprHr.text = [self.solarHoursArray objectAtIndex:3];
        self.mayHr.text = [self.solarHoursArray objectAtIndex:4];
        self.junHr.text = [self.solarHoursArray objectAtIndex:5];
        self.julHr.text = [self.solarHoursArray objectAtIndex:6];
        self.augHr.text = [self.solarHoursArray objectAtIndex:7];
        self.sepHr.text = [self.solarHoursArray objectAtIndex:8];
        self.octHr.text = [self.solarHoursArray objectAtIndex:9];
        self.novHr.text = [self.solarHoursArray objectAtIndex:10];
        self.decHr.text = [self.solarHoursArray objectAtIndex:11]; */
        
        NSString *chartURL = [NSString stringWithFormat:@"http://solar.maps.umn.edu/ios/chart2.php?1=%@&2=%@&3=%@&4=%@&5=%@&6=%@&7=%@&8=%@&9=%@&10=%@&11=%@&12=%@",[self.solarValueArrayNumkwh objectAtIndex:0],[self.solarValueArrayNumkwh objectAtIndex:1],[self.solarValueArrayNumkwh objectAtIndex:2],[self.solarValueArrayNumkwh objectAtIndex:3],[self.solarValueArrayNumkwh objectAtIndex:4],[self.solarValueArrayNumkwh objectAtIndex:5],[self.solarValueArrayNumkwh objectAtIndex:6],[self.solarValueArrayNumkwh objectAtIndex:7],[self.solarValueArrayNumkwh objectAtIndex:8],[self.solarValueArrayNumkwh objectAtIndex:9],[self.solarValueArrayNumkwh objectAtIndex:10],[self.solarValueArrayNumkwh objectAtIndex:11]];
        
        NSLog(@"%@",chartURL);
        NSURL *appleURL; appleURL =[ NSURL URLWithString:chartURL]; [self.chartViewer loadRequest:[ NSURLRequest requestWithURL: appleURL]];
        
        self.chartViewer.hidden = NO;

        self.loadingIconView.hidden=YES;
        self.resultsDrawer.hidden = NO;
        
    }
    
}

//this is the delegate method that gets called when GP fails
- (void) geoprocessor:(AGSGeoprocessor*) geoprocessor   operation:(NSOperation*) op didFailExecuteWithError:(NSError *)error{
    NSLog(@"Error: %@",error);
}


#pragma mark Default iOS Methods #pragma mark -
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
   
    if ([[segue identifier] isEqualToString:@"toReport"])
    {
        MapViewController *startVC;
        ReportViewController *destVC;
    
        startVC = (MapViewController *)segue.sourceViewController;
        destVC = (ReportViewController *)segue.destinationViewController;
    
        destVC.mainMapView = startVC;
    
        NSLog(@"LeavingSegueEUSA:%@",self.eusaFULL_NAME);
    }
     
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



- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    //gs = [[GCGeocodingService alloc] init];
    GCGeocodingService * myGC = [[GCGeocodingService alloc] init];
    NSString *address = searchBar.text;
    [myGC geocodeAddress:address];
    //Hide the keyboard
    /*[searchBar resignFirstResponder];
     
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
     */
    
}

- (IBAction)hideResultsDrawer:(id)sender {
    
    self.resultsDrawer.hidden = YES;
}
@end
