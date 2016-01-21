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

#import <QuartzCore/QuartzCore.h>

#import "UIViewAdditions.h"
#import "UIView+Layout.h"
//
//#import "LJXConstValue.h"
//// Core
//
//
//#import "LJXResouceLayout.h"
//// UINavigator
//
//// UICommon
//#import "LJXGlobalUICommon.h"
//
//#import "UINavigationBarAddition.h"

// Remove GSEvent and UITouchAdditions from Release builds
#ifdef DEBUG

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * A private API class used for synthesizing touch events. This class is compiled out of release
 * builds.
 *
 * This code for synthesizing touch events is derived from:
 * http://cocoawithlove.com/2008/10/synthesizing-touch-event-on-iphone.html
 */
@interface LJXGSEventFake : NSObject {
  @public
  int ignored1[5];
  float x;
  float y;
  int ignored2[24];
}
@end


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation LJXGSEventFake
@end


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@interface LJXUIEventFake : NSObject {
  @public
  CFTypeRef               _event;
  NSTimeInterval          _timestamp;
  NSMutableSet*           _touches;
  CFMutableDictionaryRef  _keyedTouches;
}

@end


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation LJXUIEventFake

@end


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation UIEvent (LJXCategory)


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithTouch:(UITouch *)touch {
  if (self == [super init]) {
    LJXUIEventFake *selfFake = (LJXUIEventFake*)self;
    selfFake->_touches = [NSMutableSet setWithObject:touch];
    selfFake->_timestamp = [NSDate timeIntervalSinceReferenceDate];

    CGPoint location = [touch locationInView:touch.window];
    LJXGSEventFake* fakeGSEvent = [[LJXGSEventFake alloc] init];
    fakeGSEvent->x = location.x;
    fakeGSEvent->y = location.y;
    selfFake->_event = (__bridge CFTypeRef)(fakeGSEvent);

    CFMutableDictionaryRef dict = CFDictionaryCreateMutable(kCFAllocatorDefault, 2,
      &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFDictionaryAddValue(dict, (__bridge const void *)(touch.view), (__bridge const void *)(selfFake->_touches));
    CFDictionaryAddValue(dict, (__bridge const void *)(touch.window), (__bridge const void *)(selfFake->_touches));
    selfFake->_keyedTouches = dict;
  }
  return self;
}


@end

#endif


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * Additions.
 */
//LJX_FIX_CATEGORY_BUG(UIViewAdditions)

@implementation UIView (LJXCategory)

///////////////////////////////////////////////////////////////////////////////////////////////////
//- (CGFloat)orientationWidth {
//    return [LJXResouceLayout interfaceOrientationIsPortrait]
//    ? self.height : self.width;
//}
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////////
//- (CGFloat)orientationHeight {
//  return [LJXResouceLayout interfaceOrientationIsPortrait]
//    ? self.width : self.height;
//}

static NSMutableDictionary* s_dict = nil;

- (NSString*)identifier
{
    return [s_dict valueForKey:NSStringFromClass([self class])];
}

- (void)setIdentifier:(NSString *)identifier
{
    if (nil == s_dict) {
        s_dict = [[NSMutableDictionary alloc] initWithCapacity:30];
    }
    [s_dict setValue:[identifier copy] forKey:NSStringFromClass([self class])];
}

- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UINavigationController class]]) {
            UINavigationController* navCtrl = (UINavigationController* )nextResponder;
            return navCtrl.topViewController;
        }else{
            if ([nextResponder isKindOfClass:[UIViewController class]]) {
                return (UIViewController*)nextResponder;
            }            
        }
    }
    return nil;
}

