//
//  VenueSearch.h
//  VenueSearch
//
//  Created by Olli Tapaninen on 27/02/16.
//  Copyright © 2016 Olli Tapaninen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

// Add your key here
#define CLIENT_ID @""
#define CLIENT_SECRET @""

@import CoreLocation;

// Delegate should update it's views when the search has finnished.
@protocol VenueSearchDelegate
- (void) searchFinished;
@end


/*
 Venues are searched from Forsquare.
 */
@interface VenueSearch : NSObject <UISearchResultsUpdating, CLLocationManagerDelegate>{
    // URL session to load searches
    NSURLSession *session;
    
}
// Results
@property NSMutableArray* searchResults;
// Location manager for retrieving user's location
@property (retain, nonatomic) CLLocationManager *locationManager;
// Current location of the user.
@property CLLocationCoordinate2D location;
// Delegate
@property NSObject <VenueSearchDelegate> *delegate;

@end

