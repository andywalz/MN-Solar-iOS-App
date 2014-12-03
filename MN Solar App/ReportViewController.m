//
//  ReportViewController.m
//  MN Solar App
//
//  Created by Andy Walz on 11/2/14.
//  Copyright (c) 2014 MN Solar Suitability Team. All rights reserved.
//

#import "settingsViewController.h"
#import "ReportViewController.h"
#import "MapViewController.h"

@interface ReportViewController () <AGSMapViewLayerDelegate>


- (IBAction)backToMap:(id)sender;
@property (weak, nonatomic) IBOutlet UIWebView *reportView;

@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    NSLog(@"%f",self.mainMapView.utm15Point.y);
    

    self.location.text = [NSString stringWithFormat:@"Lat: %f  Long: %f",self.mainMapView.wgsPoint.y, self.mainMapView.wgsPoint.x];
    
    NSLog(@"Lat: %f,%f",self.mainMapView.wgsPoint.y, self.mainMapView.wgsPoint.x);
   
    
    
    //Setup locator maps

    self.solarLocMap.hidden = NO;
 
    // set the delegate for the map view
    self.solarLocMap.layerDelegate = self;
 
    //zoom to an area
    AGSEnvelope *envelope = [AGSEnvelope envelopeWithXmin:(self.thePin.x - 200) ymin:(self.thePin.y - 200) xmax:(self.thePin.x + 200)  ymax:(self.thePin.y + 200)  spatialReference:self.solarLocMap.spatialReference];
    [self.solarLocMap zoomToEnvelope:envelope animated:NO];
   

    //add new layer
    AGSTiledMapServiceLayer* newBasemapLayer = [AGSTiledMapServiceLayer tiledMapServiceLayerWithURL:[NSURL URLWithString:@"http://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/"]];
 
    [self.solarLocMap insertMapLayer:newBasemapLayer withName:@"Basemap Tiled Layer" atIndex:0];

    //add solar layer
    AGSImageServiceLayer* solarLayer = [AGSImageServiceLayer imageServiceLayerWithURL: [NSURL URLWithString: @"http://us-dspatialgis.oit.umn.edu:6080/arcgis/rest/services/solar/Solar/ImageServer"]];
 
    [self.solarLocMap insertMapLayer:solarLayer withName:@"Solar Tiled Layer" atIndex:1];
 
    
    //add pin graphic
    
    [self.graphicsLayer removeAllGraphics];
    
    self.graphicsLayer = [AGSGraphicsLayer graphicsLayer];
    [self.solarLocMap addMapLayer:self.graphicsLayer withName:@"Graphics Layer"];
    
    AGSPictureMarkerSymbol* pushpin = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"bluepushpin"];
    pushpin.offset = CGPointMake(0,15);
    [pushpin setSize:CGSizeMake(20,30)];
    AGSSimpleRenderer* renderer = [AGSSimpleRenderer simpleRendererWithSymbol:pushpin];
    self.graphicsLayer.renderer = renderer;
    
    AGSPoint* myMarkerPoint =
    [AGSPoint pointWithX:self.thePin.x
                       y:self.thePin.y
        spatialReference:self.solarLocMap.spatialReference];
   
    //Create the Graphic, using the symbol and
    //geometry created earlier
    AGSGraphic* myGraphic =
    [AGSGraphic graphicWithGeometry:myMarkerPoint
                             symbol:pushpin
                         attributes:nil];
    
    //Add the graphic to the Graphics layer
    [self.graphicsLayer addGraphic:myGraphic];
    
   
    NSString *mapURL = [ NSString stringWithFormat:@"http://solar.maps.umn.edu/ios/locatormap.php?lat=%f&long=%f",self.mainMapView.wgsPoint.y,self.mainMapView.wgsPoint.x];
    
    
    NSURL *locWebMap; locWebMap =[ NSURL URLWithString:mapURL]; [self.locWebMap loadRequest:[ NSURLRequest requestWithURL:locWebMap]];
    
    self.locWebMap.hidden = NO;
    
    
    /*
    //Show report in webview
    NSString *rptURL = [ NSString stringWithFormat:@"http://solar.maps.umn.edu/report.php?lat=%f&long=%f",self.mainMapView.wgsPoint.y,self.mainMapView.wgsPoint.x];
    NSLog(@"%@",rptURL);
    
    NSURL *appleURL; appleURL =[ NSURL URLWithString:rptURL]; [self.reportView loadRequest:[ NSURLRequest requestWithURL: appleURL]];
    
    self.reportView.hidden = NO;
  */
    
    // Change value label using kwh array (float) as string value
    self.janVal.text = [[self.mainMapView.solarValueArrayNumkwh objectAtIndex:0] stringValue];
    self.febVal.text = [[self.mainMapView.solarValueArrayNumkwh objectAtIndex:1] stringValue];
    self.marVal.text = [[self.mainMapView.solarValueArrayNumkwh objectAtIndex:2] stringValue];
    self.aprVal.text = [[self.mainMapView.solarValueArrayNumkwh objectAtIndex:3] stringValue];
    self.mayVal.text = [[self.mainMapView.solarValueArrayNumkwh objectAtIndex:4] stringValue];
    self.junVal.text = [[self.mainMapView.solarValueArrayNumkwh objectAtIndex:5] stringValue];
    self.julVal.text = [[self.mainMapView.solarValueArrayNumkwh objectAtIndex:6] stringValue];
    self.augVal.text = [[self.mainMapView.solarValueArrayNumkwh objectAtIndex:7] stringValue];
    self.sepVal.text = [[self.mainMapView.solarValueArrayNumkwh objectAtIndex:8] stringValue];
    self.octVal.text = [[self.mainMapView.solarValueArrayNumkwh objectAtIndex:9] stringValue];
    self.novVal.text = [[self.mainMapView.solarValueArrayNumkwh objectAtIndex:10] stringValue];
    self.decVal.text = [[self.mainMapView.solarValueArrayNumkwh objectAtIndex:11] stringValue];
    
    
    self.janHr.text = [[self.mainMapView.solarHoursArrayNumFloat objectAtIndex:0] stringValue];
    self.febHr.text = [[self.mainMapView.solarHoursArrayNumFloat objectAtIndex:1] stringValue];
    self.marHr.text = [[self.mainMapView.solarHoursArrayNumFloat objectAtIndex:2] stringValue];
    self.aprHr.text = [[self.mainMapView.solarHoursArrayNumFloat objectAtIndex:3] stringValue];
    self.mayHr.text = [[self.mainMapView.solarHoursArrayNumFloat objectAtIndex:4] stringValue];
    self.junHr.text = [[self.mainMapView.solarHoursArrayNumFloat objectAtIndex:5] stringValue];
    self.julHr.text = [[self.mainMapView.solarHoursArrayNumFloat objectAtIndex:6] stringValue];
    self.augHr.text = [[self.mainMapView.solarHoursArrayNumFloat objectAtIndex:7] stringValue];
    self.sepHr.text = [[self.mainMapView.solarHoursArrayNumFloat objectAtIndex:8] stringValue];
    self.octHr.text = [[self.mainMapView.solarHoursArrayNumFloat objectAtIndex:9] stringValue];
    self.novHr.text = [[self.mainMapView.solarHoursArrayNumFloat objectAtIndex:10] stringValue];
    self.decHr.text = [[self.mainMapView.solarHoursArrayNumFloat objectAtIndex:11] stringValue];
    
    
    NSString *chartURL = [NSString stringWithFormat:@"http://solar.maps.umn.edu/ios/chart2.php?bg=FFFFFF&1=%@&2=%@&3=%@&4=%@&5=%@&6=%@&7=%@&8=%@&9=%@&10=%@&11=%@&12=%@",[self.mainMapView.solarValueArrayNumkwh objectAtIndex:0],[self.mainMapView.solarValueArrayNumkwh objectAtIndex:1],[self.mainMapView.solarValueArrayNumkwh objectAtIndex:2],[self.mainMapView.solarValueArrayNumkwh objectAtIndex:3],[self.mainMapView.solarValueArrayNumkwh objectAtIndex:4],[self.mainMapView.solarValueArrayNumkwh objectAtIndex:5],[self.mainMapView.solarValueArrayNumkwh objectAtIndex:6],[self.mainMapView.solarValueArrayNumkwh objectAtIndex:7],[self.mainMapView.solarValueArrayNumkwh objectAtIndex:8],[self.mainMapView.solarValueArrayNumkwh objectAtIndex:9],[self.mainMapView.solarValueArrayNumkwh objectAtIndex:10],[self.mainMapView.solarValueArrayNumkwh objectAtIndex:11]];
    
    NSString *monthlyHrsURL = [NSString stringWithFormat:@"http://solar.maps.umn.edu/ios/chart2.php?bg=FFFFFF&1=%@&2=%@&3=%@&4=%@&5=%@&6=%@&7=%@&8=%@&9=%@&10=%@&11=%@&12=%@",[self.mainMapView.solarHoursArrayNumFloat objectAtIndex:0],[self.mainMapView.solarHoursArrayNumFloat objectAtIndex:1],[self.mainMapView.solarHoursArrayNumFloat objectAtIndex:2],[self.mainMapView.solarHoursArrayNumFloat objectAtIndex:3],[self.mainMapView.solarHoursArrayNumFloat objectAtIndex:4],[self.mainMapView.solarHoursArrayNumFloat objectAtIndex:5],[self.mainMapView.solarHoursArrayNumFloat objectAtIndex:6],[self.mainMapView.solarHoursArrayNumFloat objectAtIndex:7],[self.mainMapView.solarHoursArrayNumFloat objectAtIndex:8],[self.mainMapView.solarHoursArrayNumFloat objectAtIndex:9],[self.mainMapView.solarHoursArrayNumFloat objectAtIndex:10],[self.mainMapView.solarHoursArrayNumFloat objectAtIndex:11]];
    
    NSURL *appleURL; appleURL =[ NSURL URLWithString:chartURL];
    NSURL *shURL; shURL =[ NSURL URLWithString:monthlyHrsURL];
    [self.monthInsWV loadRequest:[ NSURLRequest requestWithURL: appleURL]];
    
    [self.monthSunHrsWV loadRequest:[ NSURLRequest requestWithURL: shURL]];
    
    self.monthInsWV.hidden = NO;
    
    self.insolTotal.text = [self.mainMapView.totalInsVal stringValue];
    self.insolTotal2.text = [self.mainMapView.totalInsVal stringValue];
    
    NSString *solPot;
    
    if(self.mainMapView.totalInsVal.doubleValue / 365.0 >= 2.7){
        solPot = @"[ Optimal ]";
    }else if (self.mainMapView.totalInsVal.doubleValue / 365.0 >= 1.6){
        solPot = @"[ Good ]";
    }else{
        solPot = @"[ Poor ]";
    }
    
    self.solPotential.text = solPot;
    
    self.insolDaily.text = [NSString stringWithFormat:@"%0.3f", (self.mainMapView.totalInsVal.doubleValue / 365.0)];
    
    self.sunHrTotal.text = [self.mainMapView.totalHrsVal stringValue];
    self.sunHrTotal2.text = [self.mainMapView.totalHrsVal stringValue];

    self.sunHrDaily.text = [NSString stringWithFormat:@"%0.3f", (self.mainMapView.totalHrsVal.doubleValue / 365.0)];
    
    NSString *eusaContact = [NSString stringWithFormat:@"%@\r%@\r%@",self.mainMapView.eusaFULL_NAME,self.mainMapView.eusaPHONE,self.mainMapView.eusaWEBSITE];
    
    self.EUSA.text = eusaContact;
    NSLog(@"addr: %@",self.mainMapView.myAddress);
    
    if(self.mainMapView.myAddress==nil) {
        self.savedData.text = @"No address entered";
    }else{
        self.savedData.text = self.mainMapView.myAddress;
    }
    
}

