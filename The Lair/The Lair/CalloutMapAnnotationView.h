#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CalloutMapAnnotation.h"
@interface CalloutMapAnnotationView : MKAnnotationView {
	MKAnnotationView *_parentAnnotationView;
	MKMapView *_mapView;
	CGRect _endFrame;
	UIView *_contentView;
	CGFloat _yShadowOffset;
	CGPoint _offsetFromParent;
	CGFloat _contentHeight;
    UITextView* _titleView;
    UITableView* _tableView;
}

@property (nonatomic, retain) MKAnnotationView *parentAnnotationView;
@property (nonatomic, retain) MKMapView *mapView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic) CGPoint offsetFromParent;
@property (nonatomic) CGFloat contentHeight;
@property (nonatomic, strong) UITextView* titleView;
@property (nonatomic, strong) UITableView* tableView;
- (void)animateIn;
- (void)animateInStepTwo;
- (void)animateInStepThree;
@end
