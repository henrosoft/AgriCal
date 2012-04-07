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
@synthesize departmentAbbreviations = _departmentNumbers;
@synthesize searchResults = _searchResults;
@synthesize segmentedControl = _segmentedControl;
@synthesize personalCourses = _personalCourses;
@synthesize departmentTitles = _departmentTitles;
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *semester = [[[self.segmentedControl titleForSegmentAtIndex:[self.segmentedControl selectedSegmentIndex]] componentsSeparatedByString:@" "] objectAtIndex:0];
    NSArray *oldPersonal = [[NSUserDefaults standardUserDefaults] objectForKey:semester];
    if (!oldPersonal)
        oldPersonal = [[NSArray alloc] init];

    self.personalCourses = [NSMutableArray arrayWithArray:oldPersonal];

    self.departments = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"departments"]];
    self.departmentAbbreviations = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"departmentNum"]];  
    self.departmentTitles = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"departmentTitles"]];
    [self.departments setObject:self.personalCourses forKey:@"*"];
    [self.tableView reloadData];
    
    if ([self.departments count] <= 10)
    {
        [self performSelector:@selector(loadDepartments)];
    }
    [self performSelector:@selector(loadPersonalCourses)];
}
- (void)loadDepartments
{
    NSString *semester = [[[self.segmentedControl titleForSegmentAtIndex:[self.segmentedControl selectedSegmentIndex]] componentsSeparatedByString:@" "] objectAtIndex:0];
    
    self.searchResults = [[NSMutableArray alloc] init];
    self.navigationItem.title = @"Departments";
    if (!self.departments || [[self.departments allKeys] count] <= 10){
        self.departments = [[NSMutableDictionary alloc] init];
        self.departmentAbbreviations = [[NSMutableDictionary alloc] init];
        self.departmentTitles = [[NSMutableArray alloc] init];
        NSString *queryString = [NSString stringWithFormat:@"%@/api/courses/departments/%@/", ServerURL, semester];
        NSURL *requestURL = [NSURL URLWithString:queryString];
        NSURLRequest *jsonRequest = [NSURLRequest requestWithURL:requestURL];
        
        // Use GCD to perform request in background, and then jump back on the main thread 
        // to update the UI
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
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
                    NSString *abbreviation = [depArr objectAtIndex:1];
                    if([title isEqualToString:@""] || !title)
                        continue;
                    NSString *firstLetter = [title substringToIndex:1];
                    if ([self.departments objectForKey:firstLetter])
                    {
                        [self.departmentAbbreviations setObject:abbreviation forKey:title];
                        [self.departmentTitles addObject:title];
                        [[self.departments objectForKey:firstLetter] addObject:title];
                        [[self.departments objectForKey:firstLetter] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
                    }
                    else
                    {
                        [self.departmentAbbreviations setObject:abbreviation forKey:title];
                        [self.departmentTitles addObject:title];
                        [self.departments setObject:[NSMutableArray arrayWithObjects:title,nil] forKey:firstLetter];
                    }
                }
                [self.departments setObject:self.personalCourses forKey:@"*"];
                dispatch_queue_t updateUIQueue = dispatch_get_main_queue();
                dispatch_async(updateUIQueue, ^{
                    [self.tableView reloadData];
                });
            }
            @catch (NSException *e) {
                NSLog(@"error %@", e);
            }
            [[NSUserDefaults standardUserDefaults] setObject:self.departments forKey:@"departments"];
            [[NSUserDefaults standardUserDefaults] setObject:self.departmentAbbreviations forKey:@"departmentNum"]; 
            [[NSUserDefaults standardUserDefaults] setObject:self.departmentTitles forKey:@"departmentTitles"];
        });
    }
}
-(void)loadPersonalCourses
{
    NSLog(@"loading personal courses");
    NSString *semester = [[[self.segmentedControl titleForSegmentAtIndex:[self.segmentedControl selectedSegmentIndex]] componentsSeparatedByString:@" "] objectAtIndex:0];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        @try {
            NSURLResponse *response = nil;
            NSError *error = nil;
            NSString *queryString = [NSString stringWithFormat:@"%@/api/schedule/%@/",ServerURL, semester];
            
            NSString *post = [NSString stringWithFormat:@"username=%@&password=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"username"], [[NSUserDefaults standardUserDefaults] objectForKey:@"password"]];
            NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            
            NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:[NSURL URLWithString:queryString]];
            [request setHTTPMethod:@"POST"];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            
            [request setHTTPBody:postData];
            NSData *receivedData = [NSURLConnection sendSynchronousRequest:request
                                                         returningResponse:&response
                                                                     error:&error];
            NSMutableArray *dict = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONWritingPrettyPrinted error:&error];
            
            dict = [NSMutableArray arrayWithArray:dict];
            NSDictionary *toRemove = nil;
            for(NSDictionary *current in dict)
            {
                if([[current objectForKey:@"title"] isEqualToString:@""])
                    toRemove = current;
                if (toRemove)
                    [dict removeObject:toRemove];
            }
            [self.departments setObject:dict forKey:@"*"];
            NSLog(@"setting %@", dict);
            dispatch_queue_t updateUIQueue = dispatch_get_main_queue();
            dispatch_async(updateUIQueue, ^{
                [self.tableView reloadData];
            });
            [[NSUserDefaults standardUserDefaults] setObject:dict forKey:semester];                
        }
        @catch (NSException *e) {
            NSLog(@"error %@", e);
        }         
    });
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
    [self setSegmentedControl:nil];
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
        return MAX([self.departments count],1);
    else 
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == self.tableView)
    {
        NSArray *indexArray = [[self.departments allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        if ([indexArray count])
            return [[self.departments objectForKey:[indexArray objectAtIndex:section]] count];
        else 
            return 1;
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
        if (![[self.departments allKeys] count])
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Loading"];
            if (!cell){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Loading"];
                cell.backgroundColor = [UIColor whiteColor];
            }
            cell.textLabel.text = @"Loading departments...";
            
            return cell; 
        }
        if (indexPath.section == 0)
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Personal"];
            if (!cell){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Personal"];
                cell.backgroundColor = [UIColor whiteColor];
            }
            cell.textLabel.text = [[[self.departments objectForKey:@"*"] objectAtIndex:indexPath.row] objectForKey:@"title"];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",[[[self.departments objectForKey:@"*"] objectAtIndex:indexPath.row] objectForKey:@"days"], [[[self.departments objectForKey:@"*"] objectAtIndex:indexPath.row] objectForKey:@"time"]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            NSString *webcast = [NSString stringWithFormat:@"%@ %@",[[[self.departments objectForKey:@"*"] objectAtIndex:indexPath.row] objectForKey:@"days"], [[[self.departments objectForKey:@"*"] objectAtIndex:indexPath.row] objectForKey:@"webcast"]];
            if (![webcast isEqualToString:@" false"])
                cell.imageView.image = [UIImage imageNamed:@"monitor.png"];
            else 
                cell.imageView.image = nil;
            return cell;
        }
        else {
            static NSString *CellIdentifier = @"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
                cell.backgroundColor = [UIColor whiteColor];
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
        NSString *str = @"";
        if ([[self.departments allKeys] count])
            str = [[[self.departments allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
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
    NSString *semester = [[[self.segmentedControl titleForSegmentAtIndex:[self.segmentedControl selectedSegmentIndex]] componentsSeparatedByString:@" "] objectAtIndex:0];
    if ([[sender class] isSubclassOfClass:[NSArray class]])
    {
        sender = [sender objectAtIndex:0];
        ((CourseDetailViewController*)segue.destinationViewController).department = [self.departmentAbbreviations objectForKey:((UITableViewCell*)sender).textLabel.text];
        ((CourseDetailViewController*)segue.destinationViewController).semester = semester;
        ((CourseDetailViewController*)segue.destinationViewController).navigationItem.title = ((UITableViewCell*)sender).textLabel.text;        
    }
    else if ([self.tableView indexPathForCell:((UITableViewCell*)sender)].section == 0)
    {
        ((CourseInfoViewController*)segue.destinationViewController).info = [[self.departments objectForKey:@"*"] objectAtIndex:[self.tableView indexPathForCell:((UITableViewCell*)sender)].row];
        ((CourseDetailViewController*)segue.destinationViewController).navigationItem.title = ((UITableViewCell*)sender).textLabel.text;           
    }
    else {
        ((CourseDetailViewController*)segue.destinationViewController).department = [self.departmentAbbreviations objectForKey:((UITableViewCell*)sender).textLabel.text];
        ((CourseDetailViewController*)segue.destinationViewController).semester = semester;        
        ((CourseDetailViewController*)segue.destinationViewController).navigationItem.title = ((UITableViewCell*)sender).textLabel.text;        
    }
}
- (void)filterContentForSearchText:(NSString*)searchText 
                             scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate 
                                    predicateWithFormat:@"SELF contains[cd] %@",
                                    searchText];
    
    self.searchResults = [NSMutableArray arrayWithArray:[self.departmentTitles filteredArrayUsingPredicate:resultPredicate]];
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
- (IBAction)selectedSemester:(id)sender {
    NSString *semester = [[[self.segmentedControl titleForSegmentAtIndex:[self.segmentedControl selectedSegmentIndex]] componentsSeparatedByString:@" "] objectAtIndex:0];
    self.personalCourses = [[NSUserDefaults standardUserDefaults] objectForKey:semester];
    if (!self.personalCourses)
        self.personalCourses = [[NSMutableArray alloc] init];
    [self.departments setObject:self.personalCourses forKey:@"*"];
    [self.tableView reloadData];
    [self performSelector:@selector(loadPersonalCourses)];
}
@end