- (UINavigationController*)navigationController {
    UIViewController* viewController = self.viewController;
    UINavigationController* navController = nil;    
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        navController = (UINavigationController*)viewController;
    }else{
        navController = viewController.navigationController;
    }   
    return navController;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)descendantOrSelfWithClass:(Class)cls {
  if ([self isKindOfClass:cls])
    return self;

  for (UIView* child in self.subviews) {
    UIView* it = [child descendantOrSelfWithClass:cls];
    if (it)
      return it;
  }

  return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)ancestorOrSelfWithClass:(Class)cls {
  if ([self isKindOfClass:cls]) {
    return self;

  } else if (self.superview) {
    return [self.superview ancestorOrSelfWithClass:cls];

  } else {
    return nil;
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////
//- (CGRect)frameWithKeyboardSubtracted:(CGFloat)plusHeight {
//  CGRect frame = self.frame;
//  if (LJXIsKeyboardVisible()) {
//    CGRect screenFrame = [LJXResouceLayout screenBounds];
//    CGFloat keyboardTop = screenFrame.size.height - ([LJXResouceLayout keyboardHeight] + plusHeight);
//    CGFloat screenBottom = self.ttScreenY + frame.size.height;
//    CGFloat diff = screenBottom - keyboardTop;
//    if (diff > 0) {
//      frame.size.height -= diff;
//    }
//  }
//  return frame;
//}
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////////
//- (NSDictionary *)userInfoForKeyboardNotification {
//  CGRect screenFrame = [LJXResouceLayout screenBounds];
//  CGRect bounds = CGRectMake(0, 0, screenFrame.size.width, self.height);
//  CGPoint centerBegin = CGPointMake(floor(screenFrame.size.width/2 - self.width/2),
//                                    screenFrame.size.height + floor(self.height/2));
//  CGPoint centerEnd = CGPointMake(floor(screenFrame.size.width/2 - self.width/2),
//                                  screenFrame.size.height - floor(self.height/2));
//
//  return [NSDictionary dictionaryWithObjectsAndKeys:
//          [NSValue valueWithCGRect:bounds], UIKeyboardBoundsUserInfoKey,
//          [NSValue valueWithCGPoint:centerBegin], UIKeyboardCenterBeginUserInfoKey,
//          [NSValue valueWithCGPoint:centerEnd], UIKeyboardCenterEndUserInfoKey,
//          nil];
//}


///////////////////////////////////////////////////////////////////////////////////////////////////
//- (void)presentAsKeyboardAnimationDidStop {
//  [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardDidShowNotification
//                                                      object:self
//                                                    userInfo:[self
//                                                              userInfoForKeyboardNotification]];
//}
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////////
//- (void)dismissAsKeyboardAnimationDidStop {
//  [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardDidHideNotification
//                                                      object:self
//                                                    userInfo:[self
//                                                              userInfoForKeyboardNotification]];
//  [self removeFromSuperview];
//}
//

///////////////////////////////////////////////////////////////////////////////////////////////////
//- (void)presentAsKeyboardInView:(UIView*)containingView {
//  [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardWillShowNotification
//                                                      object:self
//                                                    userInfo:[self
//                                                              userInfoForKeyboardNotification]];
//
//  self.top = containingView.height;
//  [containingView addSubview:self];
//
//  [UIView beginAnimations:nil context:nil];
//  [UIView setAnimationDuration:LJXConstValueAnimationDuration];
//  [UIView setAnimationDelegate:self];
//  [UIView setAnimationDidStopSelector:@selector(presentAsKeyboardAnimationDidStop)];
//  self.top -= self.height;
//  [UIView commitAnimations];
//}

////
////static  const NSUInteger s_backgroundImageViewTag = 323972389;
////
////- (void)removeBackgroundImage
////{
////    if ([self respondsToSelector:@selector(setBackgroundImage:forToolbarPosition:barMetrics:)]) {
////        [(UIToolbar*)self setBackgroundImage:nil forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
////    }else if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
////    {
////        [(UINavigationBar*)self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
////    }else if ([self isKindOfClass:[UISearchBar class]] && [self respondsToSelector:@selector(setBackgroundImage:)])
////    {
////        [(UISearchBar*)self setBackgroundImage:nil];
////    }else{
////        if ([self isKindOfClass:[UINavigationBar class]]) {
////            [(UINavigationBar*)self showCustomBackgroundImage:NO];        
////        }else {        
////            [[self viewWithTag:s_backgroundImageViewTag] removeFromSuperview];        
////        }
////    }        
////}
//
//- (void)setBackgroundImage:(UIImage*)aImage
//{
//#if defined (_DUO_PING_BROWSER)    
//    if ([self respondsToSelector:@selector(setBackgroundImage:forToolbarPosition:barMetrics:)]) {
//        [(UIToolbar*)self setBackgroundImage:aImage forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
//    }else if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
//    {
//        [(UINavigationBar*)self setBackgroundImage:aImage forBarMetrics:UIBarMetricsDefault];
//    }else if ([self isKindOfClass:[UISearchBar class]] && [self respondsToSelector:@selector(setBackgroundImage:)])
//    {
//        [(UISearchBar*)self setBackgroundImage:aImage];
//    }else{
//        if ([self isKindOfClass:[UINavigationBar class]]) {
//                [(UINavigationBar*)self showCustomBackgroundImage:YES];        
//        }else {
//            if ([self isKindOfClass:[UIToolbar class]]) {
//                UIView* view = [self viewWithTag:s_backgroundImageViewTag];
//                if (nil == view) {
//                    view = [[[UIImageView alloc] initWithImage:aImage] autorelease];
//                    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//                    view.tag = s_backgroundImageViewTag;
//                    view.frame = self.bounds;
//                    [self insertSubview:view atIndex:0];
//                }
//                [self sendSubviewToBack:view];
//                [self setNeedsLayout];
//            }            
//        }
////        self.layer.contents = (id)aImage.CGImage;
//    }
//#else
//    if ([self respondsToSelector:@selector(setTintColor:)] && ![LJXSystem isiPad]) 
//    {
//        [(UIToolbar*)self setTintColor:[UIColor blackColor]];
//    }
//    else
//    {
//        [(UIToolbar*)self setBarStyle:UIBarStyleDefault];
//        //        [(UIToolbar*)self setTintColor:[UIColor whiteColor]];        
//    }
//#endif    
//}

///////////////////////////////////////////////////////////////////////////////////////////////////
//- (void)dismissAsKeyboard:(BOOL)animated {
//  [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardWillHideNotification
//                                                      object:self
//                                                    userInfo:[self
//                                                              userInfoForKeyboardNotification]];
//
//  if (animated) {
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:LJXConstValueAnimationDuration];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDidStopSelector:@selector(dismissAsKeyboardAnimationDidStop)];
//  }
//
//  self.top += self.height;
//
//  if (animated) {
//    [UIView commitAnimations];
//
//  } else {
//    [self dismissAsKeyboardAnimationDidStop];
//  }
//}


