//
//  FirstViewController.h
//  The Lair
//
//  Created by Daniela Molinaro on 2/23/12.
//  Copyright (c) 2012 UC Berkeley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AppDelegate.h"
#import "CalloutMapAnnotation.h"
#import "BasicMapAnnotation.h"
#import "CalloutMapAnnotationView.h"

@interface GetAroundController : UIViewController <MKMapViewDelegate>
{
    CalloutMapAnnotation *_calloutAnnotation;
	MKAnnotationView *_selectedAnnotationView;
	BasicMapAnnotation *_customAnnotation;
	BasicMapAnnotation *_normalAnnotation;
    NSMutableArray* _cal1Annotations;
    NSMutableArray* _busAnnotations;
    NSMutableArray* _wifiAnnotations;
}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) MKAnnotationView *selectedAnnotationView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *annotationSelector;
@property (strong, nonatomic) NSMutableArray* busAnnotations;
@property (strong, nonatomic) NSMutableArray* wifiAnnotations;
@property (strong, nonatomic) NSMutableArray* cal1Annotations;
- (IBAction)changeAnnotations:(id)sender;
@end
