//
//  NSArray+LJXExtend.h
//  MiaoChat
//
//  Created by zengwm on 14/10/27.
//  Copyright (c) 2014年 iMove. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (LJXExtend)

-(id)nthObject:(NSUInteger)n default:(id)marker;

-(id)nthObject:(NSUInteger)n;

- (NSUInteger)countOfContainString:(NSString *)string;

- (NSInteger)indexOfObjectViaBinarySearch:(id)object;

@end