//3. Implement the layer delegate method
- (void)mapViewDidLoad:(AGSMapView *) mapView {
    //do something now that the map is loaded
    //for example, show the current location on the map
    //[solarLocMap.locationDisplay startDataSource];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    
    if ([[segue identifier] isEqualToString:@"toSolValuePopover"])
    {
        ReportViewController *startVC;
        solValPopover *destVC;
        
        startVC = (ReportViewController *)segue.sourceViewController;
        destVC = (solValPopover *)segue.destinationViewController;
        
        destVC.solPotentialPopover = self.solPotential.text;
    }
    
}


- (IBAction)backToMap:(id)sender {
    
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
}
- (IBAction)installers:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://thecleanenergybuilder.com/directory#resultsType=both&page=0&pageNum=25&order=alphaTitle&proximityNum=60&proximityInput=&textInput=&textSearchTitle=1&textSearchDescription=1&field_established=&field_employees=&field_year=&reload=false&mapSize=large&allResults=false&tids2=&tids3=568&tids4=&tids5=&tids6="]];
}

- (IBAction)rebates:(id)sender {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.dsireusa.org/solar/incentives/index.cfm?re=1&ee=1&spv=1&st=0&srp=0&state=MN"]];
}

- (IBAction)solPotButton:(id)sender {
    [self performSegueWithIdentifier:@"toSolValPopover" sender:self];
}
@end
