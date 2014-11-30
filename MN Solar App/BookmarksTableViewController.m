//

//  BookmarksTableViewController.m

//  MN Solar App

//

//  Created by Andy Walz on 11/2/14.

//  Copyright (c) 2014 MN Solar Suitability Team. All rights reserved.

//



#import "BookmarksTableViewController.h"
#import "DBManager.h"
#import "recordObjectConstructor.h"

@interface BookmarksTableViewController ()

@end

@implementation BookmarksTableViewController

/*{
    
    NSArray *tableData;
    
}*/

@synthesize filteredRecords;
@synthesize recordSearchBar;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //tableData = [NSArray arrayWithObjects:@"Andy Walz", @"Chris Martin", @"Katie Menk", @"Yuanyuan Luo", @"Devon Piernot", @"Len Kne", @"Chris Brink", @"Dan Thiede", @"Jack Kluempke", @"Ian Xie", nil];
    
    self.tableData = [NSArray arrayWithObjects:
                      [recordObjectConstructor nameOfCategory:@"student" name:@"Andy Walz" address:@"1217 Matilda St, Saint Paul, MN 55117" lat:@"44.977928" lng:@"-93.112542"],
                 [recordObjectConstructor nameOfCategory:@"student" name:@"Chris Martin" address:@"730 Mercer St, Saint Paul, MN" lat:@"44.919174" lng:@"-93.136038"],
                 [recordObjectConstructor nameOfCategory:@"student" name:@"Katie Menk" address:@"125 Help St" lat:@"44.971" lng:@"-93.243"],
                 [recordObjectConstructor nameOfCategory:@"student" name:@"Yuanyuan Luo" address:@"Blegen Hall" lat:@"44.971" lng:@"-93.243"],
                 [recordObjectConstructor nameOfCategory:@"student" name:@"Devon Piernot" address:@"127 Help St" lat:@"44.971" lng:@"-93.243"],
                 [recordObjectConstructor nameOfCategory:@"student" name:@"Chris Brink" address:@"128 Help St" lat:@"44.971" lng:@"-93.243"],
                 [recordObjectConstructor nameOfCategory:@"student" name:@"Ian Xie" address:@"123 Help St" lat:@"44.971" lng:@"-93.243"],
                 [recordObjectConstructor nameOfCategory:@"student" name:@"Chris Anderson" address:@"123 Help St" lat:@"44.971" lng:@"-93.243"],
                 [recordObjectConstructor nameOfCategory:@"student" name:@"Andy Munsch" address:@"123 Help St" lat:@"44.971" lng:@"-93.243"],
                 [recordObjectConstructor nameOfCategory:@"advisor" name:@"Len Kne" address:@"123 Help St" lat:@"44.971" lng:@"-93.243"],
                 [recordObjectConstructor nameOfCategory:@"advisor" name:@"Dan Thiede" address:@"123 Help St" lat:@"44.971" lng:@"-93.243"],
                 [recordObjectConstructor nameOfCategory:@"installer" name:@"Jack Kluempke" address:@"123 Help St" lat:@"44.971" lng:@"-93.243"],
                 [recordObjectConstructor nameOfCategory:@"installer" name:@"Marty Morud" address:@"12345 Helping Rd" lat:@"44.971" lng:@"-93.243"],
                 nil];
    
    self.filteredRecords = [NSMutableArray arrayWithCapacity:[self.tableData count]];
    
    // Hide the search bar until user scrolls up
    /*CGRect newBounds = self.tableView.bounds;
    newBounds.origin.y = newBounds.origin.y + recordSearchBar.bounds.size.height;
    self.tableView.bounds = newBounds;
    
    //NSLog(@"%@", self.tableData);*/
    
    
    //NSString *selectSQL = @"SELECT * FROM student";
    
    /*const char *insert_stmt = [selectSQL UTF8String];
    if(sqlite3_prepare_v2(studentData, insert_stmt,  -1, &statement, NULL) == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            
            [arrFirstName addObject:[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 0)]];
            
            [arrMiddleName addObject:[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 1)]];
            
            [arrLastName addObject:[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 2)]];
            
            [arrContactNo addObject:[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 3)]];
            
        }
        
    }
    [tblStudent reloadData];*/

    
    // Uncomment the following line to preserve selection between presentations.
    
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
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
    
    /*if (self.cell == nil){
     
     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
     
     }*/
    
    // Check to see whether the normal table or search results table is being displayed and set the record object from the appropriate array.
    
    if (tableView == self.searchDisplayController.searchResultsTableView){
        recordRow = [filteredRecords objectAtIndex:indexPath.row];
    } else {
        recordRow = [self.tableData objectAtIndex:indexPath.row];
    }
    
    //self.cell.textLabel.text = [self.tableData objectAtIndex:indexPath.row];
    
    
    //recordRow = [self.tableData objectAtIndex:indexPath.row];
    self.cell.textLabel.text = recordRow.name;
    
    self.cell.detailTextLabel.text = recordRow.address;
    self.cell.imageView.image = [UIImage imageNamed:@"solar-app-transparent220x235.png"];
    
    self.cell.accessoryType =UITableViewCellAccessoryDetailDisclosureButton;
    
    //cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    return self.cell;
    
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //UIAlertView *messageAlert = [[UIAlertView alloc]initWithTitle:@"Row Selected" message:@"You've selected a row" delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:@"Cancel", nil];
    
    // Display alert
    //[messageAlert show];
    
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //cell.accessoryType =UITableViewCellAccessoryDetailDisclosureButton;
    
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    
    recordToPrint = [self.tableData objectAtIndex:indexPath.row];
    NSLog(@"You pressed the arrow!");
    NSLog(@"Address: %@, Lat: %@, Long: %@", recordToPrint.name, recordRow.lat, recordRow.lng);
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



/*
 
 #pragma mark - Navigation
 
 
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
 // Get the new view controller using [segue destinationViewController].
 
 // Pass the selected object to the new view controller.
 
 }
 
 */



@end