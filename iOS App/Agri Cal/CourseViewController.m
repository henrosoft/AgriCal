//
//  CourseViewController.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 3/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CourseViewController.h"

@interface CourseViewController ()

@end

@implementation CourseViewController
@synthesize departments;
@synthesize departmentNumbers = _departmentNumbers;
@synthesize searchResults = _searchResults;
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
    self.departments = [[NSUserDefaults standardUserDefaults] objectForKey:@"dep"];
    self.departmentNumbers = [[NSUserDefaults standardUserDefaults] objectForKey:@"depTitles"];
    self.searchResults = [[NSMutableArray alloc] init];
    self.navigationItem.title = @"Courses";
    if (!self.departments || [[self.departments allKeys] count] == 1){
        NSLog(@"Departments nil, trying to reload");
        self.departments = [[NSMutableDictionary alloc] init];
        self.departmentNumbers = [[NSMutableArray alloc] init];
        NSString *queryString = @"http://192.168.1.68:8000/api/courses/departments";
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
                for (NSArray *depArr in arr)
                {
                    NSString *title = [depArr objectAtIndex:0];
                    if([title isEqualToString:@""] || !title)
                        continue;
                    NSString *firstLetter = [title substringToIndex:1];
                    if ([self.departments objectForKey:firstLetter])
                    {
                        [self.departmentNumbers addObject:title];
                        [[self.departments objectForKey:firstLetter] addObject:title];
                        [[self.departments objectForKey:firstLetter] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
                    }
                    else
                    {
                        [self.departmentNumbers addObject:title];
                        [self.departments setObject:[NSMutableArray arrayWithObjects:title,nil] forKey:firstLetter];
                    }
                }
                NSString *queryString = [NSString stringWithFormat:@"http://192.168.1.68:8000/api/schedule/?username=%@&password=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"username"], [[NSUserDefaults standardUserDefaults] objectForKey:@"password"]]; 
                queryString = [queryString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *requestURL = [NSURL URLWithString:queryString];
                NSURLRequest *jsonRequest = [NSURLRequest requestWithURL:requestURL];
                receivedData = [NSURLConnection sendSynchronousRequest:jsonRequest
                                                     returningResponse:&response
                                                                 error:&error];
                NSMutableArray *dict = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONWritingPrettyPrinted error:&error];
                
                dict = [NSMutableArray arrayWithArray:dict];
                NSDictionary *toRemove = nil;
                for(NSDictionary *current in dict)
                {
                    if([[current objectForKey:@"title"] isEqualToString:@""])
                        toRemove = current;
                }
                if (toRemove)
                    [dict removeObject:toRemove];
                [self.departments setObject:dict forKey:@"*"];
                dispatch_queue_t updateUIQueue = dispatch_get_main_queue();
                dispatch_async(updateUIQueue, ^{
                    [self.tableView reloadData];
                });
            }
            @catch (NSException *e) {
                NSLog(@"error");
            }
            [[NSUserDefaults standardUserDefaults] setObject:self.departments forKey:@"dep"];
            [[NSUserDefaults standardUserDefaults] setObject:self.departmentNumbers forKey:@"depTitles"];
        });
    }
    else 
    {
        NSLog(@"Reloading registered courses");
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
        dispatch_async(queue, ^{
            @try {
                NSURLResponse *response = nil;
                NSError *error = nil;
                NSString *queryString = [NSString stringWithFormat:@"http://192.168.1.68:8000/api/schedule/?username=%@&password=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"username"], [[NSUserDefaults standardUserDefaults] objectForKey:@"password"]]; 
                queryString = [queryString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *requestURL = [NSURL URLWithString:queryString];
                NSURLRequest *jsonRequest = [NSURLRequest requestWithURL:requestURL];
                NSData *receivedData = [NSURLConnection sendSynchronousRequest:jsonRequest
                                                             returningResponse:&response
                                                                         error:&error];
                NSMutableArray *dict = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONWritingPrettyPrinted error:&error];
                
                dict = [NSMutableArray arrayWithArray:dict];
                NSDictionary *toRemove = nil;
                for(NSDictionary *current in dict)
                {
                    if([[current objectForKey:@"title"] isEqualToString:@""])
                        toRemove = current;
                }
                if (toRemove)
                    [dict removeObject:toRemove];
                [self.departments setObject:dict forKey:@"*"];
                dispatch_queue_t updateUIQueue = dispatch_get_main_queue();
                dispatch_async(updateUIQueue, ^{
                    [self.tableView reloadData];
                });
                [[NSUserDefaults standardUserDefaults] setObject:self.departments forKey:@"dep"];
            [[NSUserDefaults standardUserDefaults] setObject:self.departmentNumbers forKey:@"depTitles"];                
            }
            @catch (NSException *e) {
                NSLog(@"error");
            }
            [[NSUserDefaults standardUserDefaults] setObject:self.departments forKey:@"dep"];
            [[NSUserDefaults standardUserDefaults] setObject:self.departmentNumbers forKey:@"depTitles"];            
        });
    }
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView == self.tableView)
        return [[self.departments allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    else 
        return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if (tableView == self.tableView)
        return [[[self.departments allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] indexOfObject:title];
    else 
        return 0;
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
    // Return the number of sections.
    if (tableView == self.tableView) 
        return [self.departments count];
    else 
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == self.tableView)
    {
        NSArray *indexArray = [[self.departments allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        return [[self.departments objectForKey:[indexArray objectAtIndex:section]] count];
    }
    else
    {
        return [self.searchResults count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView)
    {
        if (indexPath.section == 0)
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Personal"];
            if (!cell){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Personal"];
            }
            cell.textLabel.text = [[[self.departments objectForKey:@"*"] objectAtIndex:indexPath.row] objectForKey:@"title"];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",[[[self.departments objectForKey:@"*"] objectAtIndex:indexPath.row] objectForKey:@"days"], [[[self.departments objectForKey:@"*"] objectAtIndex:indexPath.row] objectForKey:@"time"]];
            
            return cell;
        }
        else {
            static NSString *CellIdentifier = @"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
            }
            NSArray *indexArray = [[self.departments allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            cell.textLabel.text = [[self.departments objectForKey:[indexArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
            return cell;
        }
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        }
        cell.textLabel.text = [self.searchResults objectAtIndex:indexPath.row];
        return cell;
    }
}
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView)
    {
        NSString *str = [[[self.departments allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
        if ([str isEqualToString:@"*"])
            return @"Your registered courses";
        else return str;
    }
    else return @"Results";
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView)
    {
        if(indexPath.section == 0)
        {
            [self performSegueWithIdentifier:@"Course" sender:[tableView cellForRowAtIndexPath:indexPath]];
        }
        else 
        {
            [self performSegueWithIdentifier:@"Department" sender:[tableView cellForRowAtIndexPath:indexPath]];
        }
    }
    else 
    {
        [self performSegueWithIdentifier:@"Department" sender:[NSArray arrayWithObject:[tableView cellForRowAtIndexPath:indexPath]]];    
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[sender class] isSubclassOfClass:[NSArray class]])
    {
        sender = [sender objectAtIndex:0];
        ((CourseDetailViewController*)segue.destinationViewController).department = ((UITableViewCell*)sender).textLabel.text;
    }
    else if ([self.tableView indexPathForCell:((UITableViewCell*)sender)].section == 0)
    {
        ((CourseInfoViewController*)segue.destinationViewController).info = [[self.departments objectForKey:@"*"] objectAtIndex:[self.tableView indexPathForCell:((UITableViewCell*)sender)].row];
    }
    else {
        ((CourseDetailViewController*)segue.destinationViewController).department = ((UITableViewCell*)sender).textLabel.text;
    }
}
- (void)filterContentForSearchText:(NSString*)searchText 
                             scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate 
                                    predicateWithFormat:@"SELF contains[cd] %@",
                                    searchText];
    
    self.searchResults = [NSMutableArray arrayWithArray:[self.departmentNumbers filteredArrayUsingPredicate:resultPredicate]];
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
@end
