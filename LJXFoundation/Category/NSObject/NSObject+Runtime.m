//
//  NSObject+Runtime.m
//  LJXFoundation
//
//  Created by steven on 3/15/13.
//  Copyright (c) 2013 steven. All rights reserved.
//

#import "NSObject+Runtime.h"
#import <objc/runtime.h>

@implementation NSObject (Runtime)
- (NSString*)className
{
    return [NSString stringWithUTF8String:class_getName([self class])];
}

+ (NSString*)className
{
    return [NSString stringWithUTF8String:class_getName(self)];
}

- (NSArray *)allPropertyNames
{
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    NSMutableArray *rv = [NSMutableArray array];
    
    unsigned i;
    for (i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        [rv addObject:name];
    }
    
    free(properties);
    
    return rv;
}

- (NSArray *)allPropertyNamesExceptSystem
{
    NSMutableArray* a = [NSMutableArray arrayWithArray:[self allPropertyNames]];
    [a removeObjectsInArray:@[@"hash", @"superclass", @"description", @"debugDescription"]];
    return [a copy];
}

+ (NSArray*)propeties
{
    unsigned int propertyCount = 0, i = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
    
    NSMutableArray* retProperties = [NSMutableArray arrayWithCapacity:propertyCount];
    for(i = 0; i < propertyCount; i++)
    {
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
        if ([propertyName length]) {
            [retProperties addObject:propertyName];
        }
    }
    
    free(properties);
    return [retProperties copy];
}

+ (NSArray*)allPropeties
{
    NSMutableArray* p = [NSMutableArray arrayWithCapacity:30];
    Class cls = [self class];
    do {
        NSArray* po = [cls propeties];
        [p addObjectsFromArray:po];
    }while ((cls = [cls superclass]));
    
    return p;
}

@end
