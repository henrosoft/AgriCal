//
//  FirstViewController.m
//  The Lair
//
//  Created by Daniela Molinaro on 2/23/12.
//  Copyright (c) 2012 UC Berkeley. All rights reserved.
//

#import "GetAroundController.h"

@interface GetAroundController ()
    @property (nonatomic, retain) CalloutMapAnnotation *calloutAnnotation;
    @property (nonatomic, retain) BasicMapAnnotation *customAnnotation;
    @property (nonatomic, retain) BasicMapAnnotation *normalAnnotation;
@end

@implementation GetAroundController
@synthesize mapView;
@synthesize calloutAnnotation = _calloutAnnotation;
@synthesize selectedAnnotationView = _selectedAnnotationView;
@synthesize annotationSelector = _annotationSelector;
@synthesize customAnnotation = _customAnnotation;
@synthesize normalAnnotation = _normalAnnotation;
@synthesize cal1Annotations = _cal1Annotations;
@synthesize busAnnotations = _busAnnotations;
@synthesize wifiAnnotations = _wifiAnnotations;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;

	CLLocationCoordinate2D coordinate = {38.315, -90.2045};
	[self.mapView setRegion:MKCoordinateRegionMake(coordinate, 
												   MKCoordinateSpanMake(1, 1))];  
    CLLocationCoordinate2D coord = {.latitude =  37.870218, .longitude =  -122.259481};
    MKCoordinateSpan span = {.latitudeDelta = 0.01, .longitudeDelta = 0.001};
    MKCoordinateRegion region = {coord, span};
    [self.mapView setRegion:region];
    self.busAnnotations = [[NSMutableArray alloc] init];
    self.wifiAnnotations = [[NSMutableArray alloc] init];
    self.cal1Annotations = [[NSMutableArray alloc] init];
    
    NSString* plistpath = [[NSBundle mainBundle] pathForResource:@"Perimeter" ofType:@"plist"];
    NSDictionary* stops = [NSDictionary dictionaryWithContentsOfFile:plistpath];
    NSEnumerator* enumerator = [stops keyEnumerator];
    id stop;
    while ((stop = [enumerator nextObject]))
    {
        NSDictionary* current = [stops objectForKey:stop];
        NSNumber* longitude = [current objectForKey:@"long"];
        NSNumber* latitude = [current objectForKey:@"lat"];
        CalloutMapAnnotation* ano = [[CalloutMapAnnotation alloc] initWithLatitude:[latitude doubleValue] andLongitude:[longitude doubleValue] andName:stop andStops:[current objectForKey:@"times"]];
        [self.busAnnotations addObject:ano];	
    }
    plistpath = [[NSBundle mainBundle] pathForResource:@"Cal1CardLocations" ofType:@"plist"];
    stops = [NSDictionary dictionaryWithContentsOfFile:plistpath];
    enumerator = [stops keyEnumerator];
    while ((stop = [enumerator nextObject]))
    {
        NSDictionary* current = [stops objectForKey:stop];
        NSNumber* longitude = [current objectForKey:@"long"];
        NSNumber* latitude = [current objectForKey:@"lat"];
        CalloutMapAnnotation* ano = [[CalloutMapAnnotation alloc] initWithLatitude:[latitude doubleValue] andLongitude:[longitude doubleValue] andName:stop andStops:nil];
        [self.cal1Annotations addObject:ano];	
    }
    [self.mapView addAnnotations:self.busAnnotations];
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    self.calloutAnnotation = nil;
    CalloutMapAnnotation* annotation = (CalloutMapAnnotation*)view.annotation;
    self.calloutAnnotation = [[CalloutMapAnnotation alloc] initWithLatitude:annotation.coordinate.latitude andLongitude:annotation.coordinate.longitude andName:[annotation name] andStops:annotation.stops];
    [self.mapView addAnnotation:self.calloutAnnotation];
    self.selectedAnnotationView = view;
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    [self.mapView removeAnnotation: self.calloutAnnotation];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	if (annotation == self.calloutAnnotation) {
		CalloutMapAnnotationView *calloutMapAnnotationView = (CalloutMapAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"CalloutAnnotation"];
		if (!calloutMapAnnotationView) {
			calloutMapAnnotationView = [[CalloutMapAnnotationView alloc] initWithAnnotation:annotation 
																			 reuseIdentifier:@"CalloutAnnotation"];
			calloutMapAnnotationView.contentHeight = 78.0f;
        }
        calloutMapAnnotationView.tableView.delegate = annotation;
        calloutMapAnnotationView.tableView.dataSource = annotation;
        [(CalloutMapAnnotation*)annotation sortStops];
        [calloutMapAnnotationView.tableView reloadData];
		calloutMapAnnotationView.parentAnnotationView = self.selectedAnnotationView;
		calloutMapAnnotationView.mapView = self.mapView;
        calloutMapAnnotationView.titleView.text = [(CalloutMapAnnotation*)annotation name];
		return calloutMapAnnotationView;
	}
    if ([self.busAnnotations containsObject:annotation])
    {
        MKPinAnnotationView* anView =[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"PinAnnotationGreen"];
        anView.pinColor=MKPinAnnotationColorGreen;
        return anView;
    }
    if ([self.cal1Annotations containsObject:annotation])
    {
        MKPinAnnotationView* anView =[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"PinAnnotationPurple"];
        anView.pinColor=MKPinAnnotationColorPurple;
        return anView;
    }
	return nil;
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [self setSelectedAnnotationView:nil];
    [self setAnnotationSelector:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (IBAction)changeAnnotations:(id)sender {
    [self.mapView removeAnnotations:self.busAnnotations];
    [self.mapView removeAnnotations:self.wifiAnnotations];
    [self.mapView removeAnnotations:self.cal1Annotations];
    switch (self.annotationSelector.selectedSegmentIndex) {
        case 0:
            [self.mapView addAnnotations:self.busAnnotations];
            break;
        case 1: 
            [self.mapView addAnnotations:self.wifiAnnotations];
            break;
        case 2:
            [self.mapView addAnnotations:self.cal1Annotations];
            break;
        default:
            break;
    }
}
@end
