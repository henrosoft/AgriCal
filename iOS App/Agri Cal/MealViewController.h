//
//  MealViewController.h
//  Agri Cal
//
//  Created by Daniela Molinaro on 4/4/12.
//  Copyright (c) 2012 UC Berkeley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MealViewController : UIViewController <UIWebViewDelegate>
@property (nonatomic, strong) NSDictionary *items;
@property (nonatomic, strong) UIWebView *web;
@end
