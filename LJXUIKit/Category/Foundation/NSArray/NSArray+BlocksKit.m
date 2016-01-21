//
//  NSArray+BlocksKit.m
//  iMove
//
//  Created by linjinxing on 7/31/14.
//  Copyright (c) 2014 iMove. All rights reserved.
//

#import "NSArray+BlocksKit.h"
#import "UIControl+LJXBlocks.h"

@implementation NSArray (LJXBlocksKit)
- (void)addEventHandler:(LJXSenderBlock)block forControlEvents:(UIControlEvents)event
{
    for (UIControl* c in self) {
        [c addEventHandler:block forControlEvents:event];
    }
}

- (void)removeControlAllEventHandlerForEvents:(UIControlEvents)event
{
    for (UIControl* c in self) {
        [c removeEventHandlersForControlEvents:event];
    }
}
@end
