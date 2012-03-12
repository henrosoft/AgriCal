//
//  BusStopAnnotationView.h
//  Agri Cal
//
//  Created by Kevin Lindkvist on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BusStopAnnotation.h"
#import "BasicMapAnnotation.h"
@interface BusStopAnnotationView : MKAnnotationView
{
    MKAnnotationView *_parentAnnotationView;
	MKMapView *_mapView;
	CGRect _endFrame;
	UIView *_contentView;
	CGFloat _yShadowOffset;
	CGPoint _offsetFromParent;
	CGFloat _contentHeight;
    UITableView *_tableView;
}
@property (nonatomic, retain) MKAnnotationView *parentAnnotationView;
@property (nonatomic, retain) MKMapView *mapView;
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic) CGPoint offsetFromParent;
@property (nonatomic) CGFloat contentHeight;
@property (nonatomic, strong) UITableView *tableView;
- (void)animateIn;
- (void)animateInStepTwo;
- (void)animateInStepThree;
- (void) preventParentSelectionChange;
- (void) allowParentSelectionChange;
- (void) enableSibling:(UIView *)sibling;

@end
