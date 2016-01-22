//
//  NSDictionaryAdditions.h
//  LJXBrowser
//
//  Created by steven lin on 3/6/12.
//  Copyright (c) 2012 LJX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary(Additions)
- (id)objectForIntKey:(NSUInteger)key;
- (id)valueForUTF8String:(const char*)nullTerminatedCString;
+ (NSDictionary*)dictionaryWithMergingDictionary:(NSDictionary*)dict1 anotherDictionary:(NSDictionary*)dict2;
+ (NSDictionary*)dictionaryWithSelector:(SEL)sel forIntKey:(NSInteger)key;

+ (NSDictionary*)dictionaryWithDictionaries:(NSDictionary*)dict, ... NS_REQUIRES_NIL_TERMINATION;
/* SEL sel,  NSInteger key */
+ (NSDictionary*)dictionaryWithSelectorsAndIntegerKeys:(SEL) firstSelector, ... NS_REQUIRES_NIL_TERMINATION;

+ (NSDictionary*)dictionaryWithFirstObj:(id) firstSelector objsAndIntKeyVaList:(va_list) valist;

+ (NSDictionary*)dictionaryWithObjectsAndIntegerKeys:(id) firstObject,  ... NS_REQUIRES_NIL_TERMINATION;

//+ (NSDictionary*)dictionaryWithIntAndKeys:(NSInteger) first,  ... NS_REQUIRES_NIL_TERMINATION;
- (NSString*)jsonStringWithError:(NSError**)error;
@end
