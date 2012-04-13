#import <UIKit/UIKit.h>
#import "BasicMapAnnotation.h"
#import "BusStopAnnotation.h"
#import "BusStopAnnotationView.h"
#import "BasicMapAnnotationView.h"
#import "Cal1CardAnnotation.h"
#import "Cal1CardAnnotationView.h"
#import "TimePopAnnotationView.h"
#import "ScheduleViewController.h"

@interface MapViewController : UIViewController <MKMapViewDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
{
    BOOL _timePoping;
}
// The main map view 
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

// Different annotations for the mapview
@property (strong, nonatomic) BasicMapAnnotation *busstopAnnotation;
@property (strong, nonatomic) BusStopAnnotation *busstopCallout;
@property (strong, nonatomic) Cal1CardAnnotation *cal1Callout;
@property (strong, nonatomic) MKAnnotationView *selectedAnnotation; 
@property (strong, nonatomic) BasicMapAnnotation *buildingAnnotation;

// The arrays that contain the busstops and cal1card coordinates, titles, etc. 
@property (strong, nonatomic) NSMutableArray *busStops; 
@property (strong, nonatomic) NSMutableArray *cal1cardLocations;
@property (strong, nonatomic) NSMutableArray *timePopUps;
@property (strong, nonatomic) NSMutableArray *searchResults;

@property (weak, nonatomic) IBOutlet UISegmentedControl *annotationSelector;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UIImageView *mapKeyImageView;
- (IBAction)switchAnnotations:(id)sender;
- (IBAction)doneButtonPushed:(id)sender;
- (void)highlightPath:(NSString*)path:(NSString*)indexes;
- (IBAction)displayMapKey:(id)sender;
- (void)displayWebsite:(NSString*)url;
@end
