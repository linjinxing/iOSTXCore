//
//  LJXResouceLayout.h
//  QvodUI
//
//  Created by steven on 11/29/12.
//  Copyright (c) 2012 steven. All rights reserved.
//  

#import <UIKit/UIKit.h>

@interface LJXUISystemMetric : NSObject
/**
 * @return the bounds of the screen with device orientation factored in.
 */
+(CGRect) screenBounds;

+ (CGFloat) naviBarHeightWithOrientation:(UIInterfaceOrientation)o;

+ (CGSize) naviBarSizeWithOrientation:(UIInterfaceOrientation)o;

+ (CGSize)  screenSizeWithOrientation:(UIInterfaceOrientation)o;

+(CGFloat) screenWidth;

+(CGFloat) screenHeight;
/**
 * @return the application frame below the navigation bar.
 */
+(CGRect) appFrame;

//+(CGRect) appCurrentFrame;

/**
 * @return the application frame below the navigation bar and above a toolbar.
 */
+(CGRect) toolbarNavigationFrame;

+ (CGSize)toolbarSizeForOrientation:(UIInterfaceOrientation)o;

/**
 * @return the application frame below the navigation bar and above the keyboard.
 */
//+(CGRect) keyboardNavigationFrame;

/**
 * @return the height of the area containing the status bar and possibly the in-call status bar.
 */

+(CGFloat) defaultCellHeight;

+(CGFloat) statusHeight;

/**
 * @return the height of the area containing the status bar and navigation bar.
 */
+(CGFloat) barsHeight;

/**
 * @return the height of a toolbar considering the current orientation.
 */
+ (CGFloat) toolbarHeight;



@end
