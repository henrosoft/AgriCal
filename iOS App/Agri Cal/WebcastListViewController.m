//
//  WebcastListViewController.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 3/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.webcasts = [[NSArray alloc] init];
    NSString *queryString = [NSString stringWithFormat:@"http://127.0.0.1:8000/%@", self.url]; 
    NSLog(@"%@",queryString);
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
        dispatch_queue_t updateUIQueue = dispatch_get_main_queue();
        dispatch_async(updateUIQueue, ^{
            [self.tableView reloadData];
        });
        }@catch (NSException *e) {
            NSLog(@"Error");
        }
    });
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.webcasts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"Lecture %@", [[self.webcasts objectAtIndex:indexPath.row] objectForKey:@"number"]];
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
