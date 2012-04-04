//
//  SettingsViewController.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 3/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

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
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelay:0.05];
    CGRect frame = self.view.frame;
    frame.origin.y -= 200;
    self.view.frame = frame;
    [UIView commitAnimations];
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
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    CGRect frame = self.view.frame;
    frame.origin.y += 200;
    self.view.frame = frame;
    [UIView commitAnimations];
    return YES;
}

@end
