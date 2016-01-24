//
//  NSObject+GCD.m
//

#import "NSObject+GCD.h"

@implementation NSObject (GCD)
+ (void)performBlockAsynOnMainThread:(LJXBlock)block
{
    LJXPerformBlockAsynOnMainThread(block);
}
@end

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



