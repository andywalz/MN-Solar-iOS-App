//
//  ViewController.m
//  MN Solar App
//
//  Created by Andy Walz and Chris Martin on 11/1/14.
//  Copyright (c) 2014 MN Solar Suitability Team. All rights reserved.
//

#import "MapViewController.h"

@class ReportViewController;
@class GCGeocodingService;
@class solValPopover;

@interface MapViewController () <AGSMapViewLayerDelegate, AGSQueryTaskDelegate, AGSGeoprocessorDelegate>

// Private properties
@property (strong, nonatomic) IBOutlet UIWebView *chartViewer;
@property (strong, nonatomic) UIPopoverController *bmPopoverController;

// Private actions
- (IBAction)exitHere:(UIStoryboardSegue *)sender;
- (IBAction)swipeUpToReport:(id)sender;
- (IBAction)swipeDownCloseResults:(id)sender;

@end

@implementation MapViewController

// Variables
bool isHidden = YES;
GCGeocodingService * myGC;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.resultsDrawer.hidden=isHidden;
    self.loadingIconView.hidden=YES;
    self.solarOff.hidden = YES;
    
    // SHOW/HIDE DEBUG PANEL
    self.zoomIn.hidden = YES;
    self.zoomOut.hidden = YES;
    self.debugBackground.hidden = YES;
    self.debugLabel.hidden = YES;
    self.showResults.hidden = YES;
    self.logGeocode.hidden = YES;
    
    
    // Check for internet connection
    [self internetReachableFoo];
    
    // set the delegate for the map view
    self.mapView.layerDelegate = self;
    
    //add new layer
    AGSTiledMapServiceLayer* newBasemapLayer = [AGSTiledMapServiceLayer tiledMapServiceLayerWithURL:[NSURL URLWithString:@"http://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer"]];
    [self.mapView insertMapLayer:newBasemapLayer withName:@"Basemap Tiled Layer" atIndex:0];
    
    //zoom to an area
    self.defaultEnvelope = [AGSEnvelope envelopeWithXmin:-10874639 ymin:5330544 xmax:-9900890  ymax:6349425  spatialReference:self.mapView.spatialReference];
    [self.mapView zoomToEnvelope:self.defaultEnvelope animated:YES];
    
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
    
    //Chris: do we need this?
    // Create gesture recognizition
    UISwipeGestureRecognizer *oneFingerSwipeUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(oneFingerSwipeUp:)];
    
    [oneFingerSwipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [[self view] addGestureRecognizer:oneFingerSwipeUp];
    
}

-(void)oneFingerSwipeUp:(UITapGestureRecognizer *)recognizer
{
    //NSLog(@"Swiped up");
    
    //Chris: I may have implemented this in swipeUptoReport below, please delete if you agree
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
            //NSLog(@"Yayyy, we have the interwebs!");
        });
    };
    
    // Internet is not reachable
    self.internetReachableFoo.unreachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"ERROR: Network connection not available");
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
    
    //Store original mappoint for subclasses to access
    self.pin = mappoint;
    
    //Convert Web Mercator to UTM15 and WGS
    [self convertToUTM15:mappoint];
    [self convertToWGS:self.utm15Point];
    
    // Add graphics layer
    [self addPoint:mappoint];
    
    // Run query
    [self runQueries];

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
    
    //DSM Tile Name Query
    NSURL* dsmURL = [NSURL URLWithString: @"http://us-dspatialgis.oit.umn.edu:6080/arcgis/rest/services/solar/MN_DSM/ImageServer"];
    
    self.dsmqueryTask = [AGSQueryTask queryTaskWithURL:dsmURL];
    self.dsmqueryTask.delegate = self;
    self.dsmquery = [AGSQuery query];
    self.dsmquery.outFields = [NSArray arrayWithObjects:@"*", nil];
    self.dsmquery.geometry = self.utm15Point;
    self.dsmquery.returnGeometry = NO;
    self.dsmquery.whereClause = @"1=1";
    
    [self.dsmqueryTask executeWithQuery:self.dsmquery];
} //END runQueries

int warningMsgCount = 0;

