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

#import "NSMutableArrayAdditions.h"
#import "LJXDebug.h"
// Core



///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * Additions.
 */

@implementation NSMutableArray (LJXCategory)


///////////////////////////////////////////////////////////////////////////////////////////////////
//- (void) addNonEmptyString:(NSString*)string {
//  if (LJXIsStringWithAnyText(string)) {
//    [self addObject:string];
//  }
//}


-(BOOL)moveObjectFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    BOOL bRetVal = FALSE;
    if (fromIndex >=0 && fromIndex < [self count] && toIndex >=0 && [self count] > toIndex
        && fromIndex != toIndex) {
        // LJXFoundationLog("[swapObjetAtIndex] fromIndex:%d, toIndex:%d, self:%@\n",
        //          fromIndex, toIndex, self);
        id fromObj = [self objectAtIndex:fromIndex];        
        [self removeObjectAtIndex:fromIndex];
        [self insertObject:fromObj atIndex:toIndex];        
        bRetVal = TRUE;
        // LJXFoundationLog("[swapObjetAtIndex] fromObj:%@, toObj:%@, self:%@\n",
        //          fromObj, toObj, self);        
    }else {
        LJXError( "[moveObjectFromIndex] fromIndex:%d, toIndex:%d, self:%@\n",
                  fromIndex, toIndex, self);
    }
    
    return bRetVal;    
}

- (void)minusObjectsInArray:(NSArray*)other
{
    NSMutableSet* dSet = [NSMutableSet setWithArray:self];
    NSSet* sSet = [NSSet setWithArray:other];
    [dSet minusSet:sSet];
    [self removeAllObjects];
    [self addObjectsFromArray:[dSet allObjects]];
}

- (void)addObjectIfNotNil:(id)object
{
    if (object) {
        [self addObject:object];
    }
}

- (void)setValue:(id)value withCount:(NSUInteger)count
{
    if (value) {
        for (NSUInteger i = 0; i < count; ++i) {
            [self addObject:value];
        }
    }
}

@end
