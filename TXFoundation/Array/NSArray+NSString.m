//
//  NSArray+NSString.m
//  LJXFoundation
//
//  Created by steven on 5/11/13.
//  Copyright (c) 2013 steven. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "NSArray+NSString.h"
#import "TXFoundation.h"
#import "LJXDebug.h"

@implementation NSArray (NSString)
- (NSArray*)arrayByAddingPrefixString:(NSString*)prefix
{
    NSMutableArray* items = [NSMutableArray arrayWithCapacity:[self count]];
    @try {
        for (NSString* str in self) {
            [items addObject:[prefix stringByAppendingString:str]];
        }
    }
    @catch (NSException *exception) {
        LJXError( "exception");
    }
    @finally {
        return items;
    }
}
@end
