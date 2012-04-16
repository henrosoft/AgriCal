//
//  InfoView.h
//  Agri Cal
//
//  Created by Kevin Lindkvist on 4/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoView : UIView
@property (strong, nonatomic) IBOutlet UIImageView *imageView; 
@property (strong, nonatomic) IBOutlet UITextView *textView; 
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextView *timesTextView;
@property (strong, nonatomic) IBOutlet UIView *view;
@end