// EUSA query successful
- (void) queryTask:(AGSQueryTask*)queryTask operation:(NSOperation *)op didExecuteWithFeatureSetResult:(AGSFeatureSet *)featureSet{
    
    //NSLog(@"Query successful");
    
    // Handle clicks outside of the state - Alert error and exit the method
    if ([featureSet.features count] == NULL){
        //NSLog(@"No features");
        if (warningMsgCount == 0){
            UIAlertView *noFeaturesError = [[UIAlertView alloc] initWithTitle:@"Selected outside of Minnesota" message:@"You must select a point within Minnesota" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [noFeaturesError show];
            warningMsgCount += 1;
        }else{
            warningMsgCount = 0;
        }
        return;
    }
    
    self.myFeature = [featureSet.features objectAtIndex:0];
    //NSLog(@"TTEST%@",self.myFeature);
    
    NSString *temp = [self.myFeature attributeAsStringForKey:@"Name"];

    NSString *uTemp = [self.myFeature attributeAsStringForKey:@"FULL_NAME"];
    
    if (!temp && !uTemp){
        //NSLog(@"No Data!");
        
    }else{
        
        if (!uTemp){
            self.dsmname = temp;
            
            // Error checking doesn't work, currently crashes outside MN
            //NSLog(@"DSMName: %@",self.dsmname);
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
            
            //NSLog(@"Name: %@, Phone: %@",self.eusaFULL_NAME, self.eusaPHONE);
            
        };
        
    }
    
    // NEEDS ERROR CHECKING - set variable in GCGeocoding
    [self gpTool];
    
} //END EUSA query success handler

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
    //NSLog(@"dsmquery");
}

// DSM query fail - CURRENTLY CRASHES APP WHEN FAIL
-(void)dsmqueryTask:(AGSQueryTask *)dsmqueryTask operation:(NSOperation *)op didFailWithError:(NSError *)error{
    //NSLog(@"dsmerror");
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


#pragma mark Geocoder and Locator Methods #pragma mark -

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

-(void) gpTool{
    
    //NSLog(@"DSM Name ===== %@", self.dsmname);
    //NSLog(@"IngpToolName: %@, Phone: %@",self.eusaFULL_NAME, self.eusaPHONE);
    
    self.loadingIconView.hidden=NO;
    
    NSString *fullTileName = [NSString stringWithFormat:@"%@.img", self.dsmname];
    
    NSURL* gpURL = [NSURL URLWithString: @"http://us-dspatialgis.oit.umn.edu:6080/arcgis/rest/services/solar/SolarPointQuery_fast/GPServer/Script"];
    
    // Build geoprocessor
    self.geoprocessor = [AGSGeoprocessor geoprocessorWithURL:gpURL];
    self.geoprocessor.delegate = self;
    
    // Geoprocessor build parameters
    AGSGPParameterValue *pointX = [AGSGPParameterValue parameterWithName:@"PointX" type:AGSGPParameterTypeDouble value:[NSNumber numberWithDouble:self.wgsPoint.x]];
    AGSGPParameterValue *pointY = [AGSGPParameterValue parameterWithName:@"PointY" type:AGSGPParameterTypeDouble value:[NSNumber numberWithDouble:self.wgsPoint.y]];
    AGSGPParameterValue *tile = [AGSGPParameterValue parameterWithName:@"File_Name" type:AGSGPParameterTypeString value:fullTileName];
    
    // GP Parameters to array
    NSArray *params = [NSArray arrayWithObjects:pointX, pointY,tile, nil];
    
    // Run GP tool as synch
    //NSLog(@"About to fire GP tool");
    [self.geoprocessor executeWithParameters:params];
    
} //END gpTool


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
            
            self.totalHrsVal = [NSNumber numberWithFloat:totalSunHrValue];
            self.maxHrs.text = [self.maxHrsVal stringValue];
            self.totalHrs.text = [self.totalHrsVal stringValue];
            self.dailyHrs.text = [NSString stringWithFormat:@"%0.3f", (self.totalHrsVal.doubleValue / 365.0)];
        };
        
        NSString *chartURL = [NSString stringWithFormat:@"http://solar.maps.umn.edu/ios/chart2.php?1=%@&2=%@&3=%@&4=%@&5=%@&6=%@&7=%@&8=%@&9=%@&10=%@&11=%@&12=%@",[self.solarValueArrayNumkwh objectAtIndex:0],[self.solarValueArrayNumkwh objectAtIndex:1],[self.solarValueArrayNumkwh objectAtIndex:2],[self.solarValueArrayNumkwh objectAtIndex:3],[self.solarValueArrayNumkwh objectAtIndex:4],[self.solarValueArrayNumkwh objectAtIndex:5],[self.solarValueArrayNumkwh objectAtIndex:6],[self.solarValueArrayNumkwh objectAtIndex:7],[self.solarValueArrayNumkwh objectAtIndex:8],[self.solarValueArrayNumkwh objectAtIndex:9],[self.solarValueArrayNumkwh objectAtIndex:10],[self.solarValueArrayNumkwh objectAtIndex:11]];
        
        //NSLog(@"%@",chartURL);
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


