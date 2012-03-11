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
- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude
             andRoutes:(NSMutableDictionary*)routes
           andDelegate:(id)delegate{
	if (self = [super init]) {
		self.latitude = latitude;
		self.longitude = longitude;
        self.routes = routes;
        self.nextBuses = [[NSMutableArray alloc] init];
        self.delegate = delegate;
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return MIN([self.nextBuses count], 5);
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeCell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TimeCell"];
    }
    cell.textLabel.text = [self.nextBuses objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%i", [[self.delegate performSelector:@selector(busStops)] indexOfObject:self]);
    if ([self.delegate respondsToSelector:@selector(highlightPath:)])
        [self.delegate performSelector:@selector(highlightPath:) withObject:[[tableView cellForRowAtIndexPath:indexPath] textLabel].text];
}

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
