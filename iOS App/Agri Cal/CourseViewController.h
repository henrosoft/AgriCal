//
//  CourseViewController.h
//  Agri Cal
//
//  Created by Kevin Lindkvist on 3/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseDetailViewController.h"
@interface CourseViewController : UITableViewController
{
}
@property (nonatomic, strong) NSMutableDictionary *departments;
@property (nonatomic, strong) NSMutableArray *departmentNumbers;
@property (nonatomic, strong) NSMutableArray *searchResults;
@end
