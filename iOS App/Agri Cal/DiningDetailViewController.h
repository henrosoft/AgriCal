//
//  DiningDetailViewController.h
//  Agri Cal
//
//  Created by Kevin Lindkvist on 3/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiningDetailViewController : UITableViewController
{
    NSMutableArray *_breakfast;
    NSMutableArray *_brunch; 
    NSMutableArray *_lunch;
    NSMutableArray *_dinner; 
    NSMutableArray *_lateNight;
}

@property (nonatomic, strong) NSMutableArray *breakfast; 
@property (nonatomic, strong) NSMutableArray *brunch; 
@property (nonatomic, strong) NSMutableArray *lunch; 
@property (nonatomic, strong) NSMutableArray *dinner;
@property (nonatomic, strong) NSMutableArray *lateNight; 
@end
