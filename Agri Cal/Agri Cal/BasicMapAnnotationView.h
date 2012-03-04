//
//  BasicMapAnnotationView.h
//  Agri Cal
//
//  Created by Kevin Lindkvist on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BasicMapAnnotationView : MKPinAnnotationView
{
    BOOL _preventSelectionChange;
}
@property (nonatomic) BOOL preventSelectionChange; 
@end
