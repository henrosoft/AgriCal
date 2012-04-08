#import <UIKit/UIKit.h>

@interface MealViewController : UIViewController <UIWebViewDelegate>
@property (nonatomic, strong) NSDictionary *items;
@property (nonatomic, strong) UIWebView *web;
@end