-(void)zoomToLocation:(AGSPoint *)point{
    
    AGSPoint *myPoint = (AGSPoint*) [[AGSGeometryEngine defaultGeometryEngine] projectGeometry:point toSpatialReference:[AGSSpatialReference webMercatorSpatialReference]];
    
    self.zoomToEnvelop = [AGSEnvelope envelopeWithXmin:myPoint.x- 200 ymin:myPoint.y - 200 xmax:myPoint.x + 200  ymax:myPoint.y + 200 spatialReference:self.mapView.spatialReference];
    
    [self convertToUTM15:myPoint];
    [self convertToWGS:myPoint];
    [self.mapView zoomToEnvelope:self.zoomToEnvelop animated:YES];
    [self addPoint:myPoint];
    [self runQueries];
}


#pragma mark Create Point #pragma mark -

-(void)addPoint:(AGSPoint*) mappoint{
    
    [self.myGraphicsLayer removeAllGraphics];

    self.myGraphicsLayer = [AGSGraphicsLayer graphicsLayer];
    [self.mapView addMapLayer:self.myGraphicsLayer withName:@"Graphics Layer"];
    
    AGSPictureMarkerSymbol* pushpin = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"bluepushpin"];
    
    pushpin.offset = CGPointMake(0,15);
    [pushpin setSize:CGSizeMake(20,30)];
    AGSSimpleRenderer* renderer = [AGSSimpleRenderer simpleRendererWithSymbol:pushpin];
    self.myGraphicsLayer.renderer = renderer;
    
    AGSPoint* myMarkerPoint =
    [AGSPoint pointWithX:mappoint.x
                       y:mappoint.y
        spatialReference:[AGSSpatialReference wgs84SpatialReference]];
    
    //NSLog(@"%@", myMarkerPoint);
    
    //Create the Graphic, using the symbol and geometry created earlier
    AGSGraphic* myGraphic =
    [AGSGraphic graphicWithGeometry:myMarkerPoint
                             symbol:pushpin
                         attributes:nil];
    
    //Add the graphic to the Graphics layer
    [self.myGraphicsLayer addGraphic:myGraphic];
    
}


#pragma mark Action and UI Methods #pragma mark -

// ---------------------------------
//  Action ano UI Methods
// ---------------------------------

- (IBAction)solarSwitchToggle:(id)sender {
    if ([self.solarSwitch isOn]){
        self.solarLayer.visible = YES;
        self.solarOff.hidden = YES;
        self.solarOn.hidden = NO;
    }else{
        self.solarLayer.visible = NO;
        self.solarOn.hidden = YES;
        self.solarOff.hidden = NO;
    }
}

- (bool) textFieldShouldReturn:(UITextField *)searchBar{
    [self.view endEditing:YES];
    [self geocodeSearch:(searchBar)];
    
    return YES;
}

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
    //NSLog(@"%@", address);
    [myGC geocodeAddress:address];
    
    //NSLog(@"Address: %@", myGC.geocodeResults[@"address"]);
    
    float x = [myGC.geocodeResults[@"lng"] floatValue];
    float y = [myGC.geocodeResults[@"lat"] floatValue];
    self.geocodePoint = [AGSPoint pointWithX:x
                                          y:y
                           spatialReference:[AGSSpatialReference wgs84SpatialReference]];
    self.geocodePointWeb = (AGSPoint*) [[AGSGeometryEngine defaultGeometryEngine] projectGeometry:self.geocodePoint toSpatialReference:[AGSSpatialReference webMercatorSpatialReference]];
    
    //NSLog(@"Trying to zoom!");
    
    self.zoomToEnvelop = [AGSEnvelope envelopeWithXmin:self.geocodePointWeb.x - 200 ymin:self.geocodePointWeb.y - 200 xmax:self.geocodePointWeb.x + 200  ymax:self.geocodePointWeb.y + 200 spatialReference:self.mapView.spatialReference];
    [self.mapView zoomToEnvelope:self.zoomToEnvelop animated:YES];
    
    [self addPoint:self.geocodePointWeb];
    
    [self convertToWGS:self.geocodePoint];
    [self convertToUTM15:self.geocodePoint];
    
    [self runQueries];
    
}

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

