#import <UIKit/UIKit.h>
#import "InfoViewController.h"

@interface SettingsViewController : UIViewController <UITextFieldDelegate, UIWebViewDelegate, UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@end
