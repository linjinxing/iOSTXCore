//
//  NSObject+KVC.m
//  LJXFoundation
//
//  Created by steven on 3/11/13.
//  Copyright (c) 2013 steven. All rights reserved.
//

#import <objc/runtime.h>
#import "NSObject+KVC.h"

@implementation NSObject (KVC)
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




