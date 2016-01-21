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

#import "NSObjectAdditions.h"
#import "LJXFoundationMacros.h"
#import "LJXDebug.h"
// Corev


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * Additions.
 */
LJX_FIX_CATEGORY_BUG(NSObjectAdditions)

@implementation NSObject (LJXAdditions)
//
#if defined (_DEBUG_VERSION) && 0
-(BOOL) respondsToSelector:(SEL)aSelector {  
    //NSLog(@"[respondsToSelector ] obj:%@, SEL: %s\n", self, [NSStringFromSelector(aSelector) UTF8String]);  
    return class_respondsToSelector([self class], aSelector);
}  
#endif 
//
//- (void)dealloc
//{
//    //NSLog(@"release self:%@\n", self);
//    object_dispose(self);
//}

//- (void)release
//{
//    //NSLog(@"release self:%@\n", self);
//    objc_release(
//}

- (id)performSelector:(SEL)selector withArgList:(va_list) argList
{
    NSMethodSignature *sig = [self methodSignatureForSelector:selector];
    if (sig && [self respondsToSelector:selector])
    {
        NSUInteger idx = 2;
        NSUInteger numOfArgs = [sig numberOfArguments] - idx; // 至少有self和_cmd参数，因此-2
        NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
        [invo setTarget:self];
        [invo setSelector:selector];
        while (numOfArgs > 0) {
            id arg = va_arg(argList, id);
            [invo setArgument:(void *)(&arg) atIndex:idx++];
            numOfArgs--;
        }
        [invo invoke];
        if (sig.methodReturnLength) {
            __unsafe_unretained id anObject;
            [invo getReturnValue:&anObject];
            return anObject;
        } else {
            return nil;
        }
    }else{
        LJXError( "havn't found sel:%@, or don't responds to selector:%d",  NSStringFromSelector(selector), [self respondsToSelector:selector]);
        return nil;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)performSelector:(SEL)selector withObject:(__unsafe_unretained id)p1 withObject:(__unsafe_unretained id)p2 withObject:(__unsafe_unretained id)p3 {
  NSMethodSignature *sig = [self methodSignatureForSelector:selector];
  if (sig) {
    NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
    [invo setTarget:self];
    [invo setSelector:selector];
    [invo setArgument:&p1 atIndex:2];
    [invo setArgument:&p2 atIndex:3];
    [invo setArgument:&p3 atIndex:4];
    [invo invoke];
    if (sig.methodReturnLength) {
      __unsafe_unretained id anObject;
      [invo getReturnValue:&anObject];
      return anObject;

    } else {
      return nil;
    }

  } else {
    return nil;
  }
}
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)performSelector:(SEL)selector withObject:(__unsafe_unretained id)p1 withObject:(__unsafe_unretained id)p2 withObject:(__unsafe_unretained id)p3
    withObject:(__unsafe_unretained id)p4 {
  NSMethodSignature *sig = [self methodSignatureForSelector:selector];
  if (sig) {
    NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
    [invo setTarget:self];
    [invo setSelector:selector];
    [invo setArgument:&p1 atIndex:2];
    [invo setArgument:&p2 atIndex:3];
    [invo setArgument:&p3 atIndex:4];
    [invo setArgument:&p4 atIndex:5];
    [invo invoke];
    if (sig.methodReturnLength) {
      __unsafe_unretained id anObject;
      [invo getReturnValue:&anObject];
      return anObject;

    } else {
      return nil;
    }

  } else {
    return nil;
  }
}
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////////
//- (__unsafe_unretained id)performSelector:(SEL)selector withObject:(__unsafe_unretained id)p1 withObject:(__unsafe_unretained id)p2 withObject:(__unsafe_unretained id)p3
//    withObject:(__unsafe_unretained id)p4 withObject:(__unsafe_unretained id)p5 {
//  NSMethodSignature *sig = [self methodSignatureForSelector:selector];
//  if (sig) {
//    NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
//    [invo setTarget:self];
//    [invo setSelector:selector];
//    [invo setArgument:&p1 atIndex:2];
//    [invo setArgument:&p2 atIndex:3];
//    [invo setArgument:&p3 atIndex:4];
//    [invo setArgument:&p4 atIndex:5];
//    [invo setArgument:&p5 atIndex:6];
//    [invo invoke];
//    if (sig.methodReturnLength) {
//      __unsafe_unretained idanObject;
//      [invo getReturnValue:&anObject];
//      return anObject;
//
//    } else {
//      return nil;
//    }
//
//  } else {
//    return nil;
//  }
//}
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////////
//- (__unsafe_unretained id)performSelector:(SEL)selector withObject:(__unsafe_unretained id)p1 withObject:(__unsafe_unretained id)p2 withObject:(__unsafe_unretained id)p3
//    withObject:(__unsafe_unretained id)p4 withObject:(__unsafe_unretained id)p5 withObject:(__unsafe_unretained id)p6 {
//  NSMethodSignature *sig = [self methodSignatureForSelector:selector];
//  if (sig) {
//    NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
//    [invo setTarget:self];
//    [invo setSelector:selector];
//    [invo setArgument:&p1 atIndex:2];
//    [invo setArgument:&p2 atIndex:3];
//    [invo setArgument:&p3 atIndex:4];
//    [invo setArgument:&p4 atIndex:5];
//    [invo setArgument:&p5 atIndex:6];
//    [invo setArgument:&p6 atIndex:7];
//    [invo invoke];
//    if (sig.methodReturnLength) {
//      __unsafe_unretained idanObject;
//      [invo getReturnValue:&anObject];
//      return anObject;
//
//    } else {
//      return nil;
//    }
//
//  } else {
//    return nil;
//  }
//}
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////////
//- (__unsafe_unretained id)performSelector:(SEL)selector withObject:(__unsafe_unretained id)p1 withObject:(__unsafe_unretained id)p2 withObject:(__unsafe_unretained id)p3
//    withObject:(__unsafe_unretained id)p4 withObject:(__unsafe_unretained id)p5 withObject:(__unsafe_unretained id)p6 withObject:(__unsafe_unretained id)p7 {
//  NSMethodSignature *sig = [self methodSignatureForSelector:selector];
//  if (sig) {
//    NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
//    [invo setTarget:self];
//    [invo setSelector:selector];
//    [invo setArgument:&p1 atIndex:2];
//    [invo setArgument:&p2 atIndex:3];
//    [invo setArgument:&p3 atIndex:4];
//    [invo setArgument:&p4 atIndex:5];
//    [invo setArgument:&p5 atIndex:6];
//    [invo setArgument:&p6 atIndex:7];
//    [invo setArgument:&p7 atIndex:8];
//    [invo invoke];
//    if (sig.methodReturnLength) {
//      __unsafe_unretained idanObject;
//      [invo getReturnValue:&anObject];
//      return anObject;
//
//    } else {
//      return nil;
//    }
//
//  } else {
//    return nil;
//  }
//}


@end
