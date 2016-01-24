//
//  NSObject+NSNotification.m
//  LJXFoundation
//
//  Created by steven on 6/6/13.
//  Copyright (c) 2013 steven. All rights reserved.
//

#import "NSObject+NSNotification.h"

@implementation NSObject (NSNotification)
- (void)addObserverWithSelector:(SEL)aSelector name:(NSString *)aName
{
    [self addObserverWithSelector:aSelector name:aName object:nil];
}


+ (void)addObserverWithSelector:(SEL)aSelector name:(NSString *)aName
{
    [[NSNotificationCenter defaultCenter] addObserver:[self class] selector:aSelector name:aName object:nil];
}


- (void)addObserverWithSelector:(SEL)aSelector name:(NSString *)aName object:(id)anObject
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:aSelector name:aName object:anObject];
}

+ (void)addObserverWithSelector:(SEL)aSelector name:(NSString *)aName object:(id)anObject
{
    [[NSNotificationCenter defaultCenter] addObserver:[self class] selector:aSelector name:aName object:anObject];
}


- (void)postNotificationName:(NSString*)name
{
    [[NSNotificationCenter defaultCenter] postNotificationName:name];
}

+ (void)postNotificationName:(NSString*)name
{
    [[NSNotificationCenter defaultCenter] postNotificationName:name];
}

@end
