//
//  BusStopAnnotation.h
//  Agri Cal
//
//  Created by Kevin Lindkvist on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusStopAnnotation : NSObject <MKAnnotation, UITableViewDelegate, UITableViewDataSource>
{
    CLLocationDegrees _latitude;
    CLLocationDegrees _longitude;
    NSMutableDictionary *_routes;
    NSMutableArray *_nextBuses; 
    id _delegate;
}

@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;
@property (nonatomic) NSMutableDictionary *routes; 
@property (nonatomic, strong) NSMutableArray *nextBuses;
@property (nonatomic) id delegate;
@property (nonatomic, strong) NSString *title;
- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude
             andRoutes:(NSMutableDictionary*)routes
           andDelegate:(id)delegate;
- (void)sortStops;
@end
