//
// Copyright 2009-2011 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    hIMp://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import <Foundation/Foundation.h>

typedef enum tagLayoutOrientation
{
    LO_Horizontal,
    LO_Vertical  
}LAYOUT_ORIENTATION;

//
//@interface NSArray (image)
//-(float)totalHeightForAllImages;
//-(float)totalWidthForAllImages;
//@end
//
//@interface NSArray (layout)
//-(void)layoutLinearViewWithSapce:(float)aSpace orientation:(LAYOUT_ORIENTATION)aOri;
//-(void)layoutLinearViewWithOrientation:(LAYOUT_ORIENTATION)aOri;
//-(void)setTop:(float)aTop;
//- (void)shiftLeft:(float)aWdith;
//- (void)shiftTop:(float)aHeight;
//- (float)totalWidthForViews;
//@end

@interface NSArray (LJXCategory)

/**
 * Calls performSelector on all objects that can receive the selector in the array.
 * Makes an iterable copy of the array, making it possible for the selector to modify
 * the array. Contrast this with makeObjectsPerformSelector which does not allow side effects of
 * modifying the array.
 */
- (void)perform:(SEL)selector;
- (void)perform:(SEL)selector withObject:(id)p1;
- (void)perform:(SEL)selector withObject:(id)p1 withObject:(id)p2;
- (void)perform:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3;

/**
 * Extensions to makeObjectsPerformSelector to provide support for more than one object
 * parameter.
 */
- (void)makeObjectsPerformSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2;
- (void)makeObjectsPerformSelector: (SEL)selector
                        withObject: (id)p1
                        withObject: (id)p2
                        withObject: (id)p3;

/**
 * @return nil or an object that matches value with isEqual:
 */
- (id)objectWithValue:(id)value forKey:(id)key;

/**
 * @return the first object with the given class.
 */
- (id)objectWithClass:(Class)cls;

/**
 * @param selector Required format: - (NSNumber*)method:(id)object;
 */
- (BOOL)containsObject:(id)object withSelector:(SEL)selector;

- (NSArray*)minusObjectsInArray:(NSArray*)other;

- (void)setObjectsValue:(id)value forKey:(NSString *)key;

- (NSArray*)arrayByInsertObject:(id)anObject atIndex:(NSUInteger)index;
- (NSArray*)arrayByAddObject:(id)anObject;
- (NSArray*)arrayByRemoveObject:(id)anObject;
- (NSArray*)arrayByRemoveObjectAtIndex:(NSUInteger)index;

- (NSArray*)arrayByRemoveObjectWitBlock:(BOOL(^)(id obj))checkblock;
@end
