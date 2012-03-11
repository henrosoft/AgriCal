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
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setUsername:nil];
    [self setPassword:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
