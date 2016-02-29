//
//  VenueCell.h
//  VenueSearch
//
//  Created by Olli Tapaninen on 27/02/16.
//  Copyright © 2016 Olli Tapaninen. All rights reserved.
//

#import <UIKit/UIKit.h>

// UI Cell to represent the venue. See Main.storyboard for prototype cell.
@interface VenueCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;
@property (nonatomic, weak) IBOutlet UILabel *addressLabel;
@property (nonatomic, weak) IBOutlet UIImageView *venueImage;

@end
