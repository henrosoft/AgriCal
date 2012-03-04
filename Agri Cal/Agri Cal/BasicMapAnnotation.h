//
//  BasicMapAnnotation.h
//  Agri Cal
//
//  Created by Kevin Lindkvist on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BasicMapAnnotation : NSObject <MKAnnotation> {
    CLLocationDegrees _latitude;
    CLLocationDegrees _longitude; 
    NSString *_title; 
    NSMutableDictionary *_routes;
}
@property (nonatomic, strong) NSMutableDictionary *routes; 
- (id)initWithLatitude:(CLLocationDegrees)latitude
          andLongitude:(CLLocationDegrees)longitude
             andRoutes:(NSMutableDictionary*)routes;
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;
@end
