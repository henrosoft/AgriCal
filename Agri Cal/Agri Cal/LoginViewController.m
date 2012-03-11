//
//  LoginViewController.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 3/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize webView;
@synthesize username;
@synthesize password;
- (void)viewDidLoad
{
    NSURL *url = [NSURL URLWithString:@"http://calmail.berkeley.edu/rc"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('username').value='kevinlindkvist';"];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('password').value='19910721Kl';"];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.forms[0].submit();"];
}
- (void)viewDidUnload {
    [self setWebView:nil];
    [self setUsername:nil];
    [self setPassword:nil];
    [super viewDidUnload];
}
@end
