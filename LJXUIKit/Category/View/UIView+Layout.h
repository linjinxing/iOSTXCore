//
//  UIView+Layout.h
//  QvodUI
//
//  Created by steven on 3/7/13.
//  Copyright (c) 2013 steven. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView (Layout)

/**
 * Shortcut for frame.origin.x.
 *
 * Sets frame.origin.x = left
 */
@property (nonatomic) CGFloat left;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = top
 */
@property (nonatomic) CGFloat top;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = right - frame.size.width
 */
@property (nonatomic) CGFloat right;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = bottom - frame.size.height
 */
@property (nonatomic) CGFloat bottom;

/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = width
 */
@property (nonatomic) CGFloat width;

/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = height
 */
@property (nonatomic) CGFloat height;

/**
 * Shortcut for center.x
 *
 * Sets center.x = centerX
 */
@property (nonatomic) CGFloat centerX;

/**
 * Shortcut for center.y
 *
 * Sets center.y = centerY
 */
@property (nonatomic) CGFloat centerY;

/**
 * Return the x coordinate on the screen.
 */
@property (nonatomic, readonly) CGFloat ttScreenX;

/**
 * Return the y coordinate on the screen.
 */
@property (nonatomic, readonly) CGFloat ttScreenY;

/**
 * Return the x coordinate on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGFloat screenViewX;

/**
 * Return the y coordinate on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGFloat screenViewY;

/**
 * Return the view frame on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGRect screenFrame;

/**
 * Shortcut for frame.origin
 */
@property (nonatomic) CGPoint origin;

/**
 * Shortcut for frame.size
 */
@property (nonatomic) CGSize size;

//- (void)scaleSize:(CGFloat)ratio;

/**
 * Return the width in portrait or the height in landscape.
 */
@property (nonatomic, readonly) CGFloat orientationWidth;

/**
 * Return the height in portrait or the width in landscape.
 */
@property (nonatomic, readonly) CGFloat orientationHeight;



- (CGFloat)heightForSubviewsFromIndex:(NSInteger)aFromIndex toIndex:(NSInteger)aToIndex;

- (CGFloat)widthForSubviewsFromIndex:(NSInteger)aFromIndex toIndex:(NSInteger)aToIndex;


/**
 * Calculates the offset of this view from another view in screen coordinates.
 *
 * otherView should be a parent view of this view.
 */
- (CGPoint)offsetFromView:(UIView*)otherView;

- (CGFloat)maxOfHeighInSubviews;
- (CGFloat)maxOfWidthInSubviews;

/* 计算子视图之间的水平等间距 */
- (CGFloat)spaceOfXForSubviews:(NSArray*)subviews;

- (CGFloat)spaceOfXForSubviewsWithZeroEdgeLayout:(NSArray*)subviews;

/* 计算子视图之间的竖直等间距 */
- (CGFloat)spaceOfYForSubviews:(NSArray*)subviews;
/**
 * Calculates the frame of this view with parts that intersect with the keyboard subtracted.
 *
 * If the keyboard is not showing, this will simply return the normal frame.
 */
- (CGRect)frameWithKeyboardSubtracted:(CGFloat)plusHeight;

/* 
 UIInterfaceOrientationPortrait 从上往下排列
UIInterfaceOrientationPortraitUpsideDown  从下往上排列
UIInterfaceOrientationLandscapeLeft  从左往右排列 
 UIInterfaceOrientationLandscapeRight  从右往左排列 
 */
- (void)layoutSubviews:(NSArray*)subviews withOrientaion:(UIInterfaceOrientation)orientation;

- (void)layoutSubviewsWrap:(NSArray*)subviews withOrientaion:(UIInterfaceOrientation)orientation;

- (void)layoutSubviews:(NSArray*)subviews withOrientaion:(UIInterfaceOrientation)orientation inFrame:(CGRect)frame;

- (void)layoutSubviewsWithOrientaion:(UIInterfaceOrientation)orientation inFrame:(CGRect)frame;

- (void)layoutSubviews:(NSArray*)subviews withOrientaion:(UIInterfaceOrientation)orientation wrap:(BOOL)wrap inFrame:(CGRect)frame;

typedef NS_ENUM(NSInteger, LJXiewLayoutAlignment)
{
    LJXiewLayoutAlignmentVerticalCenter = 1,
    LJXiewLayoutAlignmentHorizontalCenter = 1 << 1,
    LJXiewLayoutAlignmentCenter = LJXiewLayoutAlignmentVerticalCenter | LJXiewLayoutAlignmentHorizontalCenter,
    LJXiewLayoutAlignmentDefault = LJXiewLayoutAlignmentCenter,
    LJXiewLayoutAlignmentLeft = 1 << 2,
    LJXiewLayoutAlignmentRight = 1 << 3,
    LJXiewLayoutAlignmentTop = 1 << 4,
    LJXiewLayoutAlignmentBottom = 1 << 5,
};

- (void)layoutSubviews:(NSArray*)subviews withOrientaion:(UIInterfaceOrientation)orientation alignment:(LJXiewLayoutAlignment)alignment;

/*自动排列子视图:
 UIInterfaceOrientationPortrait 从上往下排列
 UIInterfaceOrientationPortraitUpsideDown  从下往上排列
 UIInterfaceOrientationLandscapeLeft  从左往右排列
 UIInterfaceOrientationLandscapeRight  从右往左排列
 
 autoresizing 是否自动调整，自动调整时，会根据子视图中最高的进行调整，目前支持UIViewAutoresizingFlexibleWidth和UIViewAutoresizingFlexibleHeight。
 space：自动调整时，视图之间的距离
 */

- (void)layoutSubviewsWithOrientaion:(UIInterfaceOrientation)orientation;

- (void)layoutSubviewsWithOrientaion:(UIInterfaceOrientation)orientation wrap:(BOOL)wrap;

//- (void)layoutSubviews:(NSArray*)subviews withOrientaion:(UIInterfaceOrientation)orientation autoResize:(UIViewAutoresizing)autoresizing space:(CGFloat)space;

/* 传入一个数组，数组中还存放着子数组，子数组中存放着view，按照子数组一行一行layout*/
- (void)layoutCollectionSubviews:(NSArray*)collection;
- (void)layoutCollectionSubviews:(NSArray*)collection inFrame:(CGRect)aFrame;

/* 靠着边缘的距离都为0 */
- (void)layoutSubviewsWithZeroEdge:(NSArray*)subviews withOrientaion:(UIInterfaceOrientation)orientation inFrame:(CGRect)frame;

- (void)layoutSubviewsWithZeroEdgeAndOrientaion:(UIInterfaceOrientation)orientation;

- (void)layoutCollectionSubviewsWithZeroEdge:(NSArray*)collection;
@end


