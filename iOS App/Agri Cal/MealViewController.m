//
//  MealViewController.m
//  Agri Cal
//
//  Created by Daniela Molinaro on 4/4/12.
//  Copyright (c) 2012 UC Berkeley. All rights reserved.
//

#import "MealViewController.h"

@interface MealViewController ()

@end

@implementation MealViewController
@synthesize items;
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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    switch (indexPath.row) {
        case 0:
            cell.detailTextLabel.text = [self.items objectForKey:@"name"];
            cell.textLabel.text = @"Name";
            break;
        case 1:
            cell.textLabel.text = @"Type";
            cell.detailTextLabel.text = [self.items objectForKey:@"type"];            
        default:
            break;
    }
    
    return cell;
}

@end
