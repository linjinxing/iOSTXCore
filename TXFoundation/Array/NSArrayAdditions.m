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

#import "NSArrayAdditions.h"

// Core
#import "NSObjectAdditions.h"
#import "LJXDebug.h"



///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * Additions.
 */

@implementation NSArray (LJXCategory)
//
//-(CGFloat)totalHeightForAllImages
//{
//    CGFloat totalHeight = 0.0;
//    for (UIImage* image in self) {
//        if ([image isKindOfClass:[UIImage class]]) {
//            totalHeight += image.size.height;
//        }
//    }
//    return totalHeight;
//}
//
//-(CGFloat)totalWidthForAllImages
//{
//    CGFloat totalWidth = 0.0;
//    for (UIImage* image in self) {
//        if ([image isKindOfClass:[UIImage class]]) {
//            totalWidth += image.size.width;
////            LJXFoundationLog(DM_VIEW, "[totalWidthForAllImages] totalWidth:%f, image width:%f\n", totalWidth, image.size.width);
//        }
//    }
//    return totalWidth;    
//}
//
//- (void)shiftLeft:(CGFloat)aWdith
//{
//    for (int i = 0; i < [self count]; ++i) {
//        UIView* view = [self objectAtIndex:i];
//        if ([view isKindOfClass:[UIView class]]) {
//            view.left -= aWdith;
//        }
//    }    
//}
//
//- (void)shiftTop:(CGFloat)aHeight
//{
//    for (int i = 0; i < [self count]; ++i) {
//        UIView* view = [self objectAtIndex:i];
//        if ([view isKindOfClass:[UIView class]]) {
//            view.top -= aHeight;
//        }
//    }   
//}
//
//- (CGFloat)totalWidthForViews
//{
//    CGFloat width = .0f;
//    for (int i = 0; i < [self count]; ++i) {
//        UIView* view = [self objectAtIndex:i];
//        if ([view isKindOfClass:[UIView class]]) {
//            width += view.width;
//        }
//    }  
//    return width;
//}

//-(void)layoutLinearViewWithSapce:(CGFloat)aSpace orientation:(LAYOUT_ORIENTATION)aOri
//{
//    CGFloat offset = aSpace;
//    if (LO_Vertical == aOri) {
//        for (int i = 0; i < [self count]; ++i) {
//            UIView* view = [self objectAtIndex:i];
//            if ([view isKindOfClass:[UIView class]]) {
//                view.top = offset;
//                offset += (view.height + aSpace);
//            }
//        }
//    }else{
//        for (int i = 0; i < [self count]; ++i) {
//            UIView* view = [self objectAtIndex:i];
//            if ([view isKindOfClass:[UIView class]]) {
//                view.left = offset;
//                offset += (view.width + aSpace);
//            }
//        }        
//    }
//}
//
//-(void)layoutLinearViewWithOrientation:(LAYOUT_ORIENTATION)aOri
//{
//    return [self layoutLinearViewWithSapce:[LJXResouceLayout spaceBetweenControl] orientation:aOri];    
//}
//
//-(void)setTop:(CGFloat)aTop
//{
//    for (UIView* view in self) {
//        if ([view isKindOfClass:[UIView class]]) {
//            view.top = aTop;
//        }
//    }
//}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)perform:(SEL)selector {
  NSArray *copy = [[NSArray alloc] initWithArray:self];
  NSEnumerator* e = [copy objectEnumerator];
  for (id delegate; (delegate = [e nextObject]); ) {
    if ([delegate respondsToSelector:selector]) {
      [delegate performSelector:selector];
    }
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)perform:(SEL)selector withObject:(id)p1 {
  NSArray *copy = [[NSArray alloc] initWithArray:self];
  NSEnumerator* e = [copy objectEnumerator];
  for (id delegate; (delegate = [e nextObject]); ) {
    if ([delegate respondsToSelector:selector]) {
      [delegate performSelector:selector withObject:p1];
    }
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)perform:(SEL)selector withObject:(id)p1 withObject:(id)p2 {
  NSArray *copy = [[NSArray alloc] initWithArray:self];
  NSEnumerator* e = [copy objectEnumerator];
  for (id delegate; (delegate = [e nextObject]); ) {
    if ([delegate respondsToSelector:selector]) {
      [delegate performSelector:selector withObject:p1 withObject:p2];
    }
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)perform:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3 {
  NSArray *copy = [[NSArray alloc] initWithArray:self];
  NSEnumerator* e = [copy objectEnumerator];
  for (id delegate; (delegate = [e nextObject]); ) {
    if ([delegate respondsToSelector:selector]) {
      [delegate performSelector:selector withObject:p1 withObject:p2 withObject:p3];
    }
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)makeObjectsPerformSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 {
  for (id delegate in self) {
    [delegate performSelector:selector withObject:p1 withObject:p2];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)makeObjectsPerformSelector: (SEL)selector
                        withObject: (id)p1
                        withObject: (id)p2
                        withObject: (id)p3 {
  for (id delegate in self) {
    [delegate performSelector:selector withObject:p1 withObject:p2 withObject:p3];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)objectWithValue:(id)value forKey:(id)key {
  for (id object in self) {
    id propertyValue = [object valueForKey:key];
    if ([propertyValue isEqual:value]) {
      return object;
    }
  }
  return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)objectWithClass:(Class)cls {
  for (id object in self) {
    if ([object isKindOfClass:cls]) {
      return object;
    }
  }
  return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)containsObject:(id)object withSelector:(SEL)selector {
  for (id item in self) {
    if ([[item performSelector:selector withObject:object] boolValue]) {
      return YES;
    }
  }
  return NO;
}

- (NSArray*)minusObjectsInArray:(NSArray*)other
{
    NSMutableSet* dSet = [NSMutableSet setWithArray:self];
    NSSet* sSet = [NSSet setWithArray:other];
    [dSet minusSet:sSet];
    return [dSet allObjects];
}



- (void)setObjectsValue:(id)value forKey:(NSString *)key
{
    for (id obj in self) {
        @try {
            [obj setValue:value forKey:key];
        }
        @catch (NSException *exception) {
            LJXNSExceptionError(exception);
        }
//        @finally {
//            <#Code that gets executed whether or not an exception is thrown#>
//        }
    }
}

- (NSArray*)arrayByInsertObject:(id)anObject atIndex:(NSUInteger)index
{
    NSMutableArray* array = [NSMutableArray arrayWithArray:self];
    [array insertObject:anObject atIndex:index];
    return [NSArray arrayWithArray:array];
}

- (NSArray*)arrayByRemoveObject:(id)anObject
{
    NSMutableArray* array = [NSMutableArray arrayWithArray:self];
    [array removeObject:anObject];
    return [NSArray arrayWithArray:array];
}

- (NSArray*)arrayByAddObject:(id)anObject
{
    NSMutableArray* array = [NSMutableArray arrayWithArray:self];
    [array addObject:anObject];
    return [NSArray arrayWithArray:array];
}

- (NSArray*)arrayByRemoveObjectAtIndex:(NSUInteger)index
{
    NSMutableArray* array = [NSMutableArray arrayWithArray:self];
    [array removeObjectAtIndex:index];
    return [NSArray arrayWithArray:array];
}


@end