- (IBAction)goHomeButton:(id)sender {
    [self.mapView zoomToEnvelope:self.defaultEnvelope animated:YES];
    
}

- (IBAction)logGeocodeValue:(id)sender {
    //NSLog(@"%@", myGC.geocodeResults );
    //NSLog(@"Address: %@", myGC.geocodeResults[@"address"]);
}

- (IBAction)hideResultsDrawer:(id)sender {
    
    self.resultsDrawer.hidden = YES;
    
}
- (IBAction)findLocation:(id)sender {
    // Enable user location
    [self.mapView.locationDisplay startDataSource];
    //NSLog(@"%@",self.mapView.locationDisplay.mapLocation);
    self.zoomToEnvelop = [AGSEnvelope envelopeWithXmin:self.mapView.locationDisplay.mapLocation.x - 200 ymin:self.mapView.locationDisplay.mapLocation.y - 200 xmax:self.mapView.locationDisplay.mapLocation.x + 200  ymax:self.mapView.locationDisplay.mapLocation.y + 200 spatialReference:self.mapView.spatialReference];
    [self.mapView zoomToEnvelope:self.zoomToEnvelop animated:YES];
    
    [self addPoint:self.geocodePointWeb];
    
}

- (IBAction)swipeUpToReport:(id)sender {
    [self performSegueWithIdentifier:@"toReport" sender:self];
}

- (IBAction)swipeDownCloseResults:(id)sender {
    self.resultsDrawer.hidden = YES;
}


#pragma mark Default iOS Methods #pragma mark -
// ---------------------------------
//  DEFAULT FUNCTIONS
// ---------------------------------


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)exitHere:(UIStoryboardSegue *)sender {
    //Excute this code upon unwinding
    
    NSLog(@"%@",@"uwind function called");
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
   
    if ([[segue identifier] isEqualToString:@"toReport"])
    {
        MapViewController *startVC;
        ReportViewController *destVC;
    
        startVC = (MapViewController *)segue.sourceViewController;
        destVC = (ReportViewController *)segue.destinationViewController;
    
        destVC.mainMapView = startVC;
        destVC.thePin = self.pin;
    }
    
    if ([[segue identifier] isEqualToString:@"toBookmarksPopover"])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        
        self.bm = segue.destinationViewController;
        
        MapViewController *startVC;
        BookmarksTableViewController *destVC;
        
        startVC = (MapViewController *)segue.sourceViewController;
        destVC = (BookmarksTableViewController *)segue.destinationViewController;
        
        destVC.mvc = startVC;
    }
    
    if ([[segue identifier] isEqualToString:@"toMenuPopover"])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    if ([[segue identifier] isEqualToString:@"toSolValuePopover"])
    {
        MapViewController *startVC;
        solValPopover *destVC;
        
        startVC = (MapViewController *)segue.sourceViewController;
        destVC = (solValPopover *)segue.destinationViewController;
        
        destVC.solPotentialPopover = self.solPotential.text;
    }
    
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
   /* AGSPoint *bmPoint;
    bmPoint = ((BookmarksTableViewController *) popoverController.contentViewController).generalPoint; */
    NSLog(@"were back---%@",self.bm);
}

// ---------------------------------
//  SAVED CODE
// ---------------------------------

//Chris: Do we need this? Does not appear to be called
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


//Chris: Do we need this? Does not appear to be called
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    //gs = [[GCGeocodingService alloc] init];
    GCGeocodingService * myGC = [[GCGeocodingService alloc] init];
    NSString *address = searchBar.text;
    [myGC geocodeAddress:address];
    
    //Hide the keyboard
    //[searchBar resignFirstResponder];
}

@end
