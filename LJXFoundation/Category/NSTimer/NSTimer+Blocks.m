//
//  NSTimer+Blocks.m
//  LJXFoundation
//
//  Created by steven on 2/2/13.
//  Copyright (c) 2013 steven. All rights reserved.
//

#import "NSTimer+Blocks.h"

@implementation NSTimer (Blocks)
+(id)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval repeats:(BOOL)inRepeats block:(void (^)(NSTimer* inTimer))inBlock
{
    void (^block)() = [inBlock copy];
    id ret = [self scheduledTimerWithTimeInterval:inTimeInterval target:self selector:@selector(jdExecuteSimpleBlock:) userInfo:[NSMutableDictionary dictionaryWithObject:block forKey:@"block"]  repeats:inRepeats];
    return ret;
}

+(id)timerWithTimeInterval:(NSTimeInterval)inTimeInterval  repeats:(BOOL)inRepeats block:(void (^)(NSTimer* inTimer))inBlock
{
    void (^block)() = [inBlock copy];
    id ret = [self timerWithTimeInterval:inTimeInterval target:self selector:@selector(jdExecuteSimpleBlock:) userInfo:block repeats:inRepeats];
    return ret;
}

+ (void)jdExecuteSimpleBlock:(NSTimer *)inTimer;
{
    if ([inTimer userInfo])
    {
        void (^block)(NSTimer* inTimer) = (void (^)(NSTimer* inTimer))[[inTimer userInfo] objectForKey:@"block"];
        block(inTimer);
    }
}
@end
