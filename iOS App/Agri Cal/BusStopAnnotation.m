//
//  BusStopAnnotation.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BusStopAnnotation.h"

@implementation BusStopAnnotation
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize routes = _routes;
@synthesize nextBuses = _nextBuses;
@synthesize delegate = _delegate;
@synthesize title = _title;
@synthesize routeIndex = _routeIndex;

- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude
             andRoutes:(NSMutableDictionary*)routes
           andDelegate:(id)delegate
              andIndex:(NSInteger)index{
	if (self = [super init]) {
		self.latitude = latitude;
		self.longitude = longitude;
        self.routes = routes;
        self.nextBuses = [[NSMutableArray alloc] init];
        self.delegate = delegate;
        self.routeIndex = index;
	}
	return self;
}

- (CLLocationCoordinate2D)coordinate {
	CLLocationCoordinate2D coordinate;
	coordinate.latitude = self.latitude;
	coordinate.longitude = self.longitude;
	return coordinate;
}
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.title;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, tableView.frame.size.height)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    button.frame = CGRectMake(tableView.frame.size.width-button.frame.size.width, 0, button.frame.size.width, button.frame.size.height);
    [button addTarget:self action:@selector(displayRoute) forControlEvents:UIControlEventTouchUpInside];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16,0,tableView.frame.size.width-button.frame.size.width-16, button.frame.size.height)];
    label.text = [NSString stringWithFormat:@"%@", self.title];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor grayColor];
    [label setAdjustsFontSizeToFitWidth:NO];
    [view addSubview:label];
    [view addSubview:button];
    return view;
}
-(void)displayRoute
{
    [self.delegate performSegueWithIdentifier:@"times" sender:self];
}
- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return MIN([self.nextBuses count], 3);
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeCell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"TimeCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    NSArray *parts = [[self.nextBuses objectAtIndex:indexPath.row] componentsSeparatedByString:@":"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@:%@",[parts objectAtIndex:0], [parts objectAtIndex:1]];
    cell.detailTextLabel.text = [parts objectAtIndex:2];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(highlightPath::)])
    {
        NSString *pathSelected = [tableView cellForRowAtIndexPath:indexPath].detailTextLabel.text ;
        NSString *indexOfSelectedTime = [NSString stringWithFormat:@"%@:%@", [tableView cellForRowAtIndexPath:indexPath].textLabel.text, pathSelected];
        NSLog(@"%@", indexOfSelectedTime);
        NSString *indexes = [NSString stringWithFormat:@"%i:%i", [[self.routes objectForKey:pathSelected] indexOfObject:indexOfSelectedTime],self.routeIndex];
        [self.delegate performSelector:@selector(highlightPath::) withObject:[[tableView cellForRowAtIndexPath:indexPath] detailTextLabel].text withObject:indexes];
    }
}

/*
    The horribly intimidating code below is just a custom sorting function that makes the
    annotation display the next times based off of the current time. 
 */
- (void)sortStops
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:self.routes];
    self.nextBuses = nil;
    self.nextBuses = [[NSMutableArray alloc] init];
    for (NSString *key in dict)
    {
        [self.nextBuses addObjectsFromArray:[self.routes objectForKey:key]]; 
    }
    for (NSString *key in dict){
        unsigned int flags = NSHourCalendarUnit | NSMinuteCalendarUnit;
        NSDateComponents *currentTimeComponents = [[NSCalendar currentCalendar] components:flags fromDate:[NSDate date]];
        NSDate *currentTime = [[NSCalendar currentCalendar] dateFromComponents:currentTimeComponents];
        self.nextBuses = [[NSMutableArray alloc] initWithArray:[self.nextBuses sortedArrayUsingComparator:^NSComparisonResult(id a, id b)
                                                                {
                                                                    NSDateComponents *timeAComponents = [[NSDateComponents alloc] init]; 
                                                                    [timeAComponents setHour:[(NSString*)a integerValue]];
                                                                    [timeAComponents setMinute:[[[(NSString*)a componentsSeparatedByString:@":"] objectAtIndex:1] integerValue]];
                                                                    NSDateComponents *timeBComponents = [[NSDateComponents alloc] init]; 
                                                                    [timeBComponents setHour:[(NSString*)b integerValue]];
                                                                    [timeBComponents setMinute:[[[(NSString*)b componentsSeparatedByString:@":"] objectAtIndex:1] integerValue]];
                                                                    
                                                                    NSDate *dateA = [[NSCalendar currentCalendar] dateFromComponents:timeAComponents];
                                                                    NSDate *dateB = [[NSCalendar currentCalendar] dateFromComponents:timeBComponents];
                                                                    
                                                                    if ([[dateA earlierDate:currentTime] isEqualToDate:dateA] && [[dateB earlierDate:currentTime] isEqualToDate:dateB])
                                                                    {
                                                                        if ([dateA earlierDate:dateB] == dateA) {
                                                                            return NSOrderedAscending;
                                                                        }
                                                                        else 
                                                                            return NSOrderedDescending;
                                                                    }
                                                                    if ([[dateA earlierDate:currentTime] isEqualToDate:currentTime] && [[dateB earlierDate:currentTime] isEqualToDate:currentTime])
                                                                    {
                                                                        if ([dateA earlierDate:dateB] == dateA) {
                                                                            return NSOrderedAscending;
                                                                        }
                                                                        else 
                                                                            return NSOrderedDescending;
                                                                    }
                                                                    else if ([[dateA earlierDate:currentTime] isEqualToDate:dateA] && [[dateB earlierDate:currentTime] isEqualToDate:currentTime])
                                                                    {
                                                                        return NSOrderedDescending;
                                                                    }
                                                                    else 
                                                                    {
                                                                        return NSOrderedAscending;
                                                                    }
                                                                    
                                                                }]];
    }
}

@end
