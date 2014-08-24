//
//  NewBeaconTableViewController.h
//  iBeaconEasy
//
//  Created by davinorm on 8/23/14.
//  Copyright (c) 2014 David Norman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewBeaconTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *BeaconName;
@property (weak, nonatomic) IBOutlet UITextField *BeaconUUID;
@property (weak, nonatomic) IBOutlet UITextField *BeaconMajor;
@property (weak, nonatomic) IBOutlet UITextField *BeaconMinor;
@property (weak, nonatomic) IBOutlet UITextView *BeaconMessage;


@end
