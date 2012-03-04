#import "CalloutMapAnnotation.h"

@interface CalloutMapAnnotation()


@end

@implementation CalloutMapAnnotation

@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize name = _name;
@synthesize stops = _stops;
@synthesize nextBuses = _nextBuses;
@synthesize preventSelectionChange = _preventSelectionChange;
@synthesize delegate = _delegate;

- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude
               andName:(NSString*)name
              andStops:(NSDictionary*)stops
           andDelegate:(id)delegate{
	if (self = [super init]) {
		self.latitude = latitude;
		self.longitude = longitude;
        self.name = name;
        self.stops = [[NSMutableDictionary alloc] initWithDictionary:stops];
        self.nextBuses = [[NSMutableArray alloc] init];
        self.delegate = delegate;
	}
	return self;
}

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier])
    {
        self.latitude = ((CalloutMapAnnotation*)annotation).latitude;
        self.longitude = ((CalloutMapAnnotation*)annotation).longitude;
        self.name = ((CalloutMapAnnotation*)annotation).name;
        self.stops = ((CalloutMapAnnotation*)annotation).stops;
        self.nextBuses = ((CalloutMapAnnotation*)annotation).nextBuses;
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate {
	CLLocationCoordinate2D coordinate;
	coordinate.latitude = self.latitude;
	coordinate.longitude = self.longitude;
	return coordinate;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (!self.preventSelectionChange)
        [super setSelected:selected animated:animated];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Normal"];
    cell.textLabel.text = @"testing";
    int offset = 0;
    if ([self.stops objectForKey:@"perimeter"] != nil)
    {
        cell.textLabel.text = [self.nextBuses objectAtIndex:indexPath.row];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"wtf %@", self.delegate);
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *stop = cell.textLabel.text;
    [self.delegate performSelector:@selector(highlightStops:) withObject:stop];
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
}

@end
