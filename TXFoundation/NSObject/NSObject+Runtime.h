//
//  NSObject+Runtime.h
//  LJXFoundation
//
//  Created by steven on 3/15/13.
//  Copyright (c) 2013 steven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Runtime)
- (NSString*)className;
+ (NSString*)className;
+ (NSArray*)propeties;
+ (NSArray*)allPropeties;
- (NSArray *)allPropertyNames;
/* 继承自NSObject的类 */
- (NSArray *)allPropertyNamesExceptSystem;
@end
