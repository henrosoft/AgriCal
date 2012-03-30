//
//  DiningDetailViewController.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 3/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DiningDetailViewController.h"

@interface DiningDetailViewController ()

@end

@implementation DiningDetailViewController
@synthesize dinner = _dinner; 
@synthesize lunch = _lunch; 
@synthesize brunch = _brunch; 
@synthesize breakfast = _breakfast; 
@synthesize lateNight = _lateNight; 
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButton
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [self.breakfast count];
        case 1:
            return [self.brunch count];
        case 2:
            return [self.lunch count];
        case 3:
            return [self.dinner count]; 
    }
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22.0f;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Breakfast";
        case 1:
            return @"Brunch";
        case 2:
            return @"Lunch";
        case 3:
            return @"Dinner";
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = [[self.breakfast objectAtIndex:indexPath.row] objectForKey:@"name"]; 
            cell.detailTextLabel.text = [[self.breakfast objectAtIndex:indexPath.row] objectForKey:@"type"];
            break;
        case 1:
            cell.textLabel.text = [[self.brunch objectAtIndex:indexPath.row] objectForKey:@"name"]; 
            cell.detailTextLabel.text = [[self.brunch objectAtIndex:indexPath.row] objectForKey:@"type"];
            break;
        case 2:
            cell.textLabel.text = [[self.lunch objectAtIndex:indexPath.row] objectForKey:@"name"]; 
            cell.detailTextLabel.text = [[self.lunch objectAtIndex:indexPath.row] objectForKey:@"type"];
            break;
        case 3:
            cell.textLabel.text = [[self.dinner objectAtIndex:indexPath.row] objectForKey:@"name"]; 
            cell.detailTextLabel.text = [[self.dinner objectAtIndex:indexPath.row] objectForKey:@"type"];
            break;
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
