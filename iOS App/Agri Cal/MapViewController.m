#import "MapViewController.h"

@implementation MapViewController
@synthesize mapView;
@synthesize busstopCallout = _testCallout;
@synthesize busstopAnnotation = _testAnnotation;
@synthesize selectedAnnotation = _selectedAnnotation;
@synthesize busStops = _busStops;
@synthesize cal1cardLocations = _cal1cardLocations;
@synthesize annotationSelector = _annotationSelector;
@synthesize webView = _webView;
@synthesize doneButton = _doneButton;
@synthesize cal1Callout = _cal1Callout;
@synthesize timePopUps = _timePopUps;
@synthesize navigationBar = _navigationBar;
@synthesize searchBar = _searchBar;
@synthesize infoButton = _infoButton;
@synthesize mapKeyImageView = _mapKeyTableView;
@synthesize buildingAnnotation = _buildingAnnotation;
@synthesize searchResults = _searchResults;
@synthesize infoView = _libraryLabel;

static NSString *OffCampus = @"Off-Campus";
static NSString *OnCampus = @"On-campus by Cal Dining";

/* 
 When the view loads do all the initialization of arrays, set the region of the mapview, 
 load all the schedule and location information from the datasources and add annotations 
 to the mapview. 
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.busStops = [[NSMutableArray alloc] init];
    self.timePopUps = [[NSMutableArray alloc] init];
    self.cal1cardLocations = [[NSMutableArray alloc] init];
    self.searchResults = [[NSMutableArray alloc] init];
    
    self.mapView.delegate = self;
	CLLocationCoordinate2D coordinate = {38.315, -90.2045};
	[self.mapView setRegion:MKCoordinateRegionMake(coordinate, 
												   MKCoordinateSpanMake(1, 1))];  
    CLLocationCoordinate2D coord = {.latitude =  37.870218, .longitude =  -122.259481};
    MKCoordinateSpan span = {.latitudeDelta = 0.01, .longitudeDelta = 0.01};
    MKCoordinateRegion region = {coord, span};
    [self.mapView setRegion:region];
    
    NSString* plistpath = [[NSBundle mainBundle] pathForResource:@"Stops" ofType:@"plist"];
    NSDictionary* stops = [NSDictionary dictionaryWithContentsOfFile:plistpath];
    NSEnumerator* enumerator = [stops keyEnumerator];
    id stop;
    while ((stop = [enumerator nextObject]))
    {
        NSDictionary* current = [stops objectForKey:stop];
        NSNumber* longitude = [current objectForKey:@"long"];
        NSNumber* latitude = [current objectForKey:@"lat"];
        int index = [(NSNumber*)[current objectForKey:@"index"] integerValue];
        BasicMapAnnotation* ano = [[BasicMapAnnotation alloc] initWithLatitude:[latitude doubleValue] andLongitude:[longitude doubleValue] andRoutes:[current objectForKey:@"times"] andIndex:index];
        ano.title = stop;
        [self.busStops addObject:ano];	
    }
    
    plistpath = [[NSBundle mainBundle] pathForResource:@"Cal1CardLocations" ofType:@"plist"];
    stops = [NSDictionary dictionaryWithContentsOfFile:plistpath];
    enumerator = [stops keyEnumerator];
    while ((stop = [enumerator nextObject]))
    {
        NSDictionary* current = [stops objectForKey:stop];
        NSNumber* longitude = [current objectForKey:@"long"];
        NSNumber* latitude = [current objectForKey:@"lat"];
        Cal1CardAnnotation* ano = [[Cal1CardAnnotation alloc] initWithLatitude:[latitude doubleValue] andLongitude:[longitude doubleValue] andTitle:stop andURL:[current objectForKey:@"url"] andTimes:[current objectForKey:@"times"] andInfo:[current objectForKey:@"info"]];
        ano.type = [current objectForKey:@"type"];
        [self.cal1cardLocations addObject:ano];	
    }
    [self.mapView addAnnotations:self.busStops];
    
    self.mapView.showsUserLocation = YES;    
    
    self.infoView = [[InfoView alloc] initWithFrame:CGRectMake(0, 480, 320, 200)];
    self.infoView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.8];
    [self.view addSubview:self.infoView];
}

/*
 Handles the selection of the annotations and displays the correct popups.
 */
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([self.busStops containsObject:view.annotation])
    {   
        if (self.busstopCallout == nil) 
        {
            self.busstopCallout = [[BusStopAnnotation alloc] initWithLatitude:view.annotation.coordinate.latitude andLongitude:view.annotation.coordinate.longitude andRoutes:((BasicMapAnnotation*)view.annotation).routes andDelegate:self andIndex:((BasicMapAnnotation*)view.annotation).index];
            self.busstopCallout.title = view.annotation.title;
        }
        else {
            self.busstopCallout.title = view.annotation.title;
            self.busstopCallout.latitude = view.annotation.coordinate.latitude;
            self.busstopCallout.longitude = view.annotation.coordinate.longitude;
            self.busstopCallout.routes = ((BasicMapAnnotation*)view.annotation).routes;
            self.busstopCallout.routeIndex = ((BasicMapAnnotation*)view.annotation).index;
        }
        [self.mapView addAnnotation:self.busstopCallout];
        self.selectedAnnotation = view;
    }
    
    if ([self.cal1cardLocations containsObject:view.annotation])
    {
        if (self.cal1Callout == nil)
        {
            self.cal1Callout = [[Cal1CardAnnotation alloc] initWithLatitude:view.annotation.coordinate.latitude 
                                                               andLongitude:view.annotation.coordinate.longitude 
                                                                   andTitle:((BasicMapAnnotation*)view.annotation).title 
                                                                     andURL:((Cal1CardAnnotation*)view.annotation).imageURL 
                                                                   andTimes:((Cal1CardAnnotation*)view.annotation).times
                                                                    andInfo:((Cal1CardAnnotation*)view.annotation).info];
        } else {
            self.cal1Callout.latitude = view.annotation.coordinate.latitude;
            self.cal1Callout.longitude = view.annotation.coordinate.longitude;
            self.cal1Callout.title = view.annotation.title;
            self.cal1Callout.times = ((Cal1CardAnnotation*)view.annotation).times;
            self.cal1Callout.info = ((Cal1CardAnnotation*)view.annotation).info;
            self.cal1Callout.imageURL = ((Cal1CardAnnotation*)view.annotation).imageURL;
        }   
        [self.mapView addAnnotation:self.cal1Callout];
        self.selectedAnnotation = view;
    }
}
/*
 Deselects the selected annotation view, but has some custom code to prevent 
 deselection if the annotation wants to prevent it for reasons like that the 
 touch was to select a bus path etc. 
 */
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    // Make sure that the deselection wasn't as a result of a tab inside the callout table view, then deselect 
    // the correct annotation. 
    if (self.busstopCallout && [self.busStops containsObject:view.annotation] && !((BasicMapAnnotationView*)view).preventSelectionChange)
    {
        [self.mapView removeAnnotation:self.busstopCallout];
        [self.mapView removeAnnotations:self.timePopUps];
        for (BasicMapAnnotation *anno in self.mapView.annotations)
        {
            if ([anno class] == [BasicMapAnnotation class])
            {
                BasicMapAnnotationView *view = (BasicMapAnnotationView*)[self.mapView viewForAnnotation:anno];
                view.pinColor = MKPinAnnotationColorGreen;
            }
        }
    }
    if (self.cal1Callout && [self.cal1cardLocations containsObject:view.annotation] && !((BasicMapAnnotationView*)view).preventSelectionChange)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.75];
        CGRect frame = self.infoView.frame;
        if (!(frame.origin.y == 480))
            frame.origin.y += 240;
        self.infoView.frame = frame;
        [UIView commitAnimations];
        [self.mapView removeAnnotation:self.cal1Callout];
    }
}

