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
#import <UIKit/UIKit.h>

@interface UIView (other)

- (UINavigationController*)navigationController;
/**
 * Finds the first descendant view (including this view) that is a member of a particular class.
 */
- (UIView*)descendantOrSelfWithClass:(Class)cls;


/**
 * Finds the first ancestor view (including this view) that is a member of a particular class.
 */
- (UIView*)ancestorOrSelfWithClass:(Class)cls;


/* 根据NSStringFromClass返回的值，来设置相应的view的identifier */
@property(nonatomic, copy)NSString* identifier;

- (UIViewController*)viewController;
/**
 * Shows the view in a window at the bottom of the screen.
 *
 * This will send a notification pretending that a keyboard is about to appear so that
 * observers who adjust their layout for the keyboard will also adjust for this view.
 */
//- (void)presentAsKeyboardInView:(UIView*)containingView;

/**
 * Hides a view that was showing in a window at the bottom of the screen (via presentAsKeyboard).
 *
 * This will send a notification pretending that a keyboard is about to disappear so that
 * observers who adjust their layout for the keyboard will also adjust for this view.
 */
//- (void)dismissAsKeyboard:(BOOL)animated;
//
//- (void)setBackgroundImage:(UIImage*)aImage;
//- (void)removeBackgroundImage;
@end

@interface UIView (control)
- (UIButton*)buttonWithTag:(NSInteger)tag;
- (UILabel*)labelWithTag:(NSInteger)tag;
- (UIProgressView*)progressViewWithTag:(NSInteger)tag;
- (UISlider*)sliderWithTag:(NSInteger)tag;
@end


@interface UIView(orientaion)
- (void)transformWhenDeviceOrientationDidChange;
- (void)setTransformForCurrentOrientation:(BOOL)animated;
@end

@interface UIView(transform)
- (void)scale:(CGFloat)aRatio;
@end

@interface UIView(graph)
+ (void) drawRoundRectangleInRect:(CGRect)rect withRadius:(CGFloat)radius;
@end


