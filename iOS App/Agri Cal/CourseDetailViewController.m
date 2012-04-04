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
@synthesize courseInfo = _courseInfo;
@synthesize searchResults = _searchResults;
@synthesize titles = _titles;
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
    self.titles = [[NSMutableArray alloc] init];
    self.searchResults = [[NSMutableArray alloc] init];
    self.courses = [[NSMutableDictionary alloc] init];
    self.courseInfo = [[NSMutableDictionary alloc] init];
    self.navigationItem.title = self.department;
    NSString *queryString = [NSString stringWithFormat:@"%@/api/courses/%@", ServerURL, self.department]; 
    queryString = [queryString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *requestURL = [NSURL URLWithString:queryString];
    NSURLRequest *jsonRequest = [NSURLRequest requestWithURL:requestURL];
    
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
                if ([[dict objectForKey:@"title"] isEqualToString:@""])
                    continue;
                NSString *firstLetter = [[dict objectForKey:@"title"] substringToIndex:1];
                if ([self.courses objectForKey:firstLetter])
                {
                    [self.titles addObject:[NSString stringWithFormat:@"%@: %@", [dict objectForKey:@"number"],[dict objectForKey:@"title"]]];
                    [[self.courses objectForKey:firstLetter] addObject:[NSString stringWithFormat:@"%@: %@",[dict objectForKey:@"number"],[dict objectForKey:@"title"]]];
                    if ([self.courseInfo objectForKey:[dict objectForKey:@"number"]])
                    {
                        continue;
                    }
                    [self.courseInfo setObject:dict forKey:[NSString stringWithFormat:@"%@: %@",[dict objectForKey:@"number"],[dict objectForKey:@"title"]]];
                    [[self.courses objectForKey:firstLetter] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
                }
                else
                {
                    [self.titles addObject:[NSString stringWithFormat:@"%@: %@", [dict objectForKey:@"number"],[dict objectForKey:@"title"]]];
                    [self.courses setObject:[NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%@: %@",[dict objectForKey:@"number"],[dict objectForKey:@"title"]],nil] forKey:firstLetter];
                    [self.courseInfo setObject:dict forKey:[NSString stringWithFormat:@"%@: %@",[dict objectForKey:@"number"],[dict objectForKey:@"title"]]];
                }
            }
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
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView == self.tableView)
        return [[self.courses allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    else 
        return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if (tableView == self.tableView)
        return [[[self.courses allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] indexOfObject:title];
    else 
        return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (tableView == self.tableView)
        return MAX([self.courses count], 1);
    else 
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == self.tableView)
    {
        NSArray *indexArray = [[self.courses allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        if ([indexArray count])
        {
            return [[self.courses objectForKey:[indexArray objectAtIndex:section]] count];
        }
        else {
            return 1;
        }
    }
    else return [self.searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    if (tableView == self.tableView)
    {
        NSArray *indexArray = [[self.courses allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        if (![indexArray count])
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Loading"];
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Loading"];
            }
            cell.textLabel.text = @"Loading courses...";
        }else{
            NSArray *indexArray = [[self.courses allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            NSString *title = [[self.courses objectForKey:[indexArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
            cell.textLabel.text = title;
            if ([[self.courseInfo objectForKey:title] class] == [NSMutableDictionary class])
                cell.detailTextLabel.text = [[self.courseInfo objectForKey:title] objectForKey:@"number"];
            else 
            {
                NSString *str = [[self.courseInfo objectForKey:title] objectForKey:@"time"];
                NSString *enrolled = [[self.courseInfo objectForKey:title] objectForKey:@"enrolled"];
                NSString *limit = [[self.courseInfo objectForKey:title] objectForKey:@"limit"];
                NSString *webcast = [[self.courseInfo objectForKey:title] objectForKey:@"webcast"];
                if ([str isEqualToString:@""])
                    str = @"N/A";
                if ([enrolled isEqualToString:@""])
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
    }
    else 
    {
        cell.textLabel.text = [self.searchResults objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    return cell;
}
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView && [[self.courses allKeys] count])
        return [[[self.courses allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
    else 
        return @"";
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView != self.tableView)
    {
        [self performSegueWithIdentifier:@"Detail" sender:[NSArray arrayWithObjects:[tableView cellForRowAtIndexPath:indexPath], tableView,nil]];
    }
}
- (void)filterContentForSearchText:(NSString*)searchText 
                             scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate 
                                    predicateWithFormat:@"SELF contains[cd] %@",
                                    searchText];
    
    self.searchResults = [self.titles filteredArrayUsingPredicate:resultPredicate];
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
    if ([[sender class] isSubclassOfClass:[NSArray class]])
    {
        sender = [((NSArray*)sender) objectAtIndex:0];
        NSString *title = ((UITableViewCell*)sender).textLabel.text;
        ((CourseInfoViewController*)segue.destinationViewController).info = [self.courseInfo objectForKey:title];
        ((CourseInfoViewController*)segue.destinationViewController).navigationItem.title = title;
    }
    else {
        NSArray *indexArray = [[self.courses allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        NSString *title = [[self.courses objectForKey:[indexArray objectAtIndex:[self.tableView indexPathForSelectedRow].section]] objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        ((CourseInfoViewController*)segue.destinationViewController).info = [self.courseInfo objectForKey:title];
        ((CourseInfoViewController*)segue.destinationViewController).navigationItem.title = title;
    }
}

@end
