//
//  LoginViewController.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 3/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
{
    int _login;
}
@end

@implementation LoginViewController
@synthesize webView;
@synthesize username;
@synthesize password;
- (void)viewDidLoad
{
    NSURL *url = [NSURL URLWithString:@"http://services.housing.berkeley.edu/c1c/static/index.htm"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('loginsubmit').submit()"];
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('username').value='%@';", [[NSUserDefaults standardUserDefaults] objectForKey:@"username"]]];
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('password').value='%@';", [[NSUserDefaults standardUserDefaults] objectForKey:@"password"]]];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.forms[0].submit();"];
    _login++;
    NSLog(@"%i",_login);
    if(_login == 4)
    {
        [self.webView stringByEvaluatingJavaScriptFromString:@"location.href = 'https://services.housing.berkeley.edu/c1c/dyn/balance.asp'"];
    }
    if(_login > 4) 
    {
        [self.webView setHidden:NO];
    }
}
-(void)test
{
    [self.webView stringByEvaluatingJavaScriptFromString:@"location.href = 'https://services.housing.berkeley.edu/c1c/dyn/balance.asp'"];
}

- (void)viewDidUnload {
    [self setWebView:nil];
    [self setUsername:nil];
    [self setPassword:nil];
    [super viewDidUnload];
}
@end
