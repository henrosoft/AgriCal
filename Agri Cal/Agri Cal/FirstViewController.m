//
//  FirstViewController.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

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
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.busStops = [[NSMutableArray alloc] init];
    self.cal1cardLocations = [[NSMutableArray alloc] init];
    self.mapView.delegate = self;
    
	CLLocationCoordinate2D coordinate = {38.315, -90.2045};
	[self.mapView setRegion:MKCoordinateRegionMake(coordinate, 
												   MKCoordinateSpanMake(1, 1))];  
    CLLocationCoordinate2D coord = {.latitude =  37.870218, .longitude =  -122.259481};
    MKCoordinateSpan span = {.latitudeDelta = 0.01, .longitudeDelta = 0.001};
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
        BasicMapAnnotation* ano = [[BasicMapAnnotation alloc] initWithLatitude:[latitude doubleValue] andLongitude:[longitude doubleValue] andRoutes:[current objectForKey:@"times"]];
        
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
        BasicMapAnnotation* ano = [[BasicMapAnnotation alloc] initWithLatitude:[latitude doubleValue] andLongitude:[longitude doubleValue] andRoutes:[[NSMutableDictionary alloc] init]];
        [self.cal1cardLocations addObject:ano];	
    }
    [self.mapView addAnnotations:self.busStops];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([self.busStops containsObject:view.annotation])
    {
        if (self.testCallout == nil) 
        {
            self.testCallout = [[BusStopAnnotation alloc] initWithLatitude:view.annotation.coordinate.latitude andLongitude:view.annotation.coordinate.longitude andRoutes:((BasicMapAnnotation*)view.annotation).routes andDelegate:self];
        }
        else {
            self.testCallout.latitude = view.annotation.coordinate.latitude;
            self.testCallout.longitude = view.annotation.coordinate.longitude;
            self.testCallout.routes = ((BasicMapAnnotation*)view.annotation).routes;
        }
        
        [self.mapView addAnnotation:self.testCallout];
        self.selectedAnnotation = view;
    }
}
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if (self.testCallout && [self.busStops containsObject:view.annotation] && !((BasicMapAnnotationView*)view).preventSelectionChange)
    {
        [self.mapView removeAnnotation:self.testCallout];
        for (BasicMapAnnotation *anno in self.mapView.annotations)
        {
            if ([anno class] == [BasicMapAnnotation class])
            {
                BasicMapAnnotationView *view = [self.mapView viewForAnnotation:anno];
                view.pinColor = MKPinAnnotationColorGreen;
            }
        }
    }
}

-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
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
    else if ([self.busStops containsObject:annotation]) 
    {
        MKPinAnnotationView *annotationView = [[BasicMapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"test"];
        annotationView.canShowCallout = NO; 
        annotationView.pinColor = MKPinAnnotationColorGreen;
        return annotationView;
    }
    else if ([self.cal1cardLocations containsObject:annotation])
    {
        MKPinAnnotationView *annotationView = [[BasicMapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"test"];
        annotationView.canShowCallout = NO; 
        annotationView.pinColor = MKPinAnnotationColorPurple;
        return annotationView;  
    }
    return nil;
}

- (void)highlightPath:(NSString *)path
{
    path = [[path componentsSeparatedByString:@":"] objectAtIndex:2];
    NSLog(@"%@",path);
    for (BasicMapAnnotation *anno in self.mapView.annotations)
    {
        if ([anno class] == [BasicMapAnnotation class])
        {
        if ([anno.routes objectForKey:path])
        {
            BasicMapAnnotationView *view = [self.mapView viewForAnnotation:anno];
            view.pinColor = MKPinAnnotationColorRed;
        }
        }
    }
}

- (IBAction)switchAnnotations:(id)sender {
    [self.mapView removeAnnotations:self.busStops];
    [self.mapView removeAnnotations:self.cal1cardLocations];
    switch (self.annotationSelector.selectedSegmentIndex) {
        case 0:
            [self.mapView addAnnotations:self.busStops];
            break;
        case 1:
            [self.mapView addAnnotations:self.cal1cardLocations];
            break;
        default:
            break;
    }
}

- (void)viewDidUnload {
    [self setAnnotationSelector:nil];
    [super viewDidUnload];
}
@end
