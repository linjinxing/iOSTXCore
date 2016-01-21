//
//  NSObject+GCD.m
//

#import "NSObject+GCD.h"



void LJXPerformBlockAsynOnMainThread(LJXBlock block)
{
    dispatch_async(dispatch_get_main_queue(), block);
}

void LJXPerformBlockSynOnMainThread(LJXBlock block)
{
    if ([NSThread isMainThread]) {
        if (block) block();
    }else{
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

void LJXPerformBlockAsyn(LJXBlock block)
{
    dispatch_async(LJX_GLOBAL_DEFAULT_QUEUE, block);
}

void LJXPerformBlockOnMainThreadAfterDelay(NSTimeInterval seconds, LJXBlock block)
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}

void LJXPerformBlockAfterDelay(NSTimeInterval seconds, LJXBlock block)
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC);
    dispatch_after(popTime, LJX_GLOBAL_DEFAULT_QUEUE, block);
}


void LJXPerformBlockAsynWithPriorityAndWait(dispatch_queue_priority_t priority, BOOL wait, LJXBlock block)
{
    dispatch_queue_t queue = dispatch_get_global_queue(priority, 0);
    if (wait) {
        dispatch_sync(queue, block);
    }else{
        dispatch_async(queue, block);
    }
}

void LJXPerformBlockAsynAfterDelayInQueue(dispatch_queue_t queue, NSTimeInterval seconds, LJXBlock block)
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC);
    dispatch_after(popTime, queue, block);
}


@implementation NSObject (GCD)

+ (void)performBlockAsynOnMainThread:(LJXBlock)block
{
    dispatch_async(dispatch_get_main_queue(), block);
}

- (void)performBlockAsynOnMainThread:(LJXBlock)block
{
    dispatch_async(dispatch_get_main_queue(), block);
}

/* ============================================================================================  */

+ (void)performBlockSynOnMainThread:(LJXBlock)block
{
    LJXPerformBlockSynOnMainThread(block);
}

- (void)performBlockSynOnMainThread:(LJXBlock)block
{
    LJXPerformBlockSynOnMainThread(block);
}

/* ============================================================================================  */


- (void)performBlockAsyn:(LJXBlock)block priority:(dispatch_queue_priority_t) priority waitUntilDone:(BOOL)wait
{
    LJXPerformBlockAsynWithPriorityAndWait(priority, wait, block);
}

+ (void)performBlockAsyn:(LJXBlock)block priority:(dispatch_queue_priority_t) priority waitUntilDone:(BOOL)wait {
    LJXPerformBlockAsynWithPriorityAndWait(priority, wait, block);
}

/* ============================================================================================  */

+ (void)performBlockAsyn:(LJXBlock)block priority:(dispatch_queue_priority_t) priority
{
    [self performBlockAsyn:block priority:priority waitUntilDone:NO];
}

- (void)performBlockAsyn:(LJXBlock)block priority:(dispatch_queue_priority_t) priority
{
    [self performBlockAsyn:block priority:priority waitUntilDone:NO];
}

/* ============================================================================================  */

- (void)performBlockAsyn:(LJXBlock)block {
    LJXPerformBlockAsyn(block);
}

+ (void)performBlockAsyn:(LJXBlock)block
{
    LJXPerformBlockAsyn(block);
}

/* ============================================================================================  */


- (void)performBlockAsyn:(LJXBlock)block inQueue:(dispatch_queue_t) queue afterDelay:(NSTimeInterval)seconds
{
    LJXPerformBlockAsynAfterDelayInQueue(queue, seconds, block);
}

+ (void)performBlockAsyn:(LJXBlock)block inQueue:(dispatch_queue_t) queue afterDelay:(NSTimeInterval)seconds
{
    LJXPerformBlockAsynAfterDelayInQueue(queue, seconds, block);
}

/* ============================================================================================  */

+ (void)performBlockAsyn:(LJXBlock)block afterDelay:(NSTimeInterval)seconds
{
    LJXPerformBlockAfterDelay(seconds, block);
}

- (void)performBlockAsyn:(LJXBlock)block afterDelay:(NSTimeInterval)seconds
{
    LJXPerformBlockAfterDelay(seconds, block);
}

/* ============================================================================================  */

+ (void)performBlockOnMainThread:(LJXBlock)block afterDelay:(NSTimeInterval)seconds
{
    LJXPerformBlockOnMainThreadAfterDelay(seconds, block);
}

- (void)performBlockOnMainThread:(LJXBlock)block afterDelay:(NSTimeInterval)seconds
{
    LJXPerformBlockOnMainThreadAfterDelay(seconds, block);
}



@end


