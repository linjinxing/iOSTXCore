//
//  AGWindowView.h
//  VG
//
//  Created by Håvard Fossli on 23.01.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//  由于修改了原来的开源代码，因此，将类的名字修改

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * @class AGWindowView
 * @description A view which is added to a UIWindow. It will automatically fill window and rotate along with statusbar rotations.
 */

@interface LJXWindowView : UIView

@property (nonatomic, assign) UIInterfaceOrientationMask supportedInterfaceOrientations;
@property (nonatomic, assign) BOOL supportRotate;
@property (nonatomic, assign) BOOL shouldFullScreen;
/**
 * @property UIViewController *controller. Convinience for having a strong reference to your controller.
 */
@property (nonatomic, strong) UIViewController *controller;
@property (nonatomic, copy) void (^onDidMoveToWindow)(void);
@property (nonatomic, copy) void (^onDidMoveOutOfWindow)(void);

- (id)initAndAddToWindow:(UIWindow *)window;
- (id)initAndAddToKeyWindow;

- (void)setSupportedInterfaceOrientations:(UIInterfaceOrientationMask)supportedInterfaceOrientations animated:(BOOL)animated;

- (void)addSubViewAndKeepSamePosition:(UIView *)view;
- (void)addSubviewAndFillBounds:(UIView *)view;
- (void)addSubviewAndFillBounds:(UIView *)view withSlideUpAnimationOnDone:(void(^)(void))onDone;
- (void)fadeOutAndRemoveFromSuperview:(void(^)(void))onDone;
- (void)slideDownSubviewsAndRemoveFromSuperview:(void(^)(void))onDone;

- (void)bringToFront;
- (BOOL)isInFront;
- (UIInterfaceOrientation)desiredOrientation;

+ (NSArray *)allActiveWindowViews;
+ (LJXWindowView *)firstActiveWindowViewPassingTest:(BOOL (^)(LJXWindowView *windowView, BOOL *stop))test;
- (void)rotateAccordingToStatusBarOrientationAndSupportedOrientations;
@end

@interface AGWindowViewHelper : NSObject

BOOL UIInterfaceOrientationsIsForSameAxis(UIInterfaceOrientation o1, UIInterfaceOrientation o2);
CGFloat UIInterfaceOrientationAngleBetween(UIInterfaceOrientation o1, UIInterfaceOrientation o2);
CGFloat UIInterfaceOrientationAngleOfOrientation(UIInterfaceOrientation orientation);
UIInterfaceOrientationMask UIInterfaceOrientationMaskFromOrientation(UIInterfaceOrientation orientation);

@end
