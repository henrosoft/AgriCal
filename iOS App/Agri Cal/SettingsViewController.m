#import "SettingsViewController.h"

@implementation SettingsViewController
@synthesize username;
@synthesize password;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.username.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    self.password.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
}
- (void)viewDidUnload
{
    [self setUsername:nil];
    [self setPassword:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.username)
        [[NSUserDefaults standardUserDefaults] setValue:textField.text forKey:@"username"];
    else if (textField == self.password)
        [[NSUserDefaults standardUserDefaults] setValue:textField.text forKey:@"password"];
    [textField resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
