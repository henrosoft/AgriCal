//
//  FirstViewController.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
// 

/* This controller manages the map view and all the related map annotations. */

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController
@synthesize mapView;
@synthesize testCallout = _testCallout;
@synthesize testAnnotation = _testAnnotation;
@synthesize selectedAnnotation = _selectedAnnotation;
@synthesize busStops = _busStops;
@synthesize cal1cardLocations = _cal1cardLocations;
@synthesize annotationSelector = _annotationSelector;
@synthesize webView = _webView;
@synthesize doneButton = _doneButton;
@synthesize toolBar = _toolBar;
@synthesize cal1Callout = _cal1Callout;
@synthesize timePopUps = _timePopUps;
@synthesize navigationBar = _navigationBar;
@synthesize searchBar = _searchBar;
@synthesize buildingAnnotation = _buildingAnnotation;
@synthesize searchResults = _searchResults;
- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Allocate memory for all the arrays that keep track of the busstops. 
    self.busStops = [[NSMutableArray alloc] init];
    self.timePopUps = [[NSMutableArray alloc] init];
    self.cal1cardLocations = [[NSMutableArray alloc] init];
    self.searchResults = [[NSMutableArray alloc] init];
    // Initialize the mapview and set it up to focus on Berkeley.
    self.mapView.delegate = self;
	CLLocationCoordinate2D coordinate = {38.315, -90.2045};
	[self.mapView setRegion:MKCoordinateRegionMake(coordinate, 
												   MKCoordinateSpanMake(1, 1))];  
    CLLocationCoordinate2D coord = {.latitude =  37.870218, .longitude =  -122.259481};
    MKCoordinateSpan span = {.latitudeDelta = 0.01, .longitudeDelta = 0.01};
    MKCoordinateRegion region = {coord, span};
    [self.mapView setRegion:region];
    
    // Load the schedule information from the included plist. 
    NSString* plistpath = [[NSBundle mainBundle] pathForResource:@"Stops" ofType:@"plist"];
    NSDictionary* stops = [NSDictionary dictionaryWithContentsOfFile:plistpath];
    NSEnumerator* enumerator = [stops keyEnumerator];
    id stop;
    // For each object in the plist, add a busstopannotion that represents it. 
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
    
    // Load the information about the cal1card locations from a plist. 
    plistpath = [[NSBundle mainBundle] pathForResource:@"Cal1CardLocations" ofType:@"plist"];
    stops = [NSDictionary dictionaryWithContentsOfFile:plistpath];
    enumerator = [stops keyEnumerator];
    while ((stop = [enumerator nextObject]))
    {
        NSDictionary* current = [stops objectForKey:stop];
        NSNumber* longitude = [current objectForKey:@"long"];
        NSNumber* latitude = [current objectForKey:@"lat"];
        BasicMapAnnotation* ano = [[BasicMapAnnotation alloc] initWithLatitude:[latitude doubleValue] andLongitude:[longitude doubleValue] andRoutes:[[NSMutableDictionary alloc] init] andIndex:0];
        ano.url = [current objectForKey:@"url"];
        ano.title = stop;
        [self.cal1cardLocations addObject:ano];	
    }
    [self.mapView addAnnotations:self.busStops];
    
    self.mapView.showsUserLocation = YES;    
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    // If the selected annotation is a busstop, display the appropriate callout. 
    if ([self.busStops containsObject:view.annotation])
    {
        if (self.testCallout == nil) 
        {
            self.testCallout = [[BusStopAnnotation alloc] initWithLatitude:view.annotation.coordinate.latitude andLongitude:view.annotation.coordinate.longitude andRoutes:((BasicMapAnnotation*)view.annotation).routes andDelegate:self andIndex:((BasicMapAnnotation*)view.annotation).index];
            self.testCallout.title = view.annotation.title;
        }
        else {
            self.testCallout.title = view.annotation.title;
            self.testCallout.latitude = view.annotation.coordinate.latitude;
            self.testCallout.longitude = view.annotation.coordinate.longitude;
            self.testCallout.routes = ((BasicMapAnnotation*)view.annotation).routes;
            self.testCallout.routeIndex = ((BasicMapAnnotation*)view.annotation).index;
        }
        
        [self.mapView addAnnotation:self.testCallout];
        self.selectedAnnotation = view;
    }
    // If the selected annotation is a cal1card location, display the appropriate callout. 
    if ([self.cal1cardLocations containsObject:view.annotation])
    {
        if (self.cal1Callout == nil)
        {
            self.cal1Callout = [[Cal1CardAnnotation alloc] initWithLatitude:view.annotation.coordinate.latitude andLongitude:view.annotation.coordinate.longitude andTitle:((BasicMapAnnotation*)view.annotation).title andURL:((BasicMapAnnotation*)view.annotation).url];
        } else {
            self.cal1Callout.latitude = view.annotation.coordinate.latitude;
            self.cal1Callout.longitude = view.annotation.coordinate.longitude;
            self.cal1Callout.title = view.annotation.title;
            self.cal1Callout.url = ((BasicMapAnnotation*)view.annotation).url;
        }   
        [self.mapView addAnnotation:self.cal1Callout];
        self.selectedAnnotation = view;
    }
}
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    // Make sure that the deselection wasn't as a result of a tab inside the callout table view, then deselect 
    // the correct annotation. 
    if (self.testCallout && [self.busStops containsObject:view.annotation] && !((BasicMapAnnotationView*)view).preventSelectionChange)
    {
        [self.mapView removeAnnotation:self.testCallout];
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
        [self.mapView removeAnnotation:self.cal1Callout];
    }
    if (view.annotation == self.buildingAnnotation)
        [self.mapView removeAnnotation:self.buildingAnnotation];
}

