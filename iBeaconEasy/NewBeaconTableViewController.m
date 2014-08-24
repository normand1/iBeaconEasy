//
//  NewBeaconTableViewController.m
//  iBeaconEasy
//
//  Created by davinorm on 8/23/14.
//  Copyright (c) 2014 David Norman. All rights reserved.
//

#import "NewBeaconTableViewController.h"
#import <Parse/Parse.h>
#import "UIAlertView+Blocks.h"
#import "MBProgressHUD.h"

@interface NewBeaconTableViewController ()

@end

@implementation NewBeaconTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (IBAction)saveBeacon:(UIBarButtonItem *)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *major = self.BeaconMajor.text;
    NSString *minor = self.BeaconMinor.text;
    NSString *UUID = self.BeaconUUID.text;
    NSString *message = self.BeaconMessage.text;
    NSString *name = self.BeaconName.text;
    
    if ([self formBad]) {
        [UIAlertView showWithTitle:@"Error" message:[NSString stringWithFormat:@"Please fill out all of the required information and only use Numbers for Major and Minor values"] cancelButtonTitle:@"Ok" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex)
         {
             NSLog(@"form not filled out");
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         }
         ];
        return;
    }
    
    PFObject *newBeaconObject = [PFObject objectWithClassName:@"TestObject" dictionary:@{@"ItemName": name, @"Major": @([major intValue]), @"Minor":@([minor intValue]), @"UUID":UUID, @"Message":message}];
    [newBeaconObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"Succeeded? %@....... Error: %@", @(succeeded), error);
        if (error == nil && ![self formBad])
        {
            [UIAlertView showWithTitle:@"Saved Successfully" message:@"Your beacon has saved successfully" cancelButtonTitle:@"Ok" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex)
             {
                 [self.navigationController popToRootViewControllerAnimated:YES];
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             }
             ];
        }
        else
        {
            [UIAlertView showWithTitle:@"Error" message:[NSString stringWithFormat:@"There was an error saving your beacon: %@", error] cancelButtonTitle:@"Ok" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex)
             {
                 NSLog(@"ERROR: %@", error);
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             }
             ];
        }
    }];
    
    
}

-(BOOL)formBad
{
    int counter = 0;
    
    //check if empty
    
    if (self.BeaconName.text.length > 0)
    {
        counter++;
    }
    if (self.BeaconMajor.text.length > 0)
    {
        counter++;
    }
    if (self.BeaconMessage.text.length > 0)
    {
        counter++;
    }
    if (self.BeaconMinor.text.length > 0)
    {
        counter++;
    }
    if (self.BeaconUUID.text.length > 0)
    {
        counter++;
    }

    //check if numbers should be strings
    NSCharacterSet *decimalSet = [NSCharacterSet decimalDigitCharacterSet];
    BOOL majorIsValid = ([[self.BeaconMajor.text stringByTrimmingCharactersInSet:decimalSet] isEqualToString:@""] ||
                          [[self.BeaconMajor.text stringByTrimmingCharactersInSet:decimalSet] isEqualToString:@"."]);
    BOOL minorIsValid = ([[self.BeaconMinor.text stringByTrimmingCharactersInSet:decimalSet] isEqualToString:@""] ||
                         [[self.BeaconMajor.text stringByTrimmingCharactersInSet:decimalSet] isEqualToString:@"."]);
    

    if (!majorIsValid) {
        counter++;
    }
    if (!minorIsValid) {
        counter++;
    }
    
    if (counter == 5) {
        return NO;
    }
    else
    {
        return YES;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
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
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
