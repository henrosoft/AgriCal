//
//  DiningMainViewController.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 3/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DiningMainViewController.h"

@interface DiningMainViewController ()

@end

@implementation DiningMainViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated]; 
    self.navigationItem.title = @"Dining Commons";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Crossroads"; 
            break;
        case 1:
            cell.textLabel.text = @"Clark Kerr";
            break;
        case 2:
            cell.textLabel.text = @"Foothill"; 
            break; 
        case 3:
            cell.textLabel.text = @"Cafe3";
            break;
        default:
            break;
    }
    return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"mealpoints"])
        return [NSString stringWithFormat:@"%@ Meal Points", [[NSUserDefaults standardUserDefaults] objectForKey:@"mealpoints"]];
    else 
        return @"Meal Points N/A";
}
#pragma mark - Table view delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DiningDetailViewController *viewController = ((DiningDetailViewController*)segue.destinationViewController);
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    viewController.title = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    NSString *urlAddon = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    if ([urlAddon isEqualToString:@"Clark Kerr"]) 
        urlAddon = @"ckc";
    NSString *queryString = [NSString stringWithFormat:[NSString stringWithFormat:@"%@/api/menu/%@",ServerURL, urlAddon]];
    NSURL *requestURL = [NSURL URLWithString:queryString];
    NSURLRequest *jsonRequest = [NSURLRequest requestWithURL:requestURL];
    
    // Use GCD to perform request in background, and then jump back on the main thread 
    // to update the UI
    NSDictionary *preload = [[NSDictionary alloc] init];
    if ((preload = [[NSUserDefaults standardUserDefaults] objectForKey:urlAddon]))
    {
        viewController.dinner = [preload objectForKey:@"dinner"];
        viewController.brunch = [preload objectForKey:@"brunch"];
        viewController.lunch = [preload objectForKey:@"lunch"];
        viewController.breakfast = [preload objectForKey:@"breakfast"];
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *receivedData = [NSURLConnection sendSynchronousRequest:jsonRequest
                                                     returningResponse:&response
                                                                 error:&error];
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONWritingPrettyPrinted error:nil];   
        viewController.dinner = [dict objectForKey:@"dinner"];
        viewController.brunch = [dict objectForKey:@"brunch"];
        viewController.lunch = [dict objectForKey:@"lunch"];
        viewController.breakfast = [dict objectForKey:@"breakfast"];
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:urlAddon];
        dispatch_queue_t updateUIQueue = dispatch_get_main_queue();
        dispatch_async(updateUIQueue, ^{
            [viewController.tableView reloadData];
        });
    });
}
@end
