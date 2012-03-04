//
//  FirstViewController.h
//  Agri Cal
//
//  Created by Kevin Lindkvist on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicMapAnnotation.h"
#import "BusStopAnnotation.h"
#import "BusStopAnnotationView.h"
#import "BasicMapAnnotationView.h"

@interface FirstViewController : UIViewController <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) BasicMapAnnotation *testAnnotation;
@property (strong, nonatomic) BusStopAnnotation *testCallout;
@property (strong, nonatomic) MKAnnotationView *selectedAnnotation; 
@property (strong, nonatomic) NSMutableArray *busStops; 
@property (strong, nonatomic) NSMutableArray *cal1cardLocations;
@property (weak, nonatomic) IBOutlet UISegmentedControl *annotationSelector;
- (IBAction)switchAnnotations:(id)sender;
- (void)highlightPath:(NSString*)path;
@end