/*
 A lot of customization code to display the correct views for the annotations,
 and prevents customization of the annotation that shows the user location. 
 */ 
-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    if (annotation == self.busstopCallout)
    {
        BusStopAnnotationView *callout = (BusStopAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"callout"];
        if (!callout)
        {
            callout = [[BusStopAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"callout"];
            callout.contentHeight = 78.0f; 
        }
        callout.parentAnnotationView = self.selectedAnnotation;
        callout.mapView = self.mapView;
        callout.tableView.delegate = ((BusStopAnnotation*)annotation);
        callout.tableView.dataSource = ((BusStopAnnotation*)annotation);
        [((BusStopAnnotation*)annotation) sortStops];
        [callout.tableView reloadData];
        
        return callout;
    }
    else if (annotation == self.buildingAnnotation) {
        
        MKPinAnnotationView *anno = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"building"];
        anno.canShowCallout = YES;
        return anno;
    }
    else if (annotation == self.cal1Callout) {
        Cal1CardAnnotationView *callout = (Cal1CardAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"cal1callout"];
        if (!callout)
        {
            callout = [[Cal1CardAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"cal1callout"];
            callout.contentHeight = 39.0f;
            callout.times = ((Cal1CardAnnotation*)annotation).times;
            callout.title = ((Cal1CardAnnotation*)annotation).title;
        }
        callout.times = ((Cal1CardAnnotation*)annotation).times;
        callout.title = ((Cal1CardAnnotation*)annotation).title;
        callout.parentAnnotationView = self.selectedAnnotation;
        callout.mapView = self.mapView;
        callout.textLabel.text = ((Cal1CardAnnotation*)annotation).title;
        callout.info = ((Cal1CardAnnotation*)annotation).info;
        callout.imageURL = ((Cal1CardAnnotation*)annotation).imageURL;
        return callout;
    }
    else if ([self.busStops containsObject:annotation]) 
    {
        MKPinAnnotationView *annotationView = [[BasicMapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"BusPin"];
        annotationView.canShowCallout = NO; 
        annotationView.pinColor = MKPinAnnotationColorGreen;
        return annotationView;
    }
    else if ([self.cal1cardLocations containsObject:annotation])
    {
        MKPinAnnotationView *annotationView = [[BasicMapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Cal1Pin"];
        annotationView.canShowCallout = NO; 
        if ([((Cal1CardAnnotation*)annotation).type isEqualToString:OffCampus])
            annotationView.pinColor = MKPinAnnotationColorRed;
        else if([((Cal1CardAnnotation*)annotation).type isEqualToString:OnCampus]) {
            annotationView.pinColor = MKPinAnnotationColorGreen;
        } else {
            annotationView.pinColor = MKPinAnnotationColorPurple;
        }
        return annotationView;  
    }
    else if ([self.timePopUps containsObject:annotation])
    {
        TimePopAnnotationView *callout = (TimePopAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"TimePop"];
        if (!callout)
        {
            callout = [[TimePopAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"TimePop"];
            callout.contentHeight = 39.0f;
            callout.titleLabel.text = annotation.title;
        }
        callout.titleLabel.text = annotation.title;
        callout.mapView = self.mapView;
        return callout;
    }
    return nil;
}

/*
 Takes an index of a time, busstop, and a line (perimeter, f, etc), and 
 highlights the path and displays the time pop ups. 
 */
- (void)highlightPath:(NSString *)path:(NSString*)indexes
{
    [self.mapView removeAnnotations:self.timePopUps];
    self.timePopUps = [[NSMutableArray alloc] init];
    NSString *timeIndex = [[indexes componentsSeparatedByString:@":"] objectAtIndex:0];
    NSString *routeIndex = [[indexes componentsSeparatedByString:@":"] objectAtIndex:1];
    NSString *pathName = path;
    NSLog(@"highlight path with start index %@ %@",indexes, path);
    for (BasicMapAnnotation *anno in self.busStops)
    {
        if ([anno.routes objectForKey:pathName])
        {
            NSArray *times = [anno.routes objectForKey:pathName];
            NSString *closestTime = @"N/A";
            
            if ([routeIndex integerValue] > anno.index) {
                if (!([timeIndex integerValue]+2 > [times count]))
                    closestTime = [times objectAtIndex:[timeIndex integerValue]+2];
            }
            else {
                closestTime = [times objectAtIndex:[timeIndex integerValue]];
            }
            
            BasicMapAnnotationView *view = (BasicMapAnnotationView*)[self.mapView viewForAnnotation:anno];
            // Make the pin red to show that the annotation is part of the path 
            view.pinColor = MKPinAnnotationColorRed;
            BasicMapAnnotation *v = [[BasicMapAnnotation alloc] initWithLatitude:anno.coordinate.latitude andLongitude:anno.coordinate.longitude andRoutes:nil andIndex:0];
            
            // If the specific bus that was selected never reaches this location, don't change the title
            if (![closestTime isEqualToString:@"N/A"])
                v.title = [NSString stringWithFormat:@"%@:%@", [[closestTime componentsSeparatedByString:@":"] objectAtIndex:0],[[closestTime componentsSeparatedByString:@":"] objectAtIndex:1]];
            else 
                v.title = closestTime;
            v.url = @"testing";
            
            // Do not add a popup for the selected annotation
            if (!(anno == self.selectedAnnotation.annotation))
                [self.timePopUps addObject:v];
        }
    }
    [self.mapView addAnnotations:self.timePopUps];
}

- (IBAction)displayMapKey:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    CGRect frame = self.mapKeyImageView.frame;
    if (frame.origin.x == 320)
        frame.origin.x -= frame.size.width;
    else {
        frame.origin.x += frame.size.width;
    }
    self.mapKeyImageView.frame = frame;
    [UIView commitAnimations];
}

/*
 Switched the annotations on the map and handles the title of the 
 segmented control in the title bar. 
 */
- (IBAction)switchAnnotations:(id)sender {
    [self.mapView removeAnnotations:self.busStops];
    [self.mapView removeAnnotations:self.cal1cardLocations];
    [self.mapView removeAnnotations:self.timePopUps];
    [self.infoButton setHidden:YES];
    if (self.buildingAnnotation)
        [self.mapView removeAnnotation:self.buildingAnnotation];
    [UIView beginAnimations:nil context:NULL];
    [self.searchDisplayController.searchBar setHidden:YES];
    [UIView commitAnimations];
    switch (self.annotationSelector.selectedSegmentIndex) {
        case 0:
        {
            [self.mapView addAnnotations:self.busStops];
            [self.annotationSelector setTitle:@"Cal1Card" forSegmentAtIndex:1];
        }
            break;
        case 1:
        {
            [self.infoButton setHidden:NO];
            [self.mapView addAnnotations:self.cal1cardLocations];
            NSString *balance = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"cal1bal"]];
            NSArray *components = [balance componentsSeparatedByString:@"."];
            if ([components count] >= 2)
                if ([[components objectAtIndex:1] length] > 2)
                    balance = [NSString stringWithFormat:@"%@.%@", [components objectAtIndex:0], [[components objectAtIndex:1] substringToIndex:2]];
            if ([balance isEqualToString:@"-1"] || !balance || [balance isEqualToString:@"(null)"])
                balance = @"N/A";
            else 
                balance = [NSString stringWithFormat:@"%@$", balance];
            [self.annotationSelector setTitle:balance forSegmentAtIndex:1]; 
        }
            break;
        case 2:
        {
            [self.annotationSelector setTitle:@"Cal1Card" forSegmentAtIndex:1];
            [UIView beginAnimations:nil context:NULL];
            [self.searchDisplayController.searchBar setHidden:NO];
            [UIView commitAnimations];
        }
            break;
    }
}

/*
 Display the website for the cal1card location that was selected. 
 */
- (void)displayInfo:(Cal1CardAnnotationView *)annotation
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.75];
    CGRect frame = self.infoView.frame;
    if (frame.origin.y == 480)
        frame.origin.y -= 240;
    else {
        frame.origin.y += 240;
    }
    self.infoView.frame = frame;
    self.infoView.textView.text = annotation.info;
    self.infoView.titleLabel.text = annotation.title;
    self.infoView.timesTextView.text = annotation.times;
    self.infoView.imageView.image = [UIImage imageNamed:annotation.imageURL];
    [UIView commitAnimations];
}
/*
 Remove the webview and return to the cal1card view. 
 */
