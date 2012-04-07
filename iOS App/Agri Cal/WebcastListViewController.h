//
//  WebcastListViewController.h
//  Agri Cal
//
//  Created by Kevin Lindkvist on 3/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebcastViewController.h"

@interface WebcastListViewController : UITableViewController
@property (strong, nonatomic) NSMutableArray *webcasts;
@property (strong, nonatomic) NSString *url;
@end
