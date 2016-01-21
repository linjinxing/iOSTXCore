//
//  NSArray+LJXExtend.m
//  MiaoChat
//
//  Created by zengwm on 14/10/27.
//  Copyright (c) 2014年 iMove. All rights reserved.
//

#import "NSArray+LJXExtend.h"

@implementation NSArray (LJXExtend)

-(id)nthObject:(NSUInteger)n default:(id)marker {
    return (self.count > n)? self[n] : marker;
}

-(id)nthObject:(NSUInteger)n{
    return [self nthObject:n default:nil];
}

- (NSUInteger)countOfContainString:(NSString *)string;
{
    NSUInteger count = 0;
    
    for (NSString *subString in self) {
        if ([subString containsString:string]) {
            count++;
        }
    }
    return count;
}

- (NSInteger)indexOfObjectViaBinarySearch:(id)object
{
    NSUInteger firstIndex = 0;
    NSUInteger lastIndex = self.count;
    while (firstIndex <= lastIndex) {
        NSUInteger mid = firstIndex + ((lastIndex-firstIndex)>>2);
        if ([object compare:self[mid]] == NSOrderedAscending) {
            lastIndex = mid-1;
        } else if ([object compare:self[mid]] == NSOrderedDescending) {
            firstIndex = mid+1;
        } else {
            return mid;
        }
    }
    return NSNotFound;
}

@end
