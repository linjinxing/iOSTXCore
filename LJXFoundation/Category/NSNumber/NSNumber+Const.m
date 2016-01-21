//
//  NSNumber+Const.m
//  LJXFoundation
//
//  Created by steven on 3/15/13.
//  Copyright (c) 2013 steven. All rights reserved.
//

#import "NSNumber+Const.h"

@implementation NSNumber (Const)
+ (NSNumber*)numberNO
{
    return [NSNumber numberWithBool:NO];
}
+ (NSNumber*)numberYES
{
    return [NSNumber numberWithBool:YES];
}

@end
