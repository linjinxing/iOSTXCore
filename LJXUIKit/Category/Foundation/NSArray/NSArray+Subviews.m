//
//  NSArray+Subviews.m
//  QvodFoundation
//
//  Created by steven on 3/18/13.
//  Copyright (c) 2013 steven. All rights reserved.
//

#import "NSArray+Subviews.h"

@implementation NSArray (Subviews)
+ (NSArray*)arrayWithNoHiddenSubviews:(UIView*)firstView, ... {
    NSMutableArray* result = [NSMutableArray arrayWithCapacity:20];
    va_list ap;
    va_start(ap, firstView);
    UIView* v = firstView;
    while (v) {
        if  ([v isKindOfClass:[UIView class]])
        {
           if (!v.hidden) [result addObject:v];
        }
        v = va_arg(ap, id);        
    }
    va_end(ap);
    return result;
}
@end
