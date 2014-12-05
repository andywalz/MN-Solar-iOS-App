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
#import "ReportSaveFormViewController.h"

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
    AGSEnvelope *envelope = [AGSEnvelope envelopeWithXmin:(self.thePin.x - 120) ymin:(self.thePin.y - 120) xmax:(self.thePin.x + 120)  ymax:(self.thePin.y + 120)  spatialReference:self.solarLocMap.spatialReference];
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
    
   //NSString *test = [[self.mainMapView.solarValueArrayNumkwh objectAtIndex:6] stringValue];
    
    self.janVal.text = [ NSString stringWithFormat:@"%.2f",[[self.mainMapView.solarValueArrayNumkwh objectAtIndex:0] floatValue]];
    self.febVal.text = [ NSString stringWithFormat:@"%.2f",[[self.mainMapView.solarValueArrayNumkwh objectAtIndex:1] floatValue]];
    self.marVal.text = [ NSString stringWithFormat:@"%.2f",[[self.mainMapView.solarValueArrayNumkwh objectAtIndex:2] floatValue]];
    self.aprVal.text = [ NSString stringWithFormat:@"%.2f",[[self.mainMapView.solarValueArrayNumkwh objectAtIndex:3] floatValue]];
    self.mayVal.text = [ NSString stringWithFormat:@"%.2f",[[self.mainMapView.solarValueArrayNumkwh objectAtIndex:4] floatValue]];
    self.junVal.text = [ NSString stringWithFormat:@"%.2f",[[self.mainMapView.solarValueArrayNumkwh objectAtIndex:5] floatValue]];
    self.julVal.text = [ NSString stringWithFormat:@"%.2f",[[self.mainMapView.solarValueArrayNumkwh objectAtIndex:6] floatValue]];
    self.augVal.text = [ NSString stringWithFormat:@"%.2f",[[self.mainMapView.solarValueArrayNumkwh objectAtIndex:7] floatValue]];
    self.sepVal.text = [ NSString stringWithFormat:@"%.2f",[[self.mainMapView.solarValueArrayNumkwh objectAtIndex:8] floatValue]];
    self.octVal.text = [ NSString stringWithFormat:@"%.2f",[[self.mainMapView.solarValueArrayNumkwh objectAtIndex:9] floatValue]];
    self.novVal.text = [ NSString stringWithFormat:@"%.2f",[[self.mainMapView.solarValueArrayNumkwh objectAtIndex:10] floatValue]];
    self.decVal.text = [ NSString stringWithFormat:@"%.2f",[[self.mainMapView.solarValueArrayNumkwh objectAtIndex:11] floatValue]];
    
    
    self.janHr.text = [ NSString stringWithFormat:@"%.2f",[[self.mainMapView.solarHoursArrayNumFloat objectAtIndex:0] floatValue]];
    self.febHr.text = [ NSString stringWithFormat:@"%.2f",[[self.mainMapView.solarHoursArrayNumFloat objectAtIndex:1] floatValue]];
    self.marHr.text = [ NSString stringWithFormat:@"%.2f",[[self.mainMapView.solarHoursArrayNumFloat objectAtIndex:2] floatValue]];
    self.aprHr.text = [ NSString stringWithFormat:@"%.2f",[[self.mainMapView.solarHoursArrayNumFloat objectAtIndex:3] floatValue]];
    self.mayHr.text = [ NSString stringWithFormat:@"%.2f",[[self.mainMapView.solarHoursArrayNumFloat objectAtIndex:4] floatValue]];
    self.junHr.text = [ NSString stringWithFormat:@"%.2f",[[self.mainMapView.solarHoursArrayNumFloat objectAtIndex:5] floatValue]];
    self.julHr.text = [ NSString stringWithFormat:@"%.2f",[[self.mainMapView.solarHoursArrayNumFloat objectAtIndex:6] floatValue]];
    self.augHr.text = [ NSString stringWithFormat:@"%.2f",[[self.mainMapView.solarHoursArrayNumFloat objectAtIndex:7] floatValue]];
    self.sepHr.text = [ NSString stringWithFormat:@"%.2f",[[self.mainMapView.solarHoursArrayNumFloat objectAtIndex:8] floatValue]];
    self.octHr.text = [ NSString stringWithFormat:@"%.2f",[[self.mainMapView.solarHoursArrayNumFloat objectAtIndex:9] floatValue]];
    self.novHr.text = [ NSString stringWithFormat:@"%.2f",[[self.mainMapView.solarHoursArrayNumFloat objectAtIndex:10] floatValue]];
    self.decHr.text = [ NSString stringWithFormat:@"%.2f",[[self.mainMapView.solarHoursArrayNumFloat objectAtIndex:11] floatValue]];
    
    
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
        self.savedData.text = @"";
    }else{
        self.savedData.text = self.mainMapView.myAddress;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.companyName.text = [defaults objectForKey:@"defaultCompanyName"];
    self.installerContact.text = [defaults objectForKey:@"defaultContactName"];
    self.installerAddress.text = [defaults objectForKey:@"defaultAddress"];
    
    NSString *city = [defaults objectForKey:@"defaultCity"];
    NSString *state = [defaults objectForKey:@"defaultState"];
    NSString *zip = [defaults objectForKey:@"defaultZip"];
    NSString *citystatezip  = [NSString stringWithFormat:@"%@, %@ %@", city, state, zip];
    NSString *phone = [defaults objectForKey:@"defaultPhone"];
    NSString *email = [defaults objectForKey:@"defaultEmail"];
    
    //NSString *phoneemail  = [NSString stringWithFormat:@"%@ - %@", phone, email];
    
    self.installerCityStateZip.text = citystatezip;
    self.installerPhoneEmail.text = phone;
    self.installerEmail.text = email;
    
    
    
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
    
    if ([[segue identifier] isEqualToString:@"toSaveReport"])
    {
        ReportViewController *startVC;
        ReportSaveFormViewController *destVC;
        
        startVC = (ReportViewController *)segue.sourceViewController;
        destVC = (ReportSaveFormViewController *)segue.destinationViewController;
        
        destVC.myReport = startVC;
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

- (IBAction)mailReport:(id)sender {
    
    self.reportToolbar.hidden = YES;
    self.view.layer.backgroundColor = [UIColor whiteColor].CGColor;
    
    /*/Screenshot of report
    UIGraphicsBeginImageContext(self.view.bounds.size);
    CGContextRef myref = UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:myref];
    [self.solarLocMap.layer renderInContext:myref];
    UIImage *screenshotimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //UIImageWriteToSavedPhotosAlbum(screenshotimage, nil, nil, nil);
    
     */
    CGSize imageSize = CGSizeZero;
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        imageSize = [UIScreen mainScreen].bounds.size;
    } else {
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    }
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft) {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        } else if (orientation == UIInterfaceOrientationLandscapeRight) {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        } else {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *screenshotimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
     
    NSData *mydata = UIImageJPEGRepresentation(screenshotimage,1);
    
     
     
    // Email Subject
    NSString *emailTitle = @"Solar Suitability Report";
    // Email Content
    
   //NSString *messageBody = [ NSString stringWithFormat:@"<h2><img style='float:left; padding-right:10px;' src='http://solar.maps.umn.edu/assets/img/solar-app-transparent220x235.png' height='165' alt='MN Solar Logo'/>Minnesota Solar Suitability Location Report</h2><p><b>Latitude</b>: %f <b>Longitude:</b> %f<br><b>Address:</b> <a href='http://solar.maps.umn.edu/app/index.html?lat=%f&long=%f'>%@</a></p> <p><b>Total Insolation per Year:</b> %@ kWh/m<sup>2</sup><br /><b>Avg per Day:</b> %@ kWh/m<sup>2</sup></p><p><a href='http://solar.maps.umn.edu/report.php?z=55401&w=www.xcelenergy.com&long=%f&lat=%f&y=%@&u=%@'>Click here to view your complete report</a></p>",self.mainMapView.wgsPoint.y, self.mainMapView.wgsPoint.x, self.mainMapView.wgsPoint.y, self.mainMapView.wgsPoint.x, self.savedData.text, self.mainMapView.totalInsVal, self.insolDaily.text, self.mainMapView.wgsPoint.x,self.mainMapView.wgsPoint.y, self.mainMapView.totalInsVal, [self.EUSA.text  stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
    
    NSString *messageBody = @"Your solar suitability report is attached below. For more information visit: <a href='http://solar.maps.umn.edu/'>solar.maps.umn.edu</a>.";
    
    // To address
    //NSArray *toRecipents = [NSArray arrayWithObject:@"support@appcoda.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:YES];
    //[mc setToRecipients:toRecipents];
    
    
    [mc addAttachmentData:mydata  mimeType:@"image/jpeg" fileName:@"YourSolarReport.jpg"];
    
    self.reportToolbar.hidden = NO;
    self.view.layer.backgroundColor = [UIColor darkGrayColor].CGColor;
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
