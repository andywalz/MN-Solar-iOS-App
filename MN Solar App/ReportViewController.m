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
    
    // set the delegate for the map view
    self.solarLocMap.layerDelegate = self;
    self.satLocMap.layerDelegate = self;
    
    //add new layer
    AGSTiledMapServiceLayer* newBasemapLayer = [AGSTiledMapServiceLayer tiledMapServiceLayerWithURL:[NSURL URLWithString:@"http://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer"]];
    [self.solarLocMap insertMapLayer:newBasemapLayer withName:@"Basemap Tiled Layer" atIndex:0];
     [self.satLocMap insertMapLayer:newBasemapLayer withName:@"Basemap Tiled Layer" atIndex:0];
   
    //zoom to an area
    AGSEnvelope *envelope = [AGSEnvelope envelopeWithXmin:-10874639 ymin:5330544 xmax:-9900890  ymax:6349425  spatialReference:self.solarLocMap.spatialReference];
    
    [self.solarLocMap zoomToEnvelope:envelope animated:YES];
    [self.satLocMap zoomToEnvelope:envelope animated:YES];
    
    /*
    NSLog(@"%@",self.mainMapView.solarLayer);

    
    [self.solarLocMap insertMapLayer:self.mainMapView.solarLayer withName:@"Solar Tiled Layer" atIndex:1];
    


 
    
    NSString *rptURL = [ NSString stringWithFormat:@"http://solar.maps.umn.edu/report.php?lat=%f&long=%f",self.mainMapView.wgsPoint.y,self.mainMapView.wgsPoint.x];
    NSLog(@"%@",rptURL);
    
    NSURL *appleURL; appleURL =[ NSURL URLWithString:rptURL]; [self.reportView loadRequest:[ NSURLRequest requestWithURL: appleURL]];
    
    self.reportView.hidden = NO;
  */
    
    
    NSString *chartURL = [NSString stringWithFormat:@"http://solar.maps.umn.edu/ios/chart2.php?1=%@&2=%@&3=%@&4=%@&5=%@&6=%@&7=%@&8=%@&9=%@&10=%@&11=%@&12=%@",[self.mainMapView.solarValueArrayNumkwh objectAtIndex:0],[self.mainMapView.solarValueArrayNumkwh objectAtIndex:1],[self.mainMapView.solarValueArrayNumkwh objectAtIndex:2],[self.mainMapView.solarValueArrayNumkwh objectAtIndex:3],[self.mainMapView.solarValueArrayNumkwh objectAtIndex:4],[self.mainMapView.solarValueArrayNumkwh objectAtIndex:5],[self.mainMapView.solarValueArrayNumkwh objectAtIndex:6],[self.mainMapView.solarValueArrayNumkwh objectAtIndex:7],[self.mainMapView.solarValueArrayNumkwh objectAtIndex:8],[self.mainMapView.solarValueArrayNumkwh objectAtIndex:9],[self.mainMapView.solarValueArrayNumkwh objectAtIndex:10],[self.mainMapView.solarValueArrayNumkwh objectAtIndex:11]];
    
    NSLog(@"%@",chartURL);
    NSURL *appleURL; appleURL =[ NSURL URLWithString:chartURL];
    
    [self.monthInsWV loadRequest:[ NSURLRequest requestWithURL: appleURL]];
    
    [self.monthSunHrsWV loadRequest:[ NSURLRequest requestWithURL: appleURL]];
    
    self.monthInsWV.hidden = NO;
    
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
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
