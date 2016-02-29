//
//  ViewController.m
//  VenueSearch
//
//  Created by Olli Tapaninen on 27/02/16.
//  Copyright © 2016 Olli Tapaninen. All rights reserved.
//

#import "ViewController.h"
#import "VenueCell.h"
#import "Venue.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Initiate search class for venues
    venueSearch = [[VenueSearch alloc]init];
    [venueSearch setDelegate:self];
    
    // Initiate Search controller
    _searchController = [[UISearchController alloc]
                         initWithSearchResultsController:nil];
    
    [_searchController setObscuresBackgroundDuringPresentation:false];
    
    // VenueSearch will update the search results.
    _searchController.searchResultsUpdater = venueSearch;
    _searchController.delegate = self;
    
    // Install the search bar as the table header.
    _tableView.tableHeaderView = _searchController.searchBar;
    
    // Nice background image
    UIImageView *bg = [[UIImageView alloc] initWithImage:
                       [UIImage imageNamed:@"backImage.png"]];
    [_tableView setBackgroundView:bg];
    [[_tableView backgroundView] setContentMode:UIViewContentModeScaleAspectFit];
   
    // It is usually good to set the presentation context.
    self.definesPresentationContext = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    // As many table cells as there are search results
    return [venueSearch.searchResults count];
}




- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Get reusable cell
    static NSString *MyIdentifier = @"ReusableVenueCellID";
    VenueCell *cell = (VenueCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[VenueCell alloc] initWithStyle:UITableViewCellStyleDefault
                                reuseIdentifier:MyIdentifier];
    }
    
    // Get the venue we want to represent
    Venue *v = [venueSearch.searchResults objectAtIndex:indexPath.row];

    cell.nameLabel.text = v.name;
    cell.distanceLabel.text = [NSString stringWithFormat:@"%.0f m", v.distanceM];
    cell.addressLabel.text = v.address;
    
    
    return cell;
}

- (void) searchFinished {
    // Sort the searched venues.
    //[venueSearch.searchResults sortUsingDescriptors:
    // @[[NSSortDescriptor sortDescriptorWithKey:@"distanceM" ascending:YES]]];
    
    // Reload tableview
    [_tableView reloadData];
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    
    // End search and remove all results
    [[venueSearch searchResults] removeAllObjects];
    [_tableView reloadData];
}

@end
