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
    NSString *queryString = [NSString stringWithFormat:@"%@/api/balance/", ServerURL];
    
    NSString *post = [NSString stringWithFormat:@"username=%@&password=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"username"], [[NSUserDefaults standardUserDefaults] objectForKey:@"password"]];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:queryString]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSString *diningString = [NSString stringWithFormat:@"%@/api/dining_times/", ServerURL];
    
    NSURL *diningURL = [NSURL URLWithString:diningString];
    
    NSURLRequest *diningRequest = [NSURLRequest requestWithURL:diningURL];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *receivedData = [NSURLConnection sendSynchronousRequest:request
                                                     returningResponse:&response
                                                                 error:&error];
        NSArray *bal = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONWritingPrettyPrinted error:nil];   
        NSLog(@"recieved %@", bal);
        [[NSUserDefaults standardUserDefaults] setObject:[bal objectAtIndex:0] forKey:@"cal1bal"];
        [[NSUserDefaults standardUserDefaults] setObject:[bal objectAtIndex:1] forKey:@"mealpoints"];
        
        receivedData = [NSURLConnection sendSynchronousRequest:diningRequest returningResponse:&response error:&error];
        NSArray *diningArray = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONWritingPrettyPrinted error:&error];
        for (NSDictionary *dict in diningArray)
        {
            [[NSUserDefaults standardUserDefaults] setObject:dict forKey:[NSString stringWithFormat:@"%@times", [dict objectForKey:@"location"]]];
        }
        [self.tableView reloadData];
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Custom";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    switch (indexPath.section) {
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
-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) 
        return 30;
    return 0;
}
-(float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 120;
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSString *location = @"";
    switch (section) {
        case 0:
            location = @"crossroads";
            break;
        case 1:
            location = @"ckc";
            break;
        case 2:
            location = @"foothill";
            break;
        case 3:
            location = @"cafe3";
            break;
        default:
            break;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(16, 0, tableView.frame.size.width-32, 60)];
    NSArray *info = [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat: @"%@times", location]] objectForKey:@"timespans"];
    NSLog(@"%@", info);
    int counter = 0;
    for (NSDictionary *currentDict in info)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, counter, tableView.frame.size.width-32, 20)];
        label.text = [currentDict objectForKey:@"title"];
        [view addSubview:label];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:@"Helvetica" size:17.0];
        label.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1.0];
        label.shadowColor = [UIColor colorWithWhite:1 alpha:1];
        label.shadowOffset = CGSizeMake(0, 1);
        counter += 20;
        int innercounter = counter;
        for (NSDictionary *currentTimes in [currentDict objectForKey:@"spans"])
        {
            NSString *innerTitle = [NSString stringWithFormat:@"%@: %@", [currentTimes objectForKey:@"type"], [currentTimes objectForKey:@"span"]];
            UILabel *details = [[UILabel alloc] initWithFrame:CGRectMake(16, innercounter, tableView.frame.size.width-32, 20)];
            [view addSubview:details];
            details.text = innerTitle;
            details.backgroundColor = [UIColor clearColor];
            details.font = [UIFont fontWithName:@"Helvetica" size:12.0];
            details.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1.0];
            details.shadowColor = [UIColor colorWithWhite:1 alpha:1];
            details.shadowOffset = CGSizeMake(0, 1);
            innercounter += 15;
            counter +=15;
        }
        counter += 5;
    }
    return view;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        NSString *mealPoints = [[NSUserDefaults standardUserDefaults] objectForKey:@"mealpoints"];
        if (!mealPoints || [mealPoints isEqualToString:@"(null)"])
            return @"Meal Points N/A";            
        else 
            return [NSString stringWithFormat:@"%@ Meal Points", [[NSUserDefaults standardUserDefaults] objectForKey:@"mealpoints"]];
    }else {
        return @"";
    }
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
    queryString = [queryString lowercaseString];
    
    NSLog(@"%@", queryString);
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
        if (!([[dict objectForKey:@"dinner"] count] || [[dict objectForKey:@"brunch"] count] || [[dict objectForKey:@"lunch"] count] || [[dict objectForKey:@"breakfast"] count]))
        {
            NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
            [temp setObject:@"No menu today" forKey:@"name"];
            [temp setObject:@"No food for you!" forKey:@"type"];
            viewController.dinner = [NSArray arrayWithObject:temp];
        }
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:urlAddon];
        dispatch_queue_t updateUIQueue = dispatch_get_main_queue();
        dispatch_async(updateUIQueue, ^{
            [viewController.tableView reloadData];
        });
    });
}
@end
