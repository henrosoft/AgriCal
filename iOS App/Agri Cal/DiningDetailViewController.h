#import <UIKit/UIKit.h>
#import "MealViewController.h"

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
