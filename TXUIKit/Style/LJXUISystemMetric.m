//
//  LJXResouceLayout.m
//  QvodUI
//
//  Created by steven on 11/29/12.
//  Copyright (c) 2012 steven. All rights reserved.
//

#import "LJXUISystemMetric.h"
#import "UIViewAdditions.h"

static const CGFloat kDefaultRowHeight = 44;

static const CGFloat kDefaultNaviBarHeightPortrait = 44.0f;
static const CGFloat kDefaultNaviBarHeightLandscape = 32.0f;

static const CGFloat kDefaultPortraitToolbarHeight   = 44;
static const CGFloat kDefaultLandscapeToolbarHeight  = 33;

static const CGFloat kDefaultPortraitKeyboardHeight      = 216;
static const CGFloat kDefaultLandscapeKeyboardHeight     = 160;
static const CGFloat kDefaultPadPortraitKeyboardHeight   = 264;
static const CGFloat kDefaultPadLandscapeKeyboardHeight  = 352;

static const CGFloat kGroupedTableCellInset = 9;
static const CGFloat kGroupedPadTableCellInset = 42;

static const CGFloat kDefaultTransitionDuration      = 0.3;
static const CGFloat kDefaultFastTransitionDuration  = 0.2;
static const CGFloat kDefaultFlipTransitionDuration  = 0.7;

#define _ROW_HEIGHT                 kDefaultRowHeight
#define _TOOLBAR_HEIGHT             kDefaultPortraitToolbarHeight
#define _LANDSCAPE_TOOLBAR_HEIGHT   kDefaultLandscapeToolbarHeight

#define _KEYBOARD_HEIGHT                 kDefaultPortraitKeyboardHeight
#define _LANDSCAPE_KEYBOARD_HEIGHT       kDefaultLandscapeKeyboardHeight
#define _IPAD_KEYBOARD_HEIGHT            kDefaultPadPortraitKeyboardHeight
#define _IPAD_LANDSCAPE_KEYBOARD_HEIGHT  kDefaultPadLandscapeKeyboardHeight


@implementation LJXUISystemMetric

+ (UIInterfaceOrientation) interfaceOrientation {
    UIInterfaceOrientation orient = [UIApplication sharedApplication].statusBarOrientation;
    if (UIDeviceOrientationUnknown == orient) {
        UIWindow* window = [UIApplication sharedApplication].keyWindow;
        if (window.subviews)
        {
            UIView* view = [window.subviews objectAtIndex:0];
            if(view.viewController)
            {
                return view.viewController.interfaceOrientation;
            }
        }
    }
    
    return orient;
}

+(BOOL) interfaceOrientationIsPortrait
{
    return UIInterfaceOrientationIsPortrait([self interfaceOrientation]);
}



+(CGFloat) defaultCellHeight
{
    return 44.0;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

+(CGRect) screenBounds {
    CGRect bounds = [UIScreen mainScreen].bounds;
    if (![self interfaceOrientationIsPortrait]) {
        CGFloat width = bounds.size.width;
        bounds.size.width = bounds.size.height;
        bounds.size.height = width;
    }
    
    //    bounds.size.width *= [UIScreen mainScreen].scale;
    //    bounds.size.height *= [UIScreen mainScreen].scale;
    
    return bounds;
}

+ (CGSize)  screenSizeWithOrientation:(UIInterfaceOrientation)o
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    if (UIInterfaceOrientationIsPortrait(o))
    {
        return size;
    }else{
        return CGSizeMake(size.height, size.width);
    }
}

+ (CGFloat) naviBarHeightWithOrientation:(UIInterfaceOrientation)o
{
    if ([LJXSystem isiPad]) {
        return kDefaultNaviBarHeightPortrait;
    }
    if (UIInterfaceOrientationIsPortrait(o)) return kDefaultNaviBarHeightPortrait;
    else return kDefaultNaviBarHeightLandscape;
}

+ (CGSize) naviBarSizeWithOrientation:(UIInterfaceOrientation)o
{
    return CGSizeMake([self screenSizeWithOrientation:o].width, [self naviBarHeightWithOrientation:o]);
}

+(CGFloat) screenHeight
{
    return [self screenBounds].size.height;
}

+(CGFloat) screenWidth
{
    return [self screenBounds].size.width;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+(CGRect) appFrame {
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    return CGRectMake(0, 0, frame.size.width, frame.size.height - [self toolbarHeight]);
}


//+ (CGRect) appCurrentFrame
//{
//    CGSize size = [self screenSizeWithOrientation:[UIApplication sharedApplication].statusBarOrientation];
//    
//}

///////////////////////////////////////////////////////////////////////////////////////////////////
+(CGRect) toolbarNavigationFrame {
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    return CGRectMake(0, 0, frame.size.width, frame.size.height - [self toolbarHeight]*2);
}

+ (CGSize)toolbarSizeForOrientation:(UIInterfaceOrientation)o
{
    if ([LJXSystem isiPad]) {
        return CGSizeMake([self screenSizeWithOrientation:o].width, 44.0f);
    }else {
        if (UIInterfaceOrientationIsPortrait(o)) {
            return CGSizeMake([self screenSizeWithOrientation:o].width, kDefaultPortraitToolbarHeight);
        }
        else {
            return CGSizeMake([self screenSizeWithOrientation:o].width, kDefaultLandscapeToolbarHeight);
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
//+(CGRect) keyboardNavigationFrame {
//    return RectContract([self appFrame], 0, [self keyboardHeight]);
//}


///////////////////////////////////////////////////////////////////////////////////////////////////
+(CGFloat) statusHeight {
    UIInterfaceOrientation orientation = [self interfaceOrientation];
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        return [UIScreen mainScreen].applicationFrame.origin.x;
        
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        return -[UIScreen mainScreen].applicationFrame.origin.x;
        
    } else {
        return [UIScreen mainScreen].applicationFrame.origin.y;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
+(CGFloat) barsHeight {
    CGRect frame = [UIApplication sharedApplication].statusBarFrame;
    if ([self interfaceOrientation]) {
        return frame.size.height + _ROW_HEIGHT;
    } else {
        return frame.size.width + _LANDSCAPE_TOOLBAR_HEIGHT;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
+(CGFloat) toolbarHeight {
    if ([self interfaceOrientationIsPortrait] || [LJXSystem isiPad]) {
        return _ROW_HEIGHT;
    } else {
        return _LANDSCAPE_TOOLBAR_HEIGHT;
    }
}



@end
