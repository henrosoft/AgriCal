//
//  MealViewController.m
//  Agri Cal
//
//  Created by Daniela Molinaro on 4/4/12.
//  Copyright (c) 2012 UC Berkeley. All rights reserved.
//

#import "MealViewController.h"

@interface MealViewController ()

@end

@implementation MealViewController
@synthesize items;
@synthesize web;
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    self.web.backgroundColor = [UIColor clearColor];
    NSString *urlString = [NSString stringWithFormat:@"%@/api/menu/nutrition/%@/", ServerURL, [self.items objectForKey:@"id"]];
    NSURL *url = [NSURL URLWithString:urlString];
    [self.web loadRequest:[NSURLRequest requestWithURL:url]];
    self.web.delegate = self;
    [self.view addSubview:self.web];
}
@end
