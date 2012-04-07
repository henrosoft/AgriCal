//
//  InfoViewController.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertView *alert;
    if(indexPath.section == 1){
        alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:[NSString stringWithFormat:@"Redirect to %@?", [tableView cellForRowAtIndexPath:indexPath].textLabel.text] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    }
    else{
        alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:[NSString stringWithFormat:@"Call %@?", [tableView cellForRowAtIndexPath:indexPath].textLabel.text] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    }
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: [self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]].detailTextLabel.text]];
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", [self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]].detailTextLabel.text]]];
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    }
}
@end
