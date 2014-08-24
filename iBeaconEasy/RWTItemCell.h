//
//  RWTItemCell.h
//  ForgetMeNot
//
//  Created by Chris Wagner on 1/30/14.
//  Copyright (c) 2014 Ray Wenderlich Tutorial Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RWTItem;

@interface RWTItemCell : UITableViewCell

@property (strong, nonatomic) RWTItem *item;

@property (weak, nonatomic) IBOutlet UILabel *beaconName;
@property (weak, nonatomic) IBOutlet UILabel *beaconLocation;
@property (weak, nonatomic) IBOutlet UILabel *beaconMessage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingInd;


@end
