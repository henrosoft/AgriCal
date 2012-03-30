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


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DiningDetailViewController *viewController = [[DiningDetailViewController alloc] init];
    viewController.title = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    NSString *urlAddon = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    if ([urlAddon isEqualToString:@"Clark Kerr"]) 
        urlAddon = @"ckc";
    NSString *queryString = [NSString stringWithFormat:[NSString stringWithFormat:@"http://192.168.1.68/api/menu/%@",urlAddon]];
    NSURL *requestURL = [NSURL URLWithString:queryString];
    NSURLRequest *jsonRequest = [NSURLRequest requestWithURL:requestURL];
    
    // Use GCD to perform request in background, and then jump back on the main thread 
    // to update the UI
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *receivedData = [NSURLConnection sendSynchronousRequest:jsonRequest
                                                     returningResponse:&response
                                                                 error:&error];
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONWritingPrettyPrinted error:nil];   
        NSLog(@"%@", viewController.lunch = [dict objectForKey:@"lunch"]);
        viewController.dinner = [dict objectForKey:@"dinner"];
        viewController.brunch = [dict objectForKey:@"brunch"];
        viewController.lateNight = [dict objectForKey:@"latenight"];
        viewController.breakfast = [dict objectForKey:@"breakfast"];
        dispatch_queue_t updateUIQueue = dispatch_get_main_queue();
        dispatch_async(updateUIQueue, ^{
            [viewController.tableView reloadData];
        });
    });
    self.navigationItem.title = @"Back";
    [self.navigationController pushViewController:viewController animated:YES];
}
@end
