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
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Create the segmented control that occupies the navigation bar.
    NSArray *itemArray = [NSArray arrayWithObjects: @"Bus Schedule", @"Cal1Card Locations", nil];
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
	segmentedControl.frame = CGRectMake(2, 2, 308, 34);
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentedControl.selectedSegmentIndex = 0;
	[segmentedControl addTarget:self
	                     action:@selector(switchAnnotations:)
	           forControlEvents:UIControlEventValueChanged];
    self.annotationSelector = segmentedControl;
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
    [self.toolBar setItems:[NSArray arrayWithObject:barButton] animated:YES];
	
    // Allocate memory for all the arrays that keep track of the busstops. 
    self.busStops = [[NSMutableArray alloc] init];
    self.timePopUps = [[NSMutableArray alloc] init];
    self.cal1cardLocations = [[NSMutableArray alloc] init];
    
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
    NSArray *itemArray;
    UISegmentedControl *segmentedControl;
    UIBarButtonItem *barButton;
    switch (self.annotationSelector.selectedSegmentIndex) {
        case 0:
            [self.mapView addAnnotations:self.busStops];
            itemArray = [NSArray arrayWithObjects: @"Bus Schedule", @"Cal1Card Locations", nil];
            segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
            segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
            segmentedControl.selectedSegmentIndex = 0;
            [segmentedControl addTarget:self
                                 action:@selector(switchAnnotations:)
                       forControlEvents:UIControlEventValueChanged];
            self.annotationSelector = segmentedControl;
            barButton = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
            segmentedControl.frame = CGRectMake(2, 2, 308, 34);
            [self.toolBar setItems:[NSArray arrayWithObjects:barButton,nil] animated:YES];
            break;
        case 1:
            [self.mapView addAnnotations:self.cal1cardLocations];
            NSString *balance = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"cal1bal"]];
            if ([balance isEqualToString:@"-1"] || !balance)
                balance = @"N/A";
            else 
                balance = [NSString stringWithFormat:@"%@$", balance];
            itemArray = [NSArray arrayWithObjects: @"Bus Schedule", [NSString stringWithFormat:@"Balance: %@", balance], nil];
            segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
            segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
            segmentedControl.selectedSegmentIndex = 1;
            [segmentedControl addTarget:self
                                 action:@selector(switchAnnotations:)
                       forControlEvents:UIControlEventValueChanged];
            self.annotationSelector = segmentedControl;
            barButton = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
            segmentedControl.frame = CGRectMake(2, 2, 308, 34);
            [self.toolBar setItems:[NSArray arrayWithObjects:barButton,nil] animated:YES];
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
    NSString *balance = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"cal1bal"]];
    if ([balance isEqualToString:@"-1"] || !balance)
        balance = @"N/A";
    else 
        balance = [NSString stringWithFormat:@"%@$", balance];
    NSArray *itemArray = [NSArray arrayWithObjects: @"Bus Schedule", [NSString stringWithFormat:@"Balance: %@", balance], nil];
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentedControl.selectedSegmentIndex = 0;
	[segmentedControl addTarget:self
	                     action:@selector(switchAnnotations:)
	           forControlEvents:UIControlEventValueChanged];
    self.annotationSelector = segmentedControl;
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPushed:)];
    segmentedControl.frame = CGRectMake(2, 2, 250, 34);
    [self.toolBar setItems:[NSArray arrayWithObjects:barButton,doneButton,nil] animated:YES];
    [segmentedControl setEnabled:NO forSegmentAtIndex:0];
    [segmentedControl setEnabled:NO forSegmentAtIndex:1];
}
- (IBAction)doneButtonPushed:(id)sender
{
    // When the user taps the done button after viewing a website, this method returns the mapview and 
    // updates the segmented control. 
    [self.webView setHidden:YES];
    NSString *balance = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"cal1bal"]];
    if ([balance isEqualToString:@"-1"] || !balance)
        balance = @"N/A";
    else 
        balance = [NSString stringWithFormat:@"%@$", balance];
    NSArray *itemArray = [NSArray arrayWithObjects: @"Bus Schedule", [NSString stringWithFormat:@"Balance: %@", balance], nil];
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
	segmentedControl.frame = CGRectMake(2, 2, 308, 34);
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentedControl.selectedSegmentIndex = 1;
	[segmentedControl addTarget:self
	                     action:@selector(switchAnnotations:)
	           forControlEvents:UIControlEventValueChanged];
    self.annotationSelector = segmentedControl;
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
    [self.toolBar setItems:[NSArray arrayWithObject:barButton] animated:YES];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self.mapView removeAnnotations:self.timePopUps];
    ((ScheduleViewController*)segue.destinationViewController).items = ((BusStopAnnotation*)sender).nextBuses;
    ((ScheduleViewController*)segue.destinationViewController).delegate = self;
    ((ScheduleViewController*)segue.destinationViewController).stop = sender;    
}
- (void)viewDidUnload {
    [self setAnnotationSelector:nil];
    [self setWebView:nil];
    [self setToolBar:nil];
    [self setDoneButton:nil];
    [super viewDidUnload];
}
@end
