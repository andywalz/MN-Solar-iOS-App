//
//  BookmarksTableViewController.m
//  MN Solar App
//
//  Created by Andy Walz and Chris Martin on 11/2/14.
//  Copyright (c) 2014 MN Solar Suitability Team. All rights reserved.
//

#import "BookmarksTableViewController.h"
#import "DBManager.h"
#import "recordObjectConstructor.h"
#import "MapViewController.h"

@interface BookmarksTableViewController ()

@end

@implementation BookmarksTableViewController


@synthesize filteredRecords;
@synthesize recordSearchBar;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *test = [defaults objectForKey:@"defaultCompanyName"];
    
    NSLog(@"%@", test);
    
    test = [defaults objectForKey:@"defaultAddress"];
    
    NSLog(@"%@", test);
    
    test = [defaults objectForKey:@"defaultPhone"];
    
    NSLog(@"%@", test);
    
    // Starting Data to populate bookmarks list
    self.tableData = [NSMutableArray arrayWithObjects:
                      [recordObjectConstructor nameOfCategory:@"student" name:@"Andy Walz" address:@"1217 Matilda St, Saint Paul, MN 55117" lat:@"44.977928" lng:@"-93.112542"],
                 [recordObjectConstructor nameOfCategory:@"student" name:@"Chris Martin" address:@"730 Mercer St, Saint Paul, MN" lat:@"44.919174" lng:@"-93.136038"],
                 [recordObjectConstructor nameOfCategory:@"student" name:@"Katie Menk" address:@"2530 Cole Ave S, Minneapolis, MN" lat:@"44.985227" lng:@"-93.217008"],
                 [recordObjectConstructor nameOfCategory:@"student" name:@"Yuanyuan Luo" address:@"4631 Cedar Ave S, Minneapolis, MN" lat:@"44.918548" lng:@"-93.246990"],
                 [recordObjectConstructor nameOfCategory:@"student" name:@"Devon Piernot" address:@"5627 Louisiana Ave S, Minneapolis, MN" lat:@"44.928527" lng:@"-93.364558"],
                 [recordObjectConstructor nameOfCategory:@"student" name:@"Chris Brink" address:@"718 8th Ave SW, Rochester, MN" lat:@"44.015290" lng:@"-92.474415"],
                 [recordObjectConstructor nameOfCategory:@"student" name:@"Ian Xie" address:@"2320 W 5th St, Duluth, MN" lat:@"46.767713" lng:@"-92.132726"],
                 [recordObjectConstructor nameOfCategory:@"student" name:@"Chris Anderson" address:@"213 Lincoln Ave E, Karlstad, MN" lat:@"48.575961" lng:@"-96.516609"],
                 [recordObjectConstructor nameOfCategory:@"student" name:@"Andy Munsch" address:@"4035 W Broadway Ave, Robbinsdale, MN" lat:@"45.028230" lng:@"-93.336315"],
                 [recordObjectConstructor nameOfCategory:@"advisor" name:@"Len Kne" address:@"Blegen Hall" lat:@"44.971" lng:@"-93.243"],
                 [recordObjectConstructor nameOfCategory:@"advisor" name:@"Dan Thiede" address:@"3657 Whitetail Dr, Shakopee, MN" lat:@"44.764242" lng:@"-93.473607"],
                 [recordObjectConstructor nameOfCategory:@"installer" name:@"Jack Kluempke" address:@"119 Washington St NE, Brainerd, MN" lat:@"46.360089" lng:@"-94.187666"],
                 [recordObjectConstructor nameOfCategory:@"installer" name:@"Marty Morud" address:@"15719 Fox Cir, Apple Valley, MN" lat:@"44.722426" lng:@"-93.203853"],
                 nil];
    
    self.filteredRecords = [NSMutableArray arrayWithCapacity:[self.tableData count]];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
    
}

recordObjectConstructor *recordRow = nil;
recordObjectConstructor *recordToPrint = nil;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    
    // Check to see whether the normal table or search results table is being displayed and return the count from the appropriate array
    if (tableView == self.searchDisplayController.searchResultsTableView){
        return [filteredRecords count];
    } else {
        return [self.tableData count];
    }
    
    //NSLog(@"Made it to creating table count");
    //return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    //UITableView *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    self.cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];

    
    // Check to see whether the normal table or search results table is being displayed and set the record object from the appropriate array.
    
    if (tableView == self.searchDisplayController.searchResultsTableView){
        recordRow = [filteredRecords objectAtIndex:indexPath.row];
    } else {
        recordRow = [self.tableData objectAtIndex:indexPath.row];
    }
    
    self.cell.textLabel.text = recordRow.name;
    
    self.cell.detailTextLabel.text = recordRow.address;
    self.cell.imageView.image = [UIImage imageNamed:@"solar-app-transparent220x235.png"];
    
    self.cell.accessoryType =UITableViewCellAccessoryDetailDisclosureButton;
    
    return self.cell;
    
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //UIAlertView *messageAlert = [[UIAlertView alloc]initWithTitle:@"Row Selected" message:@"You've selected a row" delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:@"Cancel", nil];
    
    // Display alert
    //[messageAlert show];
    
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //cell.accessoryType =UITableViewCellAccessoryDetailDisclosureButton;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //Use this function instead of i icon
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    
    recordToPrint = [self.tableData objectAtIndex:indexPath.row];

    //NSLog(@"Address: %@, Lat: %@, Long: %@", recordToPrint.name, recordToPrint.lat, recordToPrint.lng);
    
    double doublelat = [recordToPrint.lat doubleValue];
    double doublelng = [recordToPrint.lng doubleValue];
    
    self.generalPoint = [AGSPoint pointWithX:doublelng y:doublelat spatialReference:[AGSSpatialReference wgs84SpatialReference]];
    
    //NSLog(@"%@", self.generalPoint);
    
    [self.mvc zoomToLocation:self.generalPoint];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        NSLog(@"1");
        [self.tableData removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source
        NSLog(@"2");
        int delRow = [self.tableData objectAtIndex:indexPath.row];
        NSLog(@"%i", delRow);
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    } 
}

#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [self.filteredRecords removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@",searchText];
    filteredRecords = [NSMutableArray arrayWithArray:[self.tableData filteredArrayUsingPredicate:predicate]];
    
}

#pragma mark - UISearchDisplayController Delegate Methods
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption{
    // Tells the table data source to reload when scope bar selection changes.
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    //Return YES to cause the search result table view to be reloaded
    return YES;
}

@end