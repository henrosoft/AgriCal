//
//  CourseDetailViewController.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 3/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CourseDetailViewController.h"

@interface CourseDetailViewController ()

@end

@implementation CourseDetailViewController
@synthesize courses = _courses;
@synthesize department = _department;
@synthesize searchBar = _searchBar;
@synthesize searchResults = _searchResults;
@synthesize semester = _semester;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchResults = [[NSMutableArray alloc] init];
    NSString *queryString = [NSString stringWithFormat:@"%@/api/courses/%@/%@/", ServerURL, self.department, self.semester]; 
    queryString = [queryString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *requestURL = [NSURL URLWithString:queryString];
    NSURLRequest *jsonRequest = [NSURLRequest requestWithURL:requestURL];
    if (!(self.courses = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@", self.department, self.semester]]))
        self.courses = [[NSMutableArray alloc] init];
    // Use GCD to perform request in background, and then jump back on the main thread 
    // to update the UI
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
        @try {
            NSURLResponse *response = nil;
            NSError *error = nil;
            NSData *receivedData = [NSURLConnection sendSynchronousRequest:jsonRequest
                                                         returningResponse:&response
                                                                     error:&error];
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONWritingPrettyPrinted error:nil];  
            for (NSDictionary *dict in arr)
            {
                [self.courses addObject:dict];
                NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"number"  ascending:YES];
                [self.courses sortUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
            }
            [[NSUserDefaults standardUserDefaults] setObject:self.courses forKey:[NSString stringWithFormat:@"%@%@", self.department, self.semester]];
            dispatch_queue_t updateUIQueue = dispatch_get_main_queue();
            dispatch_async(updateUIQueue, ^{
                [self.tableView reloadData];
            });
        }
        @catch (NSException *e) {
            NSLog(@"Error");
        }
    });
}

- (void)viewDidUnload
{
    [self setSearchBar:nil];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == self.tableView)
    {
        return MAX([self.courses count],1);
    }
    else return [self.searchResults count];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.adjustsFontSizeToFitWidth = NO;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        cell.textLabel.adjustsFontSizeToFitWidth = NO;
    }
    if (tableView == self.tableView)
    {
        if (![self.courses count])
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Loading"];
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Loading"];
            }
            cell.textLabel.text = @"Loading courses...";
        }else{
            NSString *title = [[self.courses objectAtIndex:indexPath.row] objectForKey:@"title"];
            NSString *number = [[self.courses objectAtIndex:indexPath.row] objectForKey:@"number"];
            NSString *str = [[self.courses objectAtIndex:indexPath.row] objectForKey:@"time"];
            NSString *enrolled = [[self.courses objectAtIndex:indexPath.row] objectForKey:@"enrolled"];
            NSString *limit = [[self.courses objectAtIndex:indexPath.row] objectForKey:@"limit"];
            NSString *webcast = [[self.courses objectAtIndex:indexPath.row] objectForKey:@"webcast"];
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",number,title];
            if ([str isEqualToString:@""])
                str = @"N/A";
            if ([enrolled isEqualToString:@""] || [enrolled isEqualToString:@"DEPT"])
            {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - Enrollment info N/A", str];
            }
            else 
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@/%@ Enrolled", str, enrolled, limit];
            if (![webcast isEqualToString:@"false"])
                cell.imageView.image = [UIImage imageNamed:@"monitor.png"];
            else 
                cell.imageView.image = nil;
        }
    }
    else 
    {
        NSString *title = [[self.searchResults objectAtIndex:indexPath.row] objectForKey:@"title"];
        NSString *number = [[self.searchResults objectAtIndex:indexPath.row] objectForKey:@"number"];
        NSString *str = [[self.searchResults objectAtIndex:indexPath.row] objectForKey:@"time"];
        NSString *enrolled = [[self.searchResults objectAtIndex:indexPath.row] objectForKey:@"enrolled"];
        NSString *limit = [[self.searchResults objectAtIndex:indexPath.row] objectForKey:@"limit"];
        NSString *webcast = [[self.searchResults objectAtIndex:indexPath.row] objectForKey:@"webcast"];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",number,title];
        if ([str isEqualToString:@""])
            str = @"N/A";
        if ([enrolled isEqualToString:@""] || [enrolled isEqualToString:@"DEPT"])
        {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - Enrollment info N/A", str];
        }
        else 
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@/%@ Enrolled", str, enrolled, limit];
        if (![webcast isEqualToString:@"false"])
            cell.imageView.image = [UIImage imageNamed:@"monitor.png"];
        else 
            cell.imageView.image = nil;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView != self.tableView)
    {
        [self performSegueWithIdentifier:@"Detail" sender:[NSNumber numberWithInt:indexPath.row]];
    }
}
- (void)filterContentForSearchText:(NSString*)searchText 
                             scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate 
                                    predicateWithFormat:@"number contains %@ OR title contains[cd] %@",
                                    searchText, searchText];
    
    self.searchResults = [self.courses filteredArrayUsingPredicate:resultPredicate];
}
#pragma mark - UISearchDisplayController delegate methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller 
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString 
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller 
shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] 
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:searchOption]];
    
    return YES;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[sender class] isSubclassOfClass:[NSNumber class]])
    {
        sender = (NSNumber*)sender;
        NSLog(@"%@", sender);
        NSString *title = [[self.searchResults objectAtIndex:[sender integerValue]] objectForKey:@"title"];
        ((CourseInfoViewController*)segue.destinationViewController).info = [self.searchResults objectAtIndex:[((NSNumber*)sender) integerValue]];
        ((CourseInfoViewController*)segue.destinationViewController).navigationItem.title = title;
        [self.searchDisplayController setActive:NO animated:YES];  
    }
    else {
        sender = [NSNumber numberWithInt:[self.tableView indexPathForSelectedRow].row];
        NSString *title = [[self.courses objectAtIndex:[sender integerValue]] objectForKey:@"title"];
        ((CourseInfoViewController*)segue.destinationViewController).info = [self.courses objectAtIndex:[((NSNumber*)sender) integerValue]];
        ((CourseInfoViewController*)segue.destinationViewController).navigationItem.title = title; 
    }
}   
    @end
