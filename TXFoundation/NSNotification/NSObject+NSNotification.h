//
//  NSObject+NSNotification.h
//  LJXFoundation
//
//  Created by steven on 6/6/13.
//  Copyright (c) 2013 steven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (NSNotification)
- (void)postNotificationName:(NSString*)name;
- (void)addObserverWithSelector:(SEL)aSelector name:(NSString *)aName;
- (void)addObserverWithSelector:(SEL)aSelector name:(NSString *)aName object:(id)anObject;

+ (void)postNotificationName:(NSString*)name;
+ (void)addObserverWithSelector:(SEL)aSelector name:(NSString *)aName;
+ (void)addObserverWithSelector:(SEL)aSelector name:(NSString *)aName object:(id)anObject;
@end
