//
//  VenueSearch.m
//  VenueSearch
//
//  Created by Olli Tapaninen on 27/02/16.
//  Copyright © 2016 Olli Tapaninen. All rights reserved.
//

#import "VenueSearch.h"
#import "Venue.h"

@implementation VenueSearch


- (id)init {
    self = [super init];
    if (self) {
        
        // Init array of results
        _searchResults = [NSMutableArray arrayWithCapacity:0];
        
        // Init URL session
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        session = [NSURLSession sessionWithConfiguration: defaultConfigObject
                                                delegate: nil
                                           delegateQueue: [NSOperationQueue mainQueue]];
        
        // Allocate location manager and set delegate to self
        self.locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        
        // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [_locationManager requestWhenInUseAuthorization];
        }
        [_locationManager startUpdatingLocation];
    }
    
    return self;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
    // Search query from search bar
    NSString* query = searchController.searchBar.text;
    
    if ([query length] == 0) {
        return;
    }
    
    // Create the REST call string.
    NSURLComponents *components = [NSURLComponents
                                   componentsWithString:@"https://api.foursquare.com/v2/venues/search"];
    NSDictionary *queryDictionary = @{
        @"client_id": CLIENT_ID,
        @"client_secret": CLIENT_SECRET,
        @"ll": [NSString stringWithFormat:@"%f,%f",
                _location.latitude,_location.longitude],
        @"query": query,
        @"v": @"20130815",
        @"intent": @"browse",
        @"radius": @"1000"
        };
    
    NSMutableArray *queryItems = [NSMutableArray array];
    for (NSString *key in queryDictionary) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:queryDictionary[key]]];
    }
    components.queryItems = queryItems;
    
    
    // Start query wit dataTask
    [[session dataTaskWithURL: components.URL
            completionHandler:^(NSData *data, NSURLResponse *response,
                                            NSError *error) {
                //NSLog(@"Got response %@ with error %@.\n", response, error);
                //NSLog(@"DATA:\n%@\nEND DATA\n",
                //[[NSString alloc] initWithData: data
                //                      encoding: NSUTF8StringEncoding]);
                
                if (!error) {
                    NSError *localError = nil;
                    NSDictionary *parsedObject = [NSJSONSerialization
                                                  JSONObjectWithData:data
                                                  options:0
                                                  error:&localError];
                    
                    //NSLog(@"%@",parsedObject);
                    
                    // Get searched venues
                    NSArray *venues = [[parsedObject valueForKey:@"response"]
                                       valueForKey:@"venues"];
                    
                    // Remove previous results
                    [_searchResults removeAllObjects];
                    
                    if ([venues count] == 0) {
                        Venue *v = [[Venue alloc] init];
                        v.name = @"Nothing found";
                        [_searchResults addObject:v];
                    }
                    // Create Venue-data objects
                    for (NSDictionary *venueDict in venues) {
                        Venue *v = [[Venue alloc] init];
                        v.name = [venueDict valueForKey:@"name"];
                        v.distanceM = [[[venueDict valueForKey:@"location"]
                                      valueForKey:@"distance"] doubleValue];
                        v.address =[[venueDict valueForKey:@"location"]
                                    valueForKey:@"address"];
                        
                        [_searchResults addObject:v];
                    }
                    
                    // Tell delegate that the search is finnished
                    if ([_delegate respondsToSelector:
                         @selector(searchFinished)]) {
                        [_delegate searchFinished];
                    }
                    
                    
                }
                
                
            }]
     resume];


}



// Location Manager Delegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //NSLog(@"%@", [locations lastObject]);
    _location = [[locations lastObject] coordinate];
}


@end
