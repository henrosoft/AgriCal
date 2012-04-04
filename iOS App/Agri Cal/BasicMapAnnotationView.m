//
//  BasicMapAnnotationView.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BasicMapAnnotationView.h"

@implementation BasicMapAnnotationView
@synthesize preventSelectionChange = _preventSelectionChange;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (!self.preventSelectionChange)
    {
        [super setSelected:selected animated:animated];
    }
}

@end
