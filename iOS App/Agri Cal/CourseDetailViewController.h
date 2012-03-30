//
//  CourseDetailViewController.h
//  Agri Cal
//
//  Created by Kevin Lindkvist on 3/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseInfoViewController.h"

@interface CourseDetailViewController : UITableViewController
@property (nonatomic, strong) NSMutableDictionary *courses;
@property (nonatomic, strong) NSMutableDictionary *courseInfo;
@property (nonatomic, strong) NSString *department;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSArray *searchResults;
@property (nonatomic, strong) NSMutableArray *titles;
@end
