//
//  MenuTableViewController.m
//  MN Solar App
//
//  Created by Andy Walz on 11/2/14.
//  Copyright (c) 2014 MN Solar Suitability Team. All rights reserved.
//

#import "MenuTableViewController.h"

@interface MenuTableViewController () <UIPopoverControllerDelegate>

@end

@implementation MenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if(self.mainMapVC.layerCountiesStatus==nil){
        self.layerCounties.text = @"( ) MN Counties";
    }else{
        self.layerCounties.text = self.mainMapVC.layerCountiesStatus;
    }
    
    if(self.mainMapVC.layerEUSAStatus==nil){
        self.layerEUSA.text = @"( ) Utility Service Areas";
    }else{
        self.layerEUSA.text = self.mainMapVC.layerEUSAStatus;
    }
    
    if(self.mainMapVC.layerSolarInstallsStatus==nil){
        self.layerSolarInstalls.text = @"( ) Existing Solar Installations";
    }else{
        self.layerSolarInstalls.text = self.mainMapVC.layerSolarInstallsStatus;
    }
    
    if(self.mainMapVC.layerTilesStatus==nil){
        self.layerTiles.text = @"( ) Lakes & Rivers";
    }else{
        self.layerTiles.text = self.mainMapVC.layerTilesStatus;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"toMenuPopover"]) {
        ((UIStoryboardPopoverSegue*)segue).popoverController.delegate = self;
    }

}


- (IBAction)toggleCounties:(id)sender {
    
    if ([self.layerCounties.text containsString:@"(X)"]) {
        [self.mainMapVC.mapView removeMapLayerWithName:@"MN Counties"];
        self.layerCounties.text = @"( ) MN Counties";
        self.mainMapVC.layerCountiesStatus = @"( ) MN Counties";
    } else {
        NSURL *featureLayerURL = [NSURL URLWithString:@"http://us-dspatialgis.oit.umn.edu:6080/arcgis/rest/services/solar/MN_Solar_Vector/MapServer/4"];
        AGSFeatureLayer *featureLayer = [AGSFeatureLayer featureServiceLayerWithURL:featureLayerURL mode:AGSFeatureLayerModeOnDemand];
    
        [self.mainMapVC.mapView addMapLayer:featureLayer withName:@"MN Counties"];
        self.layerCounties.text = @"(X) MN Counties";
        self.mainMapVC.layerCountiesStatus = @"(X) MN Counties";
     }
}

- (IBAction)toggleEUSA:(id)sender {
    if ([self.layerEUSA.text containsString:@"(X)"]) {
        [self.mainMapVC.mapView removeMapLayerWithName:@"EUSA"];
        self.layerEUSA.text = @"( ) Utility Service Areas";
        self.mainMapVC.layerCountiesStatus = self.layerEUSA.text;
    } else {
        NSURL *featureLayerURL = [NSURL URLWithString:@"http://us-dspatialgis.oit.umn.edu:6080/arcgis/rest/services/solar/MN_Solar_Vector/MapServer/2"];
        AGSFeatureLayer *featureLayer = [AGSFeatureLayer featureServiceLayerWithURL:featureLayerURL mode:AGSFeatureLayerModeOnDemand];
        
        [self.mainMapVC.mapView addMapLayer:featureLayer withName:@"EUSA"];
        self.layerEUSA.text = @"(X) Utility Service Areas";
        self.mainMapVC.layerEUSAStatus = self.layerEUSA.text;
    }
}

- (IBAction)toggleSolarInstalls:(id)sender {
    if ([self.layerSolarInstalls.text containsString:@"(X)"]) {
        [self.mainMapVC.mapView removeMapLayerWithName:@"SolarInstalls"];
        self.layerSolarInstalls.text = @"( ) Existing Solar Installations";
        self.mainMapVC.layerSolarInstallsStatus = self.layerSolarInstalls.text;
    } else {
        NSURL *featureLayerURL = [NSURL URLWithString:@"http://us-dspatialgis.oit.umn.edu:6080/arcgis/rest/services/solar/MN_Solar_Vector/MapServer/0"];
        AGSFeatureLayer *featureLayer = [AGSFeatureLayer featureServiceLayerWithURL:featureLayerURL mode:AGSFeatureLayerModeOnDemand];
        
        [self.mainMapVC.mapView addMapLayer:featureLayer withName:@"SolarInstalls"];
        self.layerSolarInstalls.text = @"(X) Existing Solar Installations";
        self.mainMapVC.layerSolarInstallsStatus = self.layerSolarInstalls.text;
    }
}

- (IBAction)toggleTiles:(id)sender {
    if ([self.layerTiles.text containsString:@"(X)"]) {
        [self.mainMapVC.mapView removeMapLayerWithName:@"Water"];
        self.layerTiles.text = @"( ) Lakes & Rivers";
        self.mainMapVC.layerTilesStatus = self.layerTiles.text;
    } else {
        NSURL *featureLayerURL = [NSURL URLWithString:@"http://us-dspatialgis.oit.umn.edu:6080/arcgis/rest/services/solar/MN_Solar_Vector/MapServer/1"];
        AGSFeatureLayer *featureLayer = [AGSFeatureLayer featureServiceLayerWithURL:featureLayerURL mode:AGSFeatureLayerModeOnDemand];
        
        [self.mainMapVC.mapView addMapLayer:featureLayer withName:@"Water"];
        self.layerTiles.text = @"(X) Lakes & Rivers";
        self.mainMapVC.layerTilesStatus = self.layerTiles.text;
    }
}
@end
