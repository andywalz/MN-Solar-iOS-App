//

//  BookmarksTableViewController.h

//  MN Solar App

//

//  Created by Andy Walz and Chris Martin on 11/2/14.

//  Copyright (c) 2014 MN Solar Suitability Team. All rights reserved.

//



#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>

@class MapViewController;

@interface BookmarksTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) MapViewController *mvc;
@property (strong, nonatomic) UITableViewCell *cell;
@property (strong, nonatomic) NSArray *firstname;
@property (strong, nonatomic) NSArray *tableData;
@property (strong, nonatomic) NSMutableArray *filteredRecords;
@property (strong, nonatomic) AGSPoint *generalPoint;

@property (strong, nonatomic) IBOutlet UISearchBar *recordSearchBar;

@end

