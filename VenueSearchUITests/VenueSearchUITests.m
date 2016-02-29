//
//  VenueSearchUITests.m
//  VenueSearchUITests
//
//  Created by Olli Tapaninen on 27/02/16.
//  Copyright © 2016 Olli Tapaninen. All rights reserved.
//

#import <XCTest/XCTest.h>
@import CoreLocation;

@interface VenueSearchUITests : XCTestCase


@end



@implementation VenueSearchUITests

- (void)setUp {
    [super setUp];
    

    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSearchCancel {
    
    // Recorded UI test
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElement *emptyListTable = app.tables[@"Empty list"];
    XCUIElement *searchSearchField = emptyListTable.searchFields[@"Search"];
    [searchSearchField tap];
    
    XCUIElement *cancelButton = app.buttons[@"Cancel"];
    [cancelButton tap];
    [searchSearchField tap];
    [app.searchFields[@"Search"] typeText:@"Starbucks"];
    [[[[[app childrenMatchingType:XCUIElementTypeWindow] elementBoundByIndex:0] childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:1] tap];
    [cancelButton tap];
    
    
    // Test that cells dissapear.
    XCTAssertEqual(app.tables.cells.count, 0);
    
}

- (void) testSearch {
    
    // Recorded UI test
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.tables[@"Empty list"].searchFields[@"Search"] tap];
    
    XCUIElement *searchSearchField = app.searchFields[@"Search"];
    [searchSearchField typeText:@"A"];
    
    // Should find something
    // Might no find anything if location simulation is not turned on.
    XCTAssertGreaterThan(app.tables.cells.count, 1);
    
}

@end
