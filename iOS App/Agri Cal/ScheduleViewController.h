//
//  ScheduleViewController.h
//  Agri Cal
//
//  Created by Kevin Lindkvist on 3/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusStopAnnotation.h"
#import "MapViewController.h"
@interface ScheduleViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *items;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, weak) id delegate;
@property (nonatomic, weak) BusStopAnnotation *stop;

@end
