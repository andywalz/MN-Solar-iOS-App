//
//  ReportViewController.m
//  MN Solar App
//
//  Created by Andy Walz on 11/2/14.
//  Copyright (c) 2014 MN Solar Suitability Team. All rights reserved.
//

#import "ReportViewController.h"

@interface ReportViewController () <AGSMapViewLayerDelegate>

- (IBAction)backToMap:(id)sender;
@property (weak, nonatomic) IBOutlet UIWebView *reportView;

@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.thePin =
    
    NSString * myurl = [NSString stringWithFormat:@"http://solar.maps.umn.edu/ios/index.html?lat=%f&long=%f",self.thePin.y,self.thePin.x];
    
    NSLog(@"%@",myurl);
    
    NSURL *appleURL; appleURL =[ NSURL URLWithString:myurl]; [_reportView loadRequest:[ NSURLRequest requestWithURL: appleURL]];
    
    self.reportView.hidden = NO;
    
    //AGSPoint *mypin = ((MapViewController *)self.presentingViewController).pin;
    
    NSLog(@"%f", self.thePin.x);
    
// NSString *html = [self.reportWeb stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"];
    
//   NSLog(@"%@",html);
    self.minSolarMap.hidden = NO;
    
    
    // set the delegate for the map view
    self.minSolarMap.layerDelegate = self;
    
    //zoom to an area
    AGSEnvelope *envelope = [AGSEnvelope envelopeWithXmin:(self.thePin.x - 200) ymin:(self.thePin.y - 200) xmax:(self.thePin.x + 200)  ymax:(self.thePin.y - 200)  spatialReference:self.minSolarMap.spatialReference];
    [self.minSolarMap zoomToEnvelope:envelope animated:NO];
    
    //add new layer
    AGSTiledMapServiceLayer* newBasemapLayer = [AGSTiledMapServiceLayer tiledMapServiceLayerWithURL:[NSURL URLWithString:@"http://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/"]];
     
    [self.minSolarMap insertMapLayer:newBasemapLayer withName:@"Basemap Tiled Layer" atIndex:0];
    
    //add solar layer
    AGSImageServiceLayer* solarLayer = [AGSImageServiceLayer imageServiceLayerWithURL: [NSURL URLWithString: @"http://us-dspatialgis.oit.umn.edu:6080/arcgis/rest/services/solar/Solar/ImageServer"]];
    
    [self.minSolarMap insertMapLayer:solarLayer withName:@"Solar Tiled Layer" atIndex:1];
    
    // Add graphics layer
    //[MapViewController addPoint:self.thePin];
    
    /* set the delegate for the map view
    self.minimapView.layerDelegate = self;
    
    //add new layer
    AGSTiledMapServiceLayer* newBasemapLayer = [AGSTiledMapServiceLayer tiledMapServiceLayerWithURL:[NSURL URLWithString:@"http://services.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer"]];
    [self.minimapView insertMapLayer:newBasemapLayer withName:@"Basemap Tiled Layer" atIndex:0];
    
    //zoom to an area
    AGSEnvelope *envelope = [AGSEnvelope envelopeWithXmin:-10874639 ymin:5330544 xmax:-9900890  ymax:6349425  spatialReference:self.minimapView.spatialReference];
    [self.minimapView zoomToEnvelope:envelope animated:YES];
    
    //add solar layer
    NSURL* url = [NSURL URLWithString: @"http://us-dspatialgis.oit.umn.edu:6080/arcgis/rest/services/solar/Solar/ImageServer"];
    AGSImageServiceLayer* solarLayer = [AGSImageServiceLayer imageServiceLayerWithURL: url];
    
    [self.minimapView insertMapLayer:solarLayer withName:@"Solar Tiled Layer" atIndex:1];
    */
    //create an instance of a tiled map service layer
    /*AGSTiledMapServiceLayer *tiledLayer = [[AGSTiledMapServiceLayer alloc] initWithURL:[NSURL URLWithString:@"http://services.arcgisonline.com/ArcGIS/rest/services/Canvas/World_Light_Gray_Base/MapServer"]];*/
    
    //Add it to the map view
    //[self.mapView addMapLayer:tiledLayer withName:@"Tiled Layer"];
    
    //Set the touch delegate so we can respond when user taps on the map
    //self.minimapView.touchDelegate = self;
    
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