+ (void) drawRoundRectangleInRect:(CGRect)rect withRadius:(CGFloat)radius{
	CGContextRef context = UIGraphicsGetCurrentContext();
    
	
	CGRect rrect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height );
    
	CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
	CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
	CGContextMoveToPoint(context, minx, midy);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
	CGContextClosePath(context);
	CGContextDrawPath(context, kCGPathFill);
}

@end


@implementation UIView(orientaion)

- (void)setTransformForCurrentOrientation:(BOOL)animated {
	// Stay in sync with the superview
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if ([self.superview isKindOfClass:[UIWindow class]]) {
		CGFloat width = 0, height = 0;
        if (UIInterfaceOrientationIsPortrait(orientation)) {
            width = self.superview.width ;
            height = self.superview.height;
        }else{
            width = self.superview.height ;
            height = self.superview.width;
        }
        self.size = CGSizeMake(width, height);
	}
	else if (self.superview) {
		self.bounds = self.superview.bounds;
	}
    [self setNeedsLayout];
    [self setNeedsDisplay];    
	
	CGFloat radians = 0;
	if (UIInterfaceOrientationIsLandscape(orientation)) {
		if (orientation == UIInterfaceOrientationLandscapeLeft) { radians = -(CGFloat)M_PI_2; }
		else { radians = (CGFloat)M_PI_2; }
		// Window coordinates differ!
		self.bounds = CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.width);
	} else {
		if (orientation == UIInterfaceOrientationPortraitUpsideDown) { radians = (CGFloat)M_PI; }
		else { radians = 0; }
	}
	CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(radians);
	
	if (animated) {
		[UIView beginAnimations:nil context:nil];
	}
	[self setTransform:rotationTransform];
	if (animated) {
		[UIView commitAnimations];
	}
}


- (void)registerForNotifications {
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(deviceOrientationDidChange:)
			   name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)unregisterFromNotifications {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
	UIView *superview = self.superview;
	if (!superview) {
		return;
	} else if ([superview isKindOfClass:[UIWindow class]]) {
		[self setTransformForCurrentOrientation:YES];
	} else {
		self.bounds = self.superview.bounds;
		[self setNeedsDisplay];
	}
}

- (void)transformWhenDeviceOrientationDidChange
{
    if ([self.superview isKindOfClass:[UIWindow class]])
    {
        [self setTransformForCurrentOrientation:NO];
    };
    [self registerForNotifications];
}

@end


@implementation UIView (control)
- (id)___viewWithTag:(NSInteger)tag class:(Class)cls{
    for (UIView* view in self.subviews) {
        if (tag == view.tag) {
            if ([view isKindOfClass:cls]){
                return view;
            }
        }
    }
    return nil;
}


- (UILabel*)labelWithTag:(NSInteger)tag{
    return [self ___viewWithTag:tag class:[UILabel class]];
}

- (UIButton*)buttonWithTag:(NSInteger)tag{
    return [self ___viewWithTag:tag class:[UIButton class]];
}

- (UIProgressView*)progressViewWithTag:(NSInteger)tag{
    return [self ___viewWithTag:tag class:[UIProgressView class]];
}

- (UISlider*)sliderWithTag:(NSInteger)tag{
    return [self ___viewWithTag:tag class:[UISlider class]];
}

@end
