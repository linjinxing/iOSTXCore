//
//  NSTimer+Blocks.h
//  LJXFoundation
//
//  Created by steven on 2/2/13.
//  Copyright (c) 2013 steven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Blocks)
+(id)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval repeats:(BOOL)inRepeats block:(void (^)(NSTimer* inTimer))inBlock ;
+(id)timerWithTimeInterval:(NSTimeInterval)inTimeInterval  repeats:(BOOL)inRepeats block:(void (^)(NSTimer* inTimer))inBlock;
@end
