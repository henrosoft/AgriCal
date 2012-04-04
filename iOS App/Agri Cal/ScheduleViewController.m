//
//  ScheduleViewController.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 3/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScheduleViewController.h"

@interface ScheduleViewController ()

@end

@implementation ScheduleViewController
@synthesize items = _items;
@synthesize tableView = _tableView;
@synthesize delegate = _delegate;
@synthesize stop = _stop;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
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
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    cell.detailTextLabel.text = [[[self.items objectAtIndex:indexPath.row] componentsSeparatedByString:@":"] objectAtIndex:2];
    cell.textLabel.text = [NSString stringWithFormat:@"%@:%@", [[[self.items objectAtIndex:indexPath.row] componentsSeparatedByString:@":"] objectAtIndex:0], [[[self.items objectAtIndex:indexPath.row] componentsSeparatedByString:@":"] objectAtIndex:1]];
    
    return cell;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Full Schedule";
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(highlightPath::)])
    {
        NSString *pathSelected = [tableView cellForRowAtIndexPath:indexPath].detailTextLabel.text ;
        NSString *indexOfSelectedTime = [NSString stringWithFormat:@"%@:%@", [tableView cellForRowAtIndexPath:indexPath].textLabel.text, pathSelected];
        NSString *indexes = [NSString stringWithFormat:@"%i:%i", [[self.stop.routes objectForKey:pathSelected] indexOfObject:indexOfSelectedTime],self.stop.routeIndex];
        [self.delegate performSelector:@selector(highlightPath::) withObject:[[tableView cellForRowAtIndexPath:indexPath] detailTextLabel].text withObject:indexes];
        [((FirstViewController*)self.delegate) dismissModalViewControllerAnimated:YES];
    }
}

@end