- (IBAction)doneButtonPushed:(id)sender
{
    // When the user taps the done button after viewing a website, this method returns the mapview and 
    // updates the segmented control. 
    [self.webView setHidden:YES];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    NSString *balance = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"cal1bal"]];
    NSArray *components = [balance componentsSeparatedByString:@"."];
    if ([components count] >= 2)
        if ([[components objectAtIndex:1] length] > 2)
            balance = [NSString stringWithFormat:@"%@.%@", [components objectAtIndex:0], [[components objectAtIndex:1] substringToIndex:2]];
    if ([balance isEqualToString:@"-1"] || !balance || [balance isEqualToString:@"(null)"])
        balance = @"N/A";
    else 
        balance = [NSString stringWithFormat:@"%@$", balance];
    
    [self.annotationSelector setTitle:balance forSegmentAtIndex:1]; 
    
    [self.annotationSelector setEnabled:YES forSegmentAtIndex:0];
    [self.annotationSelector setEnabled:YES forSegmentAtIndex:1];
    [self.annotationSelector setSelectedSegmentIndex:1];
    CGRect frame = self.annotationSelector.frame;
    frame.size.width = 300;
    self.annotationSelector.frame = frame;
    self.navigationBar.rightBarButtonItem = nil;
    [UIView commitAnimations];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.searchBar resignFirstResponder];
}

