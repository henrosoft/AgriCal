//
//  Cal1CardAnnotation.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Cal1CardAnnotation.h"

@implementation Cal1CardAnnotation
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize title = _title;
@synthesize url = _url;
- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude
              andTitle:(NSString *)title 
                andURL:(NSString *)url{
	if (self = [super init]) {
		self.latitude = latitude;
		self.longitude = longitude;
        self.title = title;
        self.url = url;
	}
	return self;
}

- (CLLocationCoordinate2D)coordinate {
	CLLocationCoordinate2D coordinate;
	coordinate.latitude = self.latitude;
	coordinate.longitude = self.longitude;
	return coordinate;
}
@end
