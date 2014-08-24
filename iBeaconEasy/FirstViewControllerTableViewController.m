//
//  FirstViewControllerTableViewController.m
//  EasyiBeacon
//
//  Created by davinorm on 8/23/14.
//  Copyright (c) 2014 David Norman. All rights reserved.
//

#import "FirstViewControllerTableViewController.h"
#import "RWTItem.h"
#import "RWTItemCell.h"
#import "UIAlertView+Blocks.h"

NSString * const kRWTStoredItemsKey = @"storedItems";


@interface FirstViewControllerTableViewController ()

@end

@implementation FirstViewControllerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.items = [[NSMutableArray alloc]init];
    self.tableItems = [[NSMutableArray alloc]init];


    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    [self refreshResults:nil];
//    NSTimer* myTimer __unused = [NSTimer scheduledTimerWithTimeInterval: 10.0 target: self
//                                                      selector: @selector(refreshResults:) userInfo: nil repeats: YES];

}

-(void)viewDidAppear:(BOOL)animated
{
    
}

-(void)addNewTagWithUUIDString:(NSString*)tagUUID itemName:(NSString*)itemName major:(int)majorInt minor:(int)minorInt message:(NSString*)message
{
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:tagUUID];
    RWTItem *newItem = [[RWTItem alloc] initWithName:itemName
                                                uuid:uuid
                                               major:majorInt
                                               minor:minorInt
                                             message:message];
    
    [self.items addObject:newItem];
}


- (IBAction)refreshResults:(id)sender {
    
    self.tableItems = [[NSMutableArray alloc]init];

//    causing crashes when an item is removed
//    for (RWTItem *item in _items) {
//        [self stopMonitoringItem:item];
//    }
    
    self.items = [[NSMutableArray alloc]init];

    
    PFQuery *testObject = [PFQuery queryWithClassName:@"TestObject"];
    [testObject findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         for (PFObject* object in objects)
         {
             NSLog(@"Retreived: %@", object[@"UUID"]);
             [self addNewTagWithUUIDString:object[@"UUID"] itemName:object[@"ItemName"] major:[object[@"Major"]intValue] minor:[object[@"Minor"]intValue] message:object[@"Message"]];
         }
         
         for (RWTItem *item in self.items)
         {
             [self startMonitoringItem:item];
         }
         
         

     }];
    
    [self.tableView reloadData];

    
}


- (CLBeaconRegion *)beaconRegionWithItem:(RWTItem *)item {
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:item.uuid
                                                                           major:item.majorValue
                                                                           minor:item.minorValue
                                                                      identifier:item.name];
    return beaconRegion;
}

- (void)startMonitoringItem:(RWTItem *)item {
    CLBeaconRegion *beaconRegion = [self beaconRegionWithItem:item];
    [self.locationManager startMonitoringForRegion:beaconRegion];
    [self.locationManager startRangingBeaconsInRegion:beaconRegion];
}

- (void)stopMonitoringItem:(RWTItem *)item {
    CLBeaconRegion *beaconRegion = [self beaconRegionWithItem:item];
    [self.locationManager stopMonitoringForRegion:beaconRegion];
    [self.locationManager stopRangingBeaconsInRegion:beaconRegion];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"Failed monitoring region: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location manager failed: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region
{
    for (CLBeacon *beacon in beacons) {
        for (RWTItem *item in self.items) {
            if ([item isEqualToCLBeacon:beacon])
            {
                if (![_tableItems containsObject:item]) {
                    [_tableItems addObject:item];
                }
                item.lastSeenBeacon = beacon;
                NSLog(@"found a beacon %@", item.message);
                break;
            }
        }
    }
    
    
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _tableItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RWTItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"regularBeaconCell" forIndexPath:indexPath];
    
    if (_tableItems.count-1 == indexPath.row) {
        [self.refreshControl endRefreshing];
    }
    
    RWTItem *item = _tableItems[indexPath.row];
    if (item.lastSeenBeacon.proximity == 0) {
        beaconUnkStateCounter++;
    }
    if (beaconUnkStateCounter > 10)
    {
        beaconUnkStateCounter = 0;
        [self refreshResults:nil];
    }
    
    cell.item = item;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RWTItem *item = _tableItems[indexPath.row];
    [UIAlertView showWithTitle:@"Message" message:item.message cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
       // code for tapped
    }];

}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