/*
 Customize the table view that is displayed for the full schedule 
 of a busstop. 
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self.mapView removeAnnotations:self.timePopUps];
    ((ScheduleViewController*)segue.destinationViewController).items = ((BusStopAnnotation*)sender).nextBuses;
    ((ScheduleViewController*)segue.destinationViewController).delegate = self;
    ((ScheduleViewController*)segue.destinationViewController).stop = sender;    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(searchForBuilding) object:nil];
    [self performSelector:@selector(searchForBuilding)];
}

/*
 Uses the google maps api to search for buldings in Berkeley. 
 */
-(void)searchForBuilding
{
    NSString *searchString = self.searchDisplayController.searchBar.text;
    searchString = [NSString stringWithFormat:@"%@ %@", searchString, @"berkeley"];
    searchString = [searchString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([searchString isEqualToString:@"berkeley"])
        return;
    searchString = [[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true", searchString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url= [[NSURL alloc] initWithString:searchString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    @try {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
        dispatch_async(queue, ^{
            NSData *receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            if (receivedData)
                self.searchResults = [[NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONWritingPrettyPrinted error:nil] objectForKey:@"results"];
            dispatch_queue_t updateUIQueue = dispatch_get_main_queue();
            dispatch_async(updateUIQueue, ^{
                [self.searchDisplayController.searchResultsTableView reloadData];
            });
        });
    }
    @catch (NSException *exception) {
        NSLog(@"error");
    }
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(searchForBuilding) object:nil];
    [self performSelector:@selector(searchForBuilding) withObject:nil afterDelay:1.0];
}

/*
 Everything below here is related to the table view, and just handles 
 the customization of the cells etc. 
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchResults count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    if (![self.searchResults count])
        cell.textLabel.text = @"Searching...";
    else {
        NSLog(@"%@", [self.searchResults objectAtIndex:indexPath.row]);
        NSArray *partsOfName = [[[self.searchResults objectAtIndex:indexPath.row] objectForKey:@"formatted_address"] componentsSeparatedByString:@","];
        NSString *shortName = [partsOfName objectAtIndex:0];
        NSString *detailText = @"";
        if ([partsOfName count] > 3)
            detailText = [NSString stringWithFormat:@"%@,%@,%@", [partsOfName objectAtIndex:1], [partsOfName objectAtIndex:2], [partsOfName objectAtIndex:3]];
        else if([partsOfName count]>2)
            detailText = [NSString stringWithFormat:@"%@,%@", [partsOfName objectAtIndex:1], [partsOfName objectAtIndex:2]];
        else if([partsOfName count]>1)
            detailText = [NSString stringWithFormat:@"%@", [partsOfName objectAtIndex:1]];
        else
            detailText = @"";
        cell.textLabel.text = shortName;
        cell.detailTextLabel.text = detailText;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.buildingAnnotation)
    {
        [self.mapView deselectAnnotation:self.buildingAnnotation animated:NO];
        [self.mapView removeAnnotation:self.buildingAnnotation];
    }
    self.searchDisplayController.searchBar.text = @"";
    NSString *lat =  [[[[self.searchResults objectAtIndex:indexPath.row] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"];
    NSString *lng =  [[[[self.searchResults objectAtIndex:indexPath.row] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"];
    self.buildingAnnotation = [[BasicMapAnnotation alloc] initWithLatitude:[lat doubleValue] andLongitude:[lng doubleValue] andRoutes:nil andIndex:0];
    self.buildingAnnotation.title = [[[[self.searchResults objectAtIndex:indexPath.row] objectForKey:@"formatted_address"] componentsSeparatedByString:@","] objectAtIndex:0];
    [self.mapView addAnnotation:self.buildingAnnotation];
    [self.mapView setCenterCoordinate:self.buildingAnnotation.coordinate];    
    [self.searchDisplayController setActive:NO animated:YES];  
    self.searchResults = [[NSMutableArray alloc] init];
    [self performSelector:@selector(selectBuilding) withObject:nil afterDelay:0.7];
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Map Key";
}
-(void)selectBuilding
{
    [self.mapView selectAnnotation:self.buildingAnnotation animated:YES];  
}
- (void)viewDidUnload {
    [self setAnnotationSelector:nil];
    [self setWebView:nil];
    [self setDoneButton:nil];
    [self setNavigationBar:nil];
    [self setSearchBar:nil];
    [self setMapKeyImageView:nil];
    [self setInfoButton:nil];
    [super viewDidUnload];
}
@end
