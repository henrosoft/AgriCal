//
//  CourseInfoViewController.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 3/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CourseInfoViewController.h"

@interface CourseInfoViewController ()

@end

@implementation CourseInfoViewController
@synthesize info = _info;

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

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"Cell"];
    }
    switch (indexPath.row) {
        case 0:
            cell.detailTextLabel.text = [self.info objectForKey:@"title"];
            cell.textLabel.text = @"Title";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        case 1: 
            cell.detailTextLabel.text = [self.info objectForKey:@"time"];
            cell.textLabel.text = @"Time";            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;            
            break;
        case 2: 
            cell.detailTextLabel.text = [self.info objectForKey:@"instructor"];
            cell.textLabel.text = @"Instructor";            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;            
            break;
        case 3: 
            cell.detailTextLabel.text = [self.info objectForKey:@"location"];
            cell.textLabel.text = @"Location";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;            
            break;
        case 4: 
            cell.detailTextLabel.text = [self.info objectForKey:@"ccn"];
            cell.textLabel.text = @"CCN";            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;            
            break;
        case 5: 
            cell.detailTextLabel.text = [self.info objectForKey:@"units"];
            cell.textLabel.text = @"Units";            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;            
            break;
        case 6: 
            cell.detailTextLabel.text = [self.info objectForKey:@"exam_group"];
            cell.textLabel.text = @"Exam";            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;            
            break;
        case 7: 
            cell.detailTextLabel.text = [self.info objectForKey:@"webcast"];
            if ([cell.detailTextLabel.text isEqualToString:@"false"])
            {
                cell.detailTextLabel.text = @"N/A";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;                
            }
            else {
                cell.detailTextLabel.text = @"Available";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleGray;                            
            }
            cell.textLabel.text = @"Webcast";
            break;
        default:
            break;
    }

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 7)
    {
        NSLog(@"%@",[tableView cellForRowAtIndexPath:indexPath].detailTextLabel.text);
        if (![[tableView cellForRowAtIndexPath:indexPath].detailTextLabel.text isEqualToString:@"N/A"])
        {
            [self performSegueWithIdentifier:@"test" sender:[tableView cellForRowAtIndexPath:indexPath]];
        }
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ((WebcastListViewController*)segue.destinationViewController).url = [NSString stringWithFormat:@"/api/webcasts/%@/", [self.info objectForKey:@"id"]];
}
@end
