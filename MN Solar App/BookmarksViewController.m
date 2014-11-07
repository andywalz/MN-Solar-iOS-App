//
//  BookmarksViewController.m
//  MN Solar App
//
//  Created by Yuanyuan Luo on 11/7/14.
//  Copyright (c) 2014 MN Solar Suitability Team. All rights reserved.
//

#import "BookmarksViewController.h"

@interface BookmarksViewController ()

@property (strong, nonatomic) NSArray *array;
@property (strong,nonatomic) NSArray *searchResults;

@end

@implementation BookmarksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.array = [[NSArray alloc] initWithObjects:@"Cameron	Skinner",@"Keith	Marshall",@"Peter	Wallace",@"Isaac	Mathis",@"Brian	Peake",@"Tracey	Terry",@"Apple",@"IBM",@"Kevin	Springer",@"Sophie	Bond",@"Dan	Abraham",@"i",@"Apple2",@"IBM2", nil];
    self.searchResults = [[NSArray alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Table View Methords
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==self.searchDisplayController.searchResultsTableView) {
        return [self.searchResults count];

    }
    else
        return [self.array count];
//    return [self.array count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (tableView==self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text=[self.searchResults objectAtIndex:indexPath.row];
    }
    else{
        cell.textLabel.text=[self.array objectAtIndex:indexPath.row];
    }
    
//    cell.textLabel.text=[self.array objectAtIndex:indexPath.row];
    return cell;
    
}


#pragma Search Methods

- (void) filterContentForSearchText:(NSString *) searchText scope:(NSString *)scope
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", searchText];
    self.searchResults = [self.array filteredArrayUsingPredicate:predicate];
}

- (bool) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles]objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
    
}

@end
