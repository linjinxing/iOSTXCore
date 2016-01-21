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


