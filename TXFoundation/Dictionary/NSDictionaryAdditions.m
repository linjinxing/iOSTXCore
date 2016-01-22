//
//  NSDictionaryAdditions.m
//  LJXBrowser
//
//  Created by steven lin on 3/6/12.
//  Copyright (c) 2012 LJX. All rights reserved.
//

#import "NSDictionaryAdditions.h"
#import "NSMutableDictionaryAdditions.h"
#import "LJXDebug.h"

@implementation NSDictionary(Additions)
- (id)objectForIntKey:(NSUInteger)key
{
    return [self objectForKey:[NSNumber numberWithInt:key]];
}

- (id)valueForUTF8String:(const char*)nullTerminatedCString
{
    return [self  valueForKey:[NSString stringWithUTF8String:nullTerminatedCString]];
}
+ (NSDictionary*)dictionaryWithMergingDictionary:(NSDictionary*)dict1 anotherDictionary:(NSDictionary*)dict2
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:dict1];
    [dict mergeDictionary:dict2];
    return dict;
}
+ (NSDictionary*)dictionaryWithSelector:(SEL)sel forIntKey:(NSInteger)key
{
    return [NSDictionary dictionaryWithObject:NSStringFromSelector(sel) forKey:[NSNumber numberWithInt:key]];
}


+ (NSDictionary*)dictionaryWithSelectorsAndIntegerKeys:(SEL) firstSelector, ... NS_REQUIRES_NIL_TERMINATION
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:10];
    va_list ap;
    va_start(ap, firstSelector);
    NSInteger key = va_arg(ap, NSInteger);
    SEL sel = firstSelector;
    @try{
        while (sel) {
            [dict setObject:NSStringFromSelector(sel) forKey:[NSNumber numberWithLong:key]];
            sel = va_arg(ap, SEL);            
            key = va_arg(ap, NSInteger);
        }
    }
    @catch(NSException * e) {  
        LJXError( "error:%@", e);
    }
    va_end(ap);
    return dict;
}

+ (NSDictionary*)dictionaryWithFirstObj:(id) firstObj objsAndIntKeyVaList:(va_list) valist
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:10];
    NSInteger key = va_arg(valist, NSInteger);
    id obj = firstObj;
    @try{
        while (obj) {
            [dict setObject:obj forKey:[NSNumber numberWithLong:key]];
            obj = va_arg(valist, id);
            key = va_arg(valist, NSInteger);
        }
    }
    @catch(NSException * e) {
        LJXError( "error:%@", e);
    }
    return dict;
}

//+ (NSDictionary*)dictionaryWithIntAndKeys:(NSInteger) first,  ... NS_REQUIRES_NIL_TERMINATION
//{
//    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:10];
//    va_list ap;
//    va_start(ap, first);
//    NSInteger value = first;
//    NSString* str = va_arg(ap, id);
//    @try{
//        while (str) {
//            [dict setValue:[NSNumber numberWithInt:value] forKey:str];
//            value = va_arg(ap, NSInteger);
//            str = va_arg(ap, id);
//        }
//    }
//    @catch(NSException * e) {
//        LJXError( "error:%@", e);
//    }
//    va_end(ap);
//    return dict;
//}

+ (NSDictionary*)dictionaryWithObjectsAndIntegerKeys:(id) firstObj, ... NS_REQUIRES_NIL_TERMINATION
{
    va_list ap;
    va_start(ap, firstObj);
    NSDictionary* dict = [self dictionaryWithFirstObj:firstObj objsAndIntKeyVaList:ap];
    va_end(ap);
    return dict;
}

+ (NSDictionary*)dictionaryWithDictionaries:(NSDictionary*)dict, ... NS_REQUIRES_NIL_TERMINATION
{
    NSMutableDictionary* result = [NSMutableDictionary dictionaryWithDictionary:dict];
    va_list ap;
    va_start(ap, dict);
    NSDictionary* d = dict;
    while (d) {
        d = va_arg(ap, id);
        if  ([d isKindOfClass:[NSDictionary class]])
        {
            [result addEntriesFromDictionary:d];            
        }
    }
    va_end(ap);
    return result;
}


- (NSString*)jsonStringWithError:(NSError**)error
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:self
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:error];
    return [[NSString alloc] initWithData:data
                                 encoding:NSUTF8StringEncoding];
}


@end
