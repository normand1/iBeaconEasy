//
//  FirstViewControllerTableViewController.h
//  EasyiBeacon
//
//  Created by davinorm on 8/23/14.
//  Copyright (c) 2014 David Norman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@interface FirstViewControllerTableViewController : UITableViewController <CLLocationManagerDelegate, UIAlertViewDelegate>
{
    int beaconUnkStateCounter;
}

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) NSMutableArray *tableItems;



@end
