//

//  BookmarksTableViewController.m

//  MN Solar App

//

//  Created by Andy Walz on 11/2/14.

//  Copyright (c) 2014 MN Solar Suitability Team. All rights reserved.

//



#import "BookmarksTableViewController.h"
#import "DBManager.h"

@interface BookmarksTableViewController ()

@end

@implementation BookmarksTableViewController

{
    
    NSArray *tableData;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    tableData = [NSArray arrayWithObjects:@"Andy Walz", @"Chris Martin", @"Katie Menk", @"Yuanyuan Luo", @"Devon Piernot", @"Len Kne", @"Chris Brink", @"Dan Thiede", @"Jack Kluempke", @"Ian Xie", nil];
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    //UITableView *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    self.cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    
    /*if (self.cell == nil){
     
     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
     
     }*/
    
    self.cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    self.cell.detailTextLabel.text = @"User's Address Here";
    self.cell.imageView.image = [UIImage imageNamed:@"solar-app-transparent220x235.png"];
    
    //cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    return self.cell;
    
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //UIAlertView *messageAlert = [[UIAlertView alloc]initWithTitle:@"Row Selected" message:@"You've selected a row" delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:@"Cancel", nil];
    
    // Display alert
    //[messageAlert show];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"You pressed the arrow!");
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