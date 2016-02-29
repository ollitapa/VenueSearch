//
//  ViewController.h
//  VenueSearch
//
//  Created by Olli Tapaninen on 27/02/16.
//  Copyright © 2016 Olli Tapaninen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VenueSearch.h"

@interface ViewController : UIViewController
    <UITableViewDelegate,
    UITableViewDataSource,
    VenueSearchDelegate,
    UISearchControllerDelegate>{
        
        // Venues are search by this object
        VenueSearch* venueSearch;
}

// Table view to represent the searched venues.
@property IBOutlet UITableView* tableView;

// Seach controller
@property UISearchController* searchController;


@end

