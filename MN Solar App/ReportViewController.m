//
//  ReportViewController.m
//  MN Solar App
//
//  Created by Andy Walz on 11/2/14.
//  Copyright (c) 2014 MN Solar Suitability Team. All rights reserved.
//

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
    NSLog(@"%@",self.mainMapView);
    
    self.location.text = [NSString stringWithFormat:@"Lat: %f  Long: %f",self.mainMapView.wgsPoint.y, self.mainMapView.wgsPoint.x];
    
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
    
    NSLog(@"%@",self.mainMapView.solarHoursArray);
    
    self.janHr.text = [self.mainMapView.solarHoursArray objectAtIndex:0];
    self.febHr.text = [self.mainMapView.solarHoursArray objectAtIndex:1];
    self.marHr.text = [self.mainMapView.solarHoursArray objectAtIndex:2];
    self.aprHr.text = [self.mainMapView.solarHoursArray objectAtIndex:3];
    self.mayHr.text = [self.mainMapView.solarHoursArray objectAtIndex:4];
    self.junHr.text = [self.mainMapView.solarHoursArray objectAtIndex:5];
    self.julHr.text = [self.mainMapView.solarHoursArray objectAtIndex:6];
    self.augHr.text = [self.mainMapView.solarHoursArray objectAtIndex:7];
    self.sepHr.text = [self.mainMapView.solarHoursArray objectAtIndex:8];
    self.octHr.text = [self.mainMapView.solarHoursArray objectAtIndex:9];
    self.novHr.text = [self.mainMapView.solarHoursArray objectAtIndex:10];
    self.decHr.text = [self.mainMapView.solarHoursArray objectAtIndex:11];
    
    

    // set the delegate for the map view
    self.solarLocMap.layerDelegate = self;
    //self.satLocMap.layerDelegate = self;
    
    //add new layer
    AGSTiledMapServiceLayer* newBasemapLayerR = [AGSTiledMapServiceLayer tiledMapServiceLayerWithURL:[NSURL URLWithString:@"http://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer"]];
    [self.solarLocMap insertMapLayer:newBasemapLayerR withName:@"Basemap Tiled Layer" atIndex:0];
   // [self.satLocMap insertMapLayer:newBasemapLayerR withName:@"Basemap Tiled Layer" atIndex:0];
   
    //zoom to an area
    AGSEnvelope *envelopeR = [AGSEnvelope envelopeWithXmin:-10874639 ymin:5330544 xmax:-9900890  ymax:6349425  spatialReference:self.solarLocMap.spatialReference];
    
    [self.solarLocMap zoomToEnvelope:envelopeR animated:YES];
    //[self.satLocMap zoomToEnvelope:envelopeR animated:YES];
    
    
    /*
    NSLog(@"%@",self.mainMapView.solarLayer);

    
    [self.solarLocMap insertMapLayer:self.mainMapView.solarLayer withName:@"Solar Tiled Layer" atIndex:1];
    


 
    
    NSString *rptURL = [ NSString stringWithFormat:@"http://solar.maps.umn.edu/report.php?lat=%f&long=%f",self.mainMapView.wgsPoint.y,self.mainMapView.wgsPoint.x];
    NSLog(@"%@",rptURL);
    
    NSURL *appleURL; appleURL =[ NSURL URLWithString:rptURL]; [self.reportView loadRequest:[ NSURLRequest requestWithURL: appleURL]];
    
    self.reportView.hidden = NO;
  */
    /*
    
    NSString *chartURL = [NSString stringWithFormat:@"http://solar.maps.umn.edu/ios/chart2.php?1=%@&2=%@&3=%@&4=%@&5=%@&6=%@&7=%@&8=%@&9=%@&10=%@&11=%@&12=%@",[self.mainMapView.solarValueArrayNumkwh objectAtIndex:0],[self.mainMapView.solarValueArrayNumkwh objectAtIndex:1],[self.mainMapView.solarValueArrayNumkwh objectAtIndex:2],[self.mainMapView.solarValueArrayNumkwh objectAtIndex:3],[self.mainMapView.solarValueArrayNumkwh objectAtIndex:4],[self.mainMapView.solarValueArrayNumkwh objectAtIndex:5],[self.mainMapView.solarValueArrayNumkwh objectAtIndex:6],[self.mainMapView.solarValueArrayNumkwh objectAtIndex:7],[self.mainMapView.solarValueArrayNumkwh objectAtIndex:8],[self.mainMapView.solarValueArrayNumkwh objectAtIndex:9],[self.mainMapView.solarValueArrayNumkwh objectAtIndex:10],[self.mainMapView.solarValueArrayNumkwh objectAtIndex:11]];
    
    NSString *monthlyHrsURL = [NSString stringWithFormat:@"http://solar.maps.umn.edu/ios/chart2.php?1=%@&2=%@&3=%@&4=%@&5=%@&6=%@&7=%@&8=%@&9=%@&10=%@&11=%@&12=%@",[self.mainMapView.solarHoursArrayNumFloat objectAtIndex:0],[self.mainMapView.solarHoursArrayNumFloat objectAtIndex:1],[self.mainMapView.solarHoursArrayNumFloat objectAtIndex:2],[self.mainMapView.solarHoursArrayNumFloat objectAtIndex:3],[self.mainMapView.solarHoursArrayNumFloat objectAtIndex:4],[self.mainMapView.solarHoursArrayNumFloat objectAtIndex:5],[self.mainMapView.solarHoursArrayNumFloat objectAtIndex:6],[self.mainMapView.solarHoursArrayNumFloat objectAtIndex:7],[self.mainMapView.solarHoursArrayNumFloat objectAtIndex:8],[self.mainMapView.solarHoursArrayNumFloat objectAtIndex:9],[self.mainMapView.solarHoursArrayNumFloat objectAtIndex:10],[self.mainMapView.solarHoursArrayNumFloat objectAtIndex:11]];
    
    NSLog(@"%@",chartURL);
    NSURL *appleURL; appleURL =[ NSURL URLWithString:chartURL];
    NSURL *shURL; shURL =[ NSURL URLWithString:monthlyHrsURL];
    [self.monthInsWV loadRequest:[ NSURLRequest requestWithURL: appleURL]];
    
    [self.monthSunHrsWV loadRequest:[ NSURLRequest requestWithURL: shURL]];
    
    self.monthInsWV.hidden = NO;
    */
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backToMap:(id)sender {
    
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
}
@end
