//
//  AGWindowView.m
//  VG
//
//  Created by  Fossli on 23.01.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "LJXWindowView.h"
#import "LJXFoundationMacros.h"
#import "LJXDebug.h"


static NSMutableArray *_activeWindowViews;

//@interface LJXWindowView ()
//
//@end

@implementation LJXWindowView

#if ! __has_feature(objc_arc)
#error Requires ARC
#endif

#pragma mark - Construct, destruct and setup

+ (void)initialize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _activeWindowViews = [NSMutableArray array];
    });
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setup];
        self.opaque = NO;
        self.supportRotate = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;    
}

- (id)initAndAddToWindow:(UIWindow *)window
{
    self = [self initWithFrame:CGRectZero];
    if(self)
    {
        [window addSubview:self];
    }
    return self;
}

- (id)initAndAddToKeyWindow
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    self = [self initAndAddToWindow:window];
    if(self)
    {
    }
    return self;
}

- (void)setup
{    
    _supportedInterfaceOrientations = UIInterfaceOrientationMaskAll;
//    if ([LJXSystem isiPad]) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarFrameOrOrientationChanged:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
//    }else
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarFrameOrOrientationChanged:) name:LJXIsPad? UIApplicationDidChangeStatusBarOrientationNotification: UIDeviceOrientationDidChangeNotification object:nil];
    }
}

- (void)setSupportedInterfaceOrientations:(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    _supportedInterfaceOrientations = supportedInterfaceOrientations;
    
    if(self.window != nil)
    {
        [self rotateAccordingToStatusBarOrientationAndSupportedOrientations];
    }
}

- (void)setSupportedInterfaceOrientations:(UIInterfaceOrientationMask)supportedInterfaceOrientations animated:(BOOL)animated
{
    _supportedInterfaceOrientations = supportedInterfaceOrientations;
    
    if(self.window != nil)
    {
        [self rotateAccordingToStatusBarOrientationAndSupportedOrientationsWithAnimated:animated];
    }
}

- (void)statusBarFrameOrOrientationChanged:(NSNotification *)notification
{
    /*
     This notification is most likely triggered inside an animation block,
     therefore no animation is needed to perform this nice transition.
     */
    
    if (!self.supportRotate) {
        return;
    }
    UIDeviceOrientation  deviceOrientation = [[UIDevice currentDevice] orientation];
    if (deviceOrientation==UIDeviceOrientationFaceUp && LJXIsPhone) {
        return;
    }
    [self rotateAccordingToStatusBarOrientationAndSupportedOrientations];
}

- (void)rotateAccordingToStatusBarOrientationAndSupportedOrientationsWithAnimated:(BOOL)animated
{
    if (self.window)
    {
        UIInterfaceOrientation orientation = [self desiredOrientation];
        CGFloat angle = UIInterfaceOrientationAngleOfOrientation(orientation);
        CGFloat statusBarHeight = [[self class] getStatusBarHeight];
        UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
        
        CGAffineTransform transform = CGAffineTransformMakeRotation(angle);
        CGRect frame = [[self class] rectInWindowBounds:self.window.bounds statusBarOrientation:statusBarOrientation statusBarHeight:statusBarHeight];
        
        [self setIfNotEqualTransform:transform frame:frame animated:animated];
    }
}

- (void)rotateAccordingToStatusBarOrientationAndSupportedOrientations
{
    [self rotateAccordingToStatusBarOrientationAndSupportedOrientationsWithAnimated:YES];
}

- (void)setIfNotEqualTransform:(CGAffineTransform)transform frame:(CGRect)frame animated:(BOOL)animated
{
    if (self.shouldFullScreen)
    {
        if (animated) {
            [UIView beginAnimations:@"AGWindow" context:nil];
            [UIView setAnimationDuration:0.3];
        }
        
        if(!CGAffineTransformEqualToTransform(self.transform, transform))
        {
            self.transform = transform;
        }
        if(!CGRectEqualToRect(self.frame, frame))
        {
            self.frame = frame;
        }
        LJXUILog("frame:%@", NSStringFromCGRect(frame));
        if (animated) {
            [UIView commitAnimations];
        }
    }
}

- (void)setIfNotEqualTransform:(CGAffineTransform)transform frame:(CGRect)frame
{
    [self setIfNotEqualTransform:transform frame:frame animated:YES];
}

+ (CGFloat)getStatusBarHeight
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if(UIInterfaceOrientationIsLandscape(orientation))
    {
        return [UIApplication sharedApplication].statusBarFrame.size.width;
    }
    else
    {
        return [UIApplication sharedApplication].statusBarFrame.size.height;
    }
}

+ (CGRect)rectInWindowBounds:(CGRect)windowBounds statusBarOrientation:(UIInterfaceOrientation)statusBarOrientation statusBarHeight:(CGFloat)statusBarHeight
{    
    CGRect frame = windowBounds;
    frame.origin.x += statusBarOrientation == UIInterfaceOrientationLandscapeLeft ? statusBarHeight : 0;
    frame.origin.y += statusBarOrientation == UIInterfaceOrientationPortrait ? statusBarHeight : 0;
    frame.size.width -= UIInterfaceOrientationIsLandscape(statusBarOrientation) ? statusBarHeight : 0;
    frame.size.height -= UIInterfaceOrientationIsPortrait(statusBarOrientation) ? statusBarHeight : 0;
    return frame;
}

