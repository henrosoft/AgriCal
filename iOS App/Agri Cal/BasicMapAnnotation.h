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
    NSMutableDictionary *_routeNumbers;
    NSString *_url;
}
@property (nonatomic, retain) NSString *title;
@property (nonatomic, strong) NSMutableDictionary *routes; 
@property (nonatomic, strong) NSString *url;
@property (nonatomic) NSInteger index;
- (id)initWithLatitude:(CLLocationDegrees)latitude
          andLongitude:(CLLocationDegrees)longitude
             andRoutes:(NSMutableDictionary*)routes
              andIndex:(NSInteger)index;
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;
@end
