//
//  NSArray+BlocksKit.h
//  iMove
//
//  Created by linjinxing on 7/31/14.
//  Copyright (c) 2014 iMove. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LJXTypes.h"


@interface NSArray (LJXBlocksKit)
- (void)addEventHandler:(LJXSenderBlock)block forControlEvents:(UIControlEvents)event;
- (void)removeControlAllEventHandlerForEvents:(UIControlEvents)event;
@end
