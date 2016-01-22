//
// Copyright 2009-2011 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "NSMutableDictionaryAdditions.h"

// Core

//#import "LJXGlobalCore.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * Additions.
 */
//LJX_FIX_CATEGORY_BUG(NSMutableDictionaryAdditions)

@implementation NSMutableDictionary (LJXCategory)
- (void)mergeDictionary:(NSDictionary*)aMergedDict
{
    // 合并self中有的key项    
    NSArray* keys = [self allKeys];
    for (NSString* key in keys) {
        id mergedOB = [aMergedDict valueForKey:key];
        if (mergedOB) {
            NSMutableArray* mergedResults = nil;
            id ob = [self valueForKey:key];
            if (ob != mergedOB ) {
                if ([ob isKindOfClass:[NSString class]] && [mergedOB isKindOfClass:[NSString class]]) {
                    // 相同的字符串不添加
                    if ([ob isEqualToString:mergedOB]) {
                        continue;
                    }
                }
                if ([ob isKindOfClass:[NSArray class]]) {
                    mergedResults = [NSMutableArray arrayWithArray:ob];
                }else{
                    mergedResults = [NSMutableArray arrayWithObject:ob];
                }
                if ([mergedOB isKindOfClass:[NSArray class]]) {
                    [mergedResults addObjectsFromArray:mergedOB];
                }else{
                    [mergedResults addObject:mergedOB];
                }  
                [self setValue:mergedResults forKey:key];       
            }
        }
    }
    
    // 合并self中没有的key项
    for (NSString* key in aMergedDict) {
        id ob = [self valueForKey:key];
        if (!ob) {
            [self setValue:key forKey:[aMergedDict valueForKey:key]];
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
//- (void)setNonEmptyString:(NSString*)string forKey:(id)key {
//  if (LJXIsStringWithAnyText(string)) {
//    [self setObject:string forKey:key];
//  }
//}

- (BOOL)removeObject:(id)aObject
{
	NSUInteger index = NSNotFound;
	
	//delete file from corresponding unmerged branch
	NSEnumerator *enumerator = [self objectEnumerator];
	id branch;
	while ((branch = [enumerator nextObject])) {
		index = [branch indexOfObject:aObject];
		if (index != NSNotFound) {
			[branch removeObjectAtIndex:index];
			return TRUE;
		}
	}    
    return FALSE;
}

@end