- (UIInterfaceOrientation)desiredOrientation
{
    UIInterfaceOrientation statusBarOrientation = [UIDevice currentDevice].orientation ;
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())
    {
        statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
    }
    
    UIInterfaceOrientationMask statusBarOrientationAsMask = UIInterfaceOrientationMaskFromOrientation(statusBarOrientation);
    if (self.supportedInterfaceOrientations & statusBarOrientationAsMask)
    {
        return statusBarOrientation;
    }
    else
    {
        if(self.supportedInterfaceOrientations & UIInterfaceOrientationMaskPortrait)
        {
            return UIInterfaceOrientationPortrait;
        }
        else if(self.supportedInterfaceOrientations & UIInterfaceOrientationMaskLandscapeRight)
        {
            return UIInterfaceOrientationLandscapeRight;
        }
        else if(self.supportedInterfaceOrientations & UIInterfaceOrientationMaskLandscapeLeft)
        {
            return UIInterfaceOrientationLandscapeLeft;
            
        }
        else
        {
            return UIInterfaceOrientationPortraitUpsideDown;
        }
    }
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    if(self.window == nil)
    {
        self.onDidMoveOutOfWindow ? self.onDidMoveOutOfWindow() : nil;
        [_activeWindowViews removeObject:self];
    }
    else
    {
        self.onDidMoveToWindow ? self.onDidMoveToWindow() : nil;
        [_activeWindowViews addObject:self];
        [self rotateAccordingToStatusBarOrientationAndSupportedOrientationsWithAnimated:NO];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Presentation

- (void)addSubViewAndKeepSamePosition:(UIView *)view
{
    if(view.superview == nil)
    {
        [NSException raise:NSInternalInconsistencyException format:@"When calling moveViewToKeyWindow: we are expecting the view to be moved is already in a view hirearchy."];
    }
    
    view.frame = [view convertRect:view.bounds toView:self];
    [self addSubview:view];
}

- (void)addSubviewAndFillBounds:(UIView *)view
{
    view.frame = [self bounds];
    [self addSubview:view];
}

- (void)addSubviewAndFillBounds:(UIView *)view withSlideUpAnimationOnDone:(void(^)(void))onDone
{
    CGRect endFrame = [self bounds];
    CGRect startFrame = endFrame;
    startFrame.origin.y += startFrame.size.height;
    
    view.frame = startFrame;
    [self addSubview:view];
    
    [UIView animateWithDuration:0.4 animations:^{
        view.frame = endFrame;
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        self.opaque = YES;
    } completion:^(BOOL finished) {
        if(onDone)
        {
            onDone();
        }
    }];
}

- (void)fadeOutAndRemoveFromSuperview:(void(^)(void))onDone
{
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if(onDone)
        {
            onDone();
        }
    }];
}

- (void)slideDownSubviewsAndRemoveFromSuperview:(void(^)(void))onDone
{
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    self.opaque = YES;
    
    [UIView animateWithDuration:0.4 animations:^{
        
        for(UIView *subview in [self subviews])
        {
            CGRect frame = subview.frame;
            frame.origin.y += self.bounds.size.height;
            subview.frame = frame;
        }
        
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        self.opaque = NO;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if(onDone)
        {
            onDone();
        }
    }];
}

- (void)bringToFront
{
    [self.superview bringSubviewToFront:self];
}

- (BOOL)isInFront
{
    NSArray *subviewsOnSuperview = [self.superview subviews];
    NSUInteger index = [subviewsOnSuperview indexOfObject:self];
    return index == subviewsOnSuperview.count - 1;
}

#pragma mark - Convinience methods

+ (NSArray *)allActiveWindowViews
{
    return _activeWindowViews;
}

+ (LJXWindowView *)firstActiveWindowViewPassingTest:(BOOL (^)(LJXWindowView *windowView, BOOL *stop))test
{
    __block LJXWindowView *hit = nil;
    [_activeWindowViews enumerateObjectsUsingBlock:^(LJXWindowView *windowView, NSUInteger idx, BOOL *stop) {
        if(test(windowView, stop))
        {
            hit = windowView;
        }
    }];
    return hit;
}

@end


@implementation AGWindowViewHelper

BOOL UIInterfaceOrientationsIsForSameAxis(UIInterfaceOrientation o1, UIInterfaceOrientation o2)
{
    if(UIInterfaceOrientationIsLandscape(o1) && UIInterfaceOrientationIsLandscape(o2))
    {
        return YES;
    }
    else if(UIInterfaceOrientationIsPortrait(o1) && UIInterfaceOrientationIsPortrait(o2))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

CGFloat UIInterfaceOrientationAngleBetween(UIInterfaceOrientation o1, UIInterfaceOrientation o2)
{
    CGFloat angle1 = UIInterfaceOrientationAngleOfOrientation(o1);
    CGFloat angle2 = UIInterfaceOrientationAngleOfOrientation(o2);
    
    return angle1 - angle2;
}

CGFloat UIInterfaceOrientationAngleOfOrientation(UIInterfaceOrientation orientation)
{
    CGFloat angle;
    
    switch (orientation)
    {
        case UIInterfaceOrientationPortraitUpsideDown:
            angle = M_PI;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            angle = -M_PI_2;
            break;
        case UIInterfaceOrientationLandscapeRight:
            angle = M_PI_2;
            break;
        default:
            angle = 0.0;
            break;
    }
    
    return angle;
}

UIInterfaceOrientationMask UIInterfaceOrientationMaskFromOrientation(UIInterfaceOrientation orientation)
{
    return 1 << orientation;
}

@end
