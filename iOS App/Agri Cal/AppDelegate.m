//
//  AppDelegate.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize username = _username;
@synthesize password = _password;
@synthesize web = _web;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSString *queryString = [NSString stringWithFormat:@"%@/api/balance/?username=%@&password=%@",ServerURL, [[NSUserDefaults standardUserDefaults] objectForKey:@"username"], [[NSUserDefaults standardUserDefaults] objectForKey:@"password"]]; 
    /*
    NSURL *requestURL = [NSURL URLWithString:queryString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
    */
    NSString *post = @"username=kevinlindkvist&password=19910721Kl";
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:queryString]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
        @try {
            NSURLResponse *response = nil;
            NSError *error = nil;
            NSData *receivedData = [NSURLConnection sendSynchronousRequest:request
                                                         returningResponse:&response
                                                                     error:&error];
            NSArray *bal = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONWritingPrettyPrinted error:nil]; 
            [[NSUserDefaults standardUserDefaults] setObject:[bal objectAtIndex:0] forKey:@"cal1bal"];
        }
        @catch (NSException *e) {
            NSLog(@"error when scraping cal1card data");
        }
    });
    
    // Autologin to airbears
    self.web = [[UIWebView alloc] init];
    self.web.delegate = self;
    NSURL *url = [NSURL URLWithString:@"https://auth.berkeley.edu/cas/login?renew=true&service=https://auth.berkeley.edu/"];
    NSURLRequest *wifiRequest = [NSURLRequest requestWithURL:url];
    [self.web loadRequest:wifiRequest];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Update the cal1card balance.
    NSString *queryString = [NSString stringWithFormat:@"%@/api/balance/?username=%@&password=%@", ServerURL,[[NSUserDefaults standardUserDefaults] objectForKey:@"username"], [[NSUserDefaults standardUserDefaults] objectForKey:@"password"]]; 
    NSURL *requestURL = [NSURL URLWithString:queryString];
    NSMutableURLRequest *jsonRequest = [NSMutableURLRequest requestWithURL:requestURL];

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *receivedData = [NSURLConnection sendSynchronousRequest:jsonRequest
                                                     returningResponse:&response
                                                                 error:&error];
        NSArray *bal = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONWritingPrettyPrinted error:nil];   
        NSLog(@"recieved %@", bal);
        [[NSUserDefaults standardUserDefaults] setObject:[bal objectAtIndex:0] forKey:@"cal1bal"];
    });

    // Autologin to airbears
    self.web = [[UIWebView alloc] init];
    self.web.delegate = self;
    NSURL *url = [NSURL URLWithString:@"https://auth.berkeley.edu/cas/login?renew=true&service=https://auth.berkeley.edu/"];
    NSURLRequest *wifiRequest = [NSURLRequest requestWithURL:url];
    [self.web loadRequest:wifiRequest];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.web stringByEvaluatingJavaScriptFromString:@"document.getElementById('loginsubmit').submit()"];
    [self.web stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('username').value='%@';", [[NSUserDefaults standardUserDefaults] objectForKey:@"username"]]];
    [self.web stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('password').value='%@';", [[NSUserDefaults standardUserDefaults] objectForKey:@"password"]]];
    [self.web stringByEvaluatingJavaScriptFromString:@"document.forms[0].submit();"];
}
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
