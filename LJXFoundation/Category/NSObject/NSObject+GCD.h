//
//  NSObject+GCD.h
//

#import "LJXTypes.h"

#define LJX_GLOBAL_DEFAULT_QUEUE dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)



void LJXPerformBlockAsynOnMainThread(LJXBlock block);
void LJXPerformBlockSynOnMainThread(LJXBlock block);
void LJXPerformBlockAsyn(LJXBlock block);
void LJXPerformBlockOnMainThreadAfterDelay(NSTimeInterval seconds, LJXBlock block);
void LJXPerformBlockAfterDelay(NSTimeInterval seconds, LJXBlock block);

void LJXPerformBlockAsynWithPriorityAndWait(dispatch_queue_priority_t priority, BOOL wait, LJXBlock block);
void LJXPerformBlockAsynAfterDelayInQueue(dispatch_queue_t queue, NSTimeInterval seconds, LJXBlock block);

@interface NSObject (GCD)

// 在主线程中执行
- (void)performBlockAsynOnMainThread:(LJXBlock)block __attribute__((deprecated("Use LJXPerformBlockAsynOnMainThread instead")));
+ (void)performBlockAsynOnMainThread:(LJXBlock)block __attribute__((deprecated("Use LJXPerformBlockAsynOnMainThread instead")));

- (void)performBlockSynOnMainThread:(LJXBlock)block __attribute__((deprecated("Use LJXPerformBlockSynOnMainThread instead")));
+ (void)performBlockSynOnMainThread:(LJXBlock)block __attribute__((deprecated("Use LJXPerformBlockSynOnMainThread instead")));

//  默认优先级DISPATCH_QUEUE_PRIORITY_DEFAULT, 会在global queue中执行
- (void)performBlockAsyn:(LJXBlock)block __attribute__((deprecated("Use LJXPerformBlockAsyn instead")));
+ (void)performBlockAsyn:(LJXBlock)block __attribute__((deprecated("Use LJXPerformBlockAsyn instead")));

// 会在global queue中执行
- (void)performBlockAsyn:(LJXBlock)block priority:(dispatch_queue_priority_t) priority waitUntilDone:(BOOL)wait __attribute__((deprecated("Use LJXPerformBlockAsynWithPriorityAndWait instead")));
+ (void)performBlockAsyn:(LJXBlock)block priority:(dispatch_queue_priority_t) priority waitUntilDone:(BOOL)wait __attribute__((deprecated("Use LJXPerformBlockAsynWithPriorityAndWait instead")));

// 在主线程中执行
- (void)performBlockOnMainThread:(LJXBlock)block afterDelay:(NSTimeInterval)seconds __attribute__((deprecated("Use LJXPerformBlockOnMainThreadAfterDelay instead")));
+ (void)performBlockOnMainThread:(LJXBlock)block afterDelay:(NSTimeInterval)seconds __attribute__((deprecated("Use LJXPerformBlockOnMainThreadAfterDelay instead")));

//  默认优先级, 会在global queue中执行
- (void)performBlockAsyn:(LJXBlock)block afterDelay:(NSTimeInterval)seconds __attribute__((deprecated("Use LJXPerformBlockAfterDelay instead")));
+ (void)performBlockAsyn:(LJXBlock)block afterDelay:(NSTimeInterval)seconds __attribute__((deprecated("Use LJXPerformBlockAfterDelay instead")));

// 全部自己定制
- (void)performBlockAsyn:(LJXBlock)block inQueue:(dispatch_queue_t) queue afterDelay:(NSTimeInterval)seconds  __attribute__((deprecated("Use LJXPerformBlockAsynAfterDelayInQueue instead")));;
+ (void)performBlockAsyn:(LJXBlock)block inQueue:(dispatch_queue_t) queue afterDelay:(NSTimeInterval)seconds  __attribute__((deprecated("Use LJXPerformBlockAsynAfterDelayInQueue instead")));;

@end



