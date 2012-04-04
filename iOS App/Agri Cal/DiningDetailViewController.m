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
            return MAX([self.dinner count], 1); 
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
            if ([self.dinner count])
            {
                cell.textLabel.text = [[self.dinner objectAtIndex:indexPath.row] objectForKey:@"name"]; 
                cell.detailTextLabel.text = [[self.dinner objectAtIndex:indexPath.row] objectForKey:@"type"];
            }else {
                cell = [tableView dequeueReusableCellWithIdentifier:@"Loading"];
                if (!cell)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Loading"];
                }
                cell.textLabel.text = @"Loading menu...";
            }
            break;
    }
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    MealViewController *dvc = segue.destinationViewController;
    switch (indexPath.section) {
        case 0:
            dvc.items = [self.breakfast objectAtIndex:indexPath.row];
            break;
        case 1:
            dvc.items = [self.brunch objectAtIndex:indexPath.row];
            break;
        case 2:
            dvc.items = [self.lunch objectAtIndex:indexPath.row];
            break;
        case 3:
            dvc.items = [self.dinner objectAtIndex:indexPath.row];
            break;
    }
    
}

@end
