//
//  BasicMapAnnotation.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BasicMapAnnotation.h"
@interface BasicMapAnnotation()
@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude; 
@end 
@implementation BasicMapAnnotation
@synthesize title = _title;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize routes = _routes;
@synthesize url = _url;
@synthesize index = _index;
@synthesize type = _color;
- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude
             andRoutes:(NSMutableDictionary*)routes
              andIndex:(NSInteger)index{
	if (self = [super init]) {
		self.latitude = latitude;
		self.longitude = longitude;
        self.routes = routes;
        self.index = index;
	}
	return self;
}

- (CLLocationCoordinate2D)coordinate {
	CLLocationCoordinate2D coordinate;
	coordinate.latitude = self.latitude;
	coordinate.longitude = self.longitude;
	return coordinate;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
	self.latitude = newCoordinate.latitude;
	self.longitude = newCoordinate.longitude;
}

@end
