#import "CalloutMapAnnotation.h"

@interface CalloutMapAnnotation()


@end

@implementation CalloutMapAnnotation

@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize name = _name;
@synthesize stops = _stops;
@synthesize nextBuses = _nextBuses;

- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude
               andName:(NSString*)name
              andStops:(NSDictionary*)stops{
	if (self = [super init]) {
		self.latitude = latitude;
		self.longitude = longitude;
        self.name = name;
        self.stops = [[NSMutableDictionary alloc] initWithDictionary:stops];
        self.nextBuses = [[NSMutableArray alloc] init];
	}
	return self;
}

- (CLLocationCoordinate2D)coordinate {
	CLLocationCoordinate2D coordinate;
	coordinate.latitude = self.latitude;
	coordinate.longitude = self.longitude;
	return coordinate;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Normal"];
    cell.textLabel.text = @"testing";
    if ([self.stops objectForKey:@"perimeter"] != nil)
    {
        cell.textLabel.text = [[self.nextBuses objectAtIndex:indexPath.row] objectAtIndex:1];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)sortStops
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:self.stops];
    self.nextBuses = nil;
    self.nextBuses = [[NSMutableArray alloc] init];
    for (NSString *key in dict)
    {
        [self.nextBuses addObjectsFromArray:[self.stops objectForKey:key]]; 
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
    NSLog(@"%@", self.nextBuses);
}

@end
