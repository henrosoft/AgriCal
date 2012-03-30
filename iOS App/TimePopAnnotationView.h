//
//  TimePopAnnotationView.h
//  Agri Cal
//
//  Created by Kevin Lindkvist on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cal1CardAnnotationView.h"
@interface TimePopAnnotationView : MKAnnotationView
{
    MKAnnotationView *_parentAnnotationView;
	MKMapView *_mapView;
	CGRect _endFrame;
	UIView *_contentView;
	CGFloat _yShadowOffset;
	CGPoint _offsetFromParent;
	CGFloat _contentHeight;
}

@property (nonatomic, retain) MKAnnotationView *parentAnnotationView;
@property (nonatomic, retain) MKMapView *mapView;
@property (nonatomic, readonly) UIView *contentView;
@property (nonatomic) CGPoint offsetFromParent;
@property (nonatomic) CGFloat contentHeight;
@property (nonatomic, strong) UILabel *titleLabel;

- (void)animateIn;
- (void)animateInStepTwo;
- (void)animateInStepThree;

@end
