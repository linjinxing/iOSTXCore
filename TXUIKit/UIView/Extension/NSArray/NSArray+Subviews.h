//
//  NSArray+Subviews.h
//  QvodFoundation
//
//  Created by steven on 3/18/13.
//  Copyright (c) 2013 steven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSArray (Subviews)
+ (NSArray*)arrayWithNoHiddenSubviews:(UIView*)firstView, ... NS_REQUIRES_NIL_TERMINATION;
@end