-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    // This is a lot of customization code that allows for all the different kinds of annotations
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    if (annotation == self.testCallout)
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
        return anno;
    }
    else if (annotation == self.cal1Callout) {
        Cal1CardAnnotationView *callout = (Cal1CardAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"cal1callout"];
        if (!callout)
        {
            callout = [[Cal1CardAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"cal1callout"];
            callout.contentHeight = 39.0f;
            callout.url = ((BasicMapAnnotation*)annotation).url;
            callout.title = ((BasicMapAnnotation*)annotation).title;
        }
        callout.url = ((BasicMapAnnotation*)annotation).url;
        callout.title = ((BasicMapAnnotation*)annotation).title;
        callout.parentAnnotationView = self.selectedAnnotation;
        callout.mapView = self.mapView;
        callout.textLabel.text = ((BasicMapAnnotation*)annotation).title;
        
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
        annotationView.pinColor = MKPinAnnotationColorPurple;
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

- (void)highlightPath:(NSString *)path:(NSString*)indexes
{
    // This method allows for a selected path to be highlighted, making sure that 
    // the correct times are displayed etc. 
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
            view.pinColor = MKPinAnnotationColorRed;
            BasicMapAnnotation *v = [[BasicMapAnnotation alloc] initWithLatitude:anno.coordinate.latitude andLongitude:anno.coordinate.longitude andRoutes:nil andIndex:0];
            if (![closestTime isEqualToString:@"N/A"])
                v.title = [NSString stringWithFormat:@"%@:%@", [[closestTime componentsSeparatedByString:@":"] objectAtIndex:0],[[closestTime componentsSeparatedByString:@":"] objectAtIndex:1]];
            else 
                v.title = closestTime;
            v.url = @"testing";
            if (!(anno == self.selectedAnnotation.annotation))
                [self.timePopUps addObject:v];
        }
    }
    [self.mapView addAnnotations:self.timePopUps];
}

- (IBAction)switchAnnotations:(id)sender {
    
    // Basically does what the method name says, removes the current annotations then adds new 
    // ones depending on which alternative is selected. 
    [self.mapView removeAnnotations:self.busStops];
    [self.mapView removeAnnotations:self.cal1cardLocations];
    [self.mapView removeAnnotations:self.timePopUps];
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
            [self.mapView addAnnotations:self.cal1cardLocations];
            NSString *balance = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"cal1bal"]];
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
- (void)displayWebsite:(NSString *)url
{
    // Displays the website that is related to the specified url. 
    NSURL *u = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:u];
    [self.webView setHidden:NO];
    [self.webView loadRequest:request];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    self.navigationBar.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonPushed:)];
    [self.annotationSelector setEnabled:NO forSegmentAtIndex:0];
    [self.annotationSelector setEnabled:NO forSegmentAtIndex:1];
    [UIView commitAnimations];
    NSString *balance = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"cal1bal"]];
    if ([balance isEqualToString:@"-1"] || !balance || [balance isEqualToString:@"(null)"])
        balance = @"N/A";
    else 
        balance = [NSString stringWithFormat:@"%@$", balance];
    [self.annotationSelector setTitle:balance forSegmentAtIndex:1]; 
    
}
- (IBAction)doneButtonPushed:(id)sender
{
    // When the user taps the done button after viewing a website, this method returns the mapview and 
    // updates the segmented control. 
    [self.webView setHidden:YES];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    NSString *balance = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"cal1bal"]];
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure that the correct stop is used to display the full schedule.
    [self.mapView removeAnnotations:self.timePopUps];
    ((ScheduleViewController*)segue.destinationViewController).items = ((BusStopAnnotation*)sender).nextBuses;
    ((ScheduleViewController*)segue.destinationViewController).delegate = self;
    ((ScheduleViewController*)segue.destinationViewController).stop = sender;    
}
UIGestureRecognizer* cancelGesture;

- (void) backgroundTouched:(id)sender {
    [self.view endEditing:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(searchForBuilding) object:nil];
    [self performSelector:@selector(searchForBuilding)];
}
-(void)searchForBuilding
{
    NSString *searchString = [searchString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    searchString = [NSString stringWithFormat:@"%@ %@", searchString, @"berkeley"];
    searchString = [[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true", searchString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@", searchString);
    //if (![searchString isEqualToString:@""])
    NSURL *url= [[NSURL alloc] initWithString:searchString];
    NSLog(@"%@", url);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    @try {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
        dispatch_async(queue, ^{
            NSData *receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            if (receivedData)
                self.searchResults = [[NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONWritingPrettyPrinted error:nil] objectForKey:@"results"];
            //NSLog(@"%@", self.searchResults);
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchResults count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(searchForBuilding) object:nil];
    [self performSelector:@selector(searchForBuilding) withObject:nil afterDelay:1.0];
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
        //self.buildingAnnotation = [[BasicMapAnnotation alloc] initWithLatitude:[lat floatValue] andLongitude:[lng floatValue] andRoutes:nil andIndex:0];
        //[self.mapView addAnnotation:self.buildingAnnotation];
        //[self.mapView setCenterCoordinate:self.buildingAnnotation.coordinate];
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
- (void)viewDidUnload {
    [self setAnnotationSelector:nil];
    [self setWebView:nil];
    [self setToolBar:nil];
    [self setDoneButton:nil];
    [self setNavigationBar:nil];
    [self setSearchBar:nil];
    [super viewDidUnload];
}
@end
