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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.info objectForKey:@"sections"] count] + 1;
}
-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 8;
    }
    return 6;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"Course Info";
    }
    else {
        return [NSString stringWithFormat:@"Section %i", section];
    }
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
    if (indexPath.section == 0)
    {
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
    }
    else {
        NSDictionary *dict = [[self.info objectForKey:@"sections"] objectAtIndex:indexPath.section-1];
        switch (indexPath.row) {
            case 0:
                cell.detailTextLabel.text = [dict objectForKey:@"type"];
                cell.textLabel.text = @"Type";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
            case 1: 
                cell.detailTextLabel.text = [dict objectForKey:@"time"];
                cell.textLabel.text = @"Time";            
                cell.selectionStyle = UITableViewCellSelectionStyleNone;            
                break;
            case 2: 
                cell.detailTextLabel.text = [dict objectForKey:@"instructor"];
                cell.textLabel.text = @"Instructor";            
                cell.selectionStyle = UITableViewCellSelectionStyleNone;            
                break;
            case 3: 
                cell.detailTextLabel.text = [dict objectForKey:@"location"];
                cell.textLabel.text = @"Location";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;            
                break;
            case 4: 
                cell.detailTextLabel.text = [dict objectForKey:@"ccn"];
                cell.textLabel.text = @"CCN";            
                cell.selectionStyle = UITableViewCellSelectionStyleNone;            
                break;
            case 6: 
                cell.detailTextLabel.text = [dict objectForKey:@"exam_group"];
                cell.textLabel.text = @"Exam";            
                cell.selectionStyle = UITableViewCellSelectionStyleNone;            
                break;
            default:
                break;
        }
    }

    return cell;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 7)
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
