#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CalloutMapAnnotation : MKAnnotationView <MKAnnotation, UITableViewDelegate, UITableViewDataSource> {
	CLLocationDegrees _latitude;
	CLLocationDegrees _longitude;
    NSString* _name;
    NSMutableDictionary *_stops;
    NSMutableArray *_nextBuses;
}

@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSMutableDictionary* stops;
@property (nonatomic, strong) NSMutableArray* nextBuses;
- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude
               andName:(NSString*)name
              andStops:(NSMutableDictionary*)stops;

- (void)sortStops;
@end
