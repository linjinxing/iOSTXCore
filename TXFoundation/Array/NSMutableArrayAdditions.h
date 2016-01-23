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

#import <Foundation/Foundation.h>

@interface NSMutableArray (LJXCategory)
- (void)addObjectIfNotNil:(id)object;

/* 减去other数组中的元素 */
- (void)minusObjectsInArray:(NSArray*)other;
/**
 * Adds a string on the condition that it's non-nil and non-empty.
 */
//- (void)addNonEmptyString:(NSString*)string;
-(BOOL)moveObjectFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;
-(BOOL)swapObjetAtIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;

- (void)setValue:(id)value withCount:(NSUInteger)count;
@end
