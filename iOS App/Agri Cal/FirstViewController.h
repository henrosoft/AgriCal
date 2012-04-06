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
#import "Cal1CardAnnotation.h"
#import "Cal1CardAnnotationView.h"
#import "TimePopAnnotationView.h"
#import "ScheduleViewController.h"

@interface FirstViewController : UIViewController <MKMapViewDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
{
    BOOL _timePoping;
}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) BasicMapAnnotation *testAnnotation;
@property (strong, nonatomic) BusStopAnnotation *testCallout;
@property (strong, nonatomic) Cal1CardAnnotation *cal1Callout;
@property (strong, nonatomic) MKAnnotationView *selectedAnnotation; 
@property (strong, nonatomic) BasicMapAnnotation *buildingAnnotation;
@property (strong, nonatomic) NSMutableArray *busStops; 
@property (strong, nonatomic) NSMutableArray *cal1cardLocations;
@property (weak, nonatomic) IBOutlet UISegmentedControl *annotationSelector;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) NSMutableArray *timePopUps;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *searchResults;
- (IBAction)switchAnnotations:(id)sender;
- (IBAction)doneButtonPushed:(id)sender;
- (void)highlightPath:(NSString*)path:(NSString*)indexes;
- (void)displayWebsite:(NSString*)url;
@end
