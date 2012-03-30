//
//  Cal1CardAnnotationView.h
//  Agri Cal
//
//  Created by Kevin Lindkvist on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cal1CardAnnotationView : MKAnnotationView {
    UIButton *_accessory;
    MKAnnotationView *_parentAnnotationView;
	MKMapView *_mapView;
	CGRect _endFrame;
	UIView *_contentView;
	CGFloat _yShadowOffset;
	CGPoint _offsetFromParent;
	CGFloat _contentHeight;
    NSString *_title; 
    NSString *_url;
}
@property (nonatomic, retain) MKAnnotationView *parentAnnotationView;
@property (nonatomic, retain) MKMapView *mapView;
@property (nonatomic, readonly) UIView *contentView;
@property (nonatomic) CGPoint offsetFromParent;
@property (nonatomic) CGFloat contentHeight;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) UILabel *textLabel;
- (void)animateIn;
- (void)animateInStepTwo;
- (void)animateInStepThree;
- (void) calloutAccessoryTapped;
- (void) preventParentSelectionChange;
- (void) allowParentSelectionChange;
- (void) enableSibling:(UIView *)sibling;
@end
