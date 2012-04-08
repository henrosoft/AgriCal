#import "WebcastListViewController.h"

@interface WebcastListViewController ()

@end

@implementation WebcastListViewController
@synthesize webcasts = _webcasts;
@synthesize url = _url;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
/*
    Load all the webcasts for the selected course from the API, 
    making sure that the list is sorted by lecture number, and that 
    if a lecture is missing it displays that. 
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.webcasts = [[NSUserDefaults standardUserDefaults] objectForKey:self.url];
    if (!self.webcasts) 
        self.webcasts = [[NSMutableArray alloc] init];
    NSString *queryString = [NSString stringWithFormat:@"%@/%@", ServerURL, self.url]; 
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
            self.webcasts = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONWritingPrettyPrinted error:nil]; 
            NSLog(@"%@", self.webcasts);
            // Making sure that the sort is done by lecture number and not alpha-numerical. 
            int i = 0;
            while (i < [self.webcasts count])
            {
                NSDictionary *currentDict = [self.webcasts objectAtIndex:i];
                [currentDict setValue:[NSNumber numberWithInt:[[currentDict objectForKey:@"number"] integerValue]] forKey:@"number"];
                i++;
            }
            NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"number"  ascending:YES];
            [self.webcasts sortUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
            [[NSUserDefaults standardUserDefaults] setValue:self.webcasts forKey:self.url];
            dispatch_queue_t updateUIQueue = dispatch_get_main_queue();
            dispatch_async(updateUIQueue, ^{
                [self.tableView reloadData];
            });
        }@catch (NSException *e) {
            NSLog(@"Error %@", e);
        }
    });
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
    return MAX([self.webcasts count], 1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    if ([self.webcasts count])
    {
        cell.textLabel.text = [NSString stringWithFormat:@"Lecture %@", [[self.webcasts objectAtIndex:indexPath.row] objectForKey:@"number"]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else 
    {
        cell.textLabel.text = @"Loading webcasts...";
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"test" sender:[tableView cellForRowAtIndexPath:indexPath]];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ((WebcastViewController*)segue.destinationViewController).url = [[self.webcasts objectAtIndex:[self.tableView indexPathForCell:(UITableViewCell*)sender].row] objectForKey:@"url"];
}
@end
