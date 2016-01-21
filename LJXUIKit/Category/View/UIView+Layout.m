//
//  UIView+Layout.m
//  QvodUI
//
//  Created by steven on 3/7/13.
//  Copyright (c) 2013 steven. All rights reserved.
//

#import "UIView+Layout.h"
#import "NSArray+UI.h"
#import "LJXDebug.h"

@implementation UIView (Layout)

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)left {
    return self.frame.origin.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)top {
    return self.frame.origin.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerX {
    return self.center.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerY {
    return self.center.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)width {
    return self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)height {
    return self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ttScreenX {
    CGFloat x = 0;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left;
    }
    return x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ttScreenY {
    CGFloat y = 0;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top;
    }
    return y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)screenViewX {
    CGFloat x = 0;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            x -= scrollView.contentOffset.x;
        }
    }
    
    return x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)screenViewY {
    CGFloat y = 0;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            y -= scrollView.contentOffset.y;
        }
    }
    return y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGRect)screenFrame {
    return CGRectMake(self.screenViewX, self.screenViewY, self.width, self.height);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)origin {
    return self.frame.origin;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize)size {
    return self.frame.size;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}


- (CGFloat)heightForSubviewsFromIndex:(NSInteger)aFromIndex toIndex:(NSInteger)aToIndex
{
    CGFloat height = .0f;
    for (int i = aFromIndex; i <= aToIndex && i < [self.subviews count]; ++i) {
        UIView* view = [self.subviews objectAtIndex:i];
        height += view.height;
        //        LJXUILog(DM_VIEW, "width:%f, view.width:%f\n", width, view.width);
    }
    return height;
}



- (CGFloat)widthForSubviewsFromIndex:(NSInteger)aFromIndex toIndex:(NSInteger)aToIndex
{
    CGFloat width = .0f;
    for (int i = aFromIndex; i <= aToIndex && i < [self.subviews count]; ++i) {
        UIView* view = [self.subviews objectAtIndex:i];
        width += view.width;
        //        LJXUILog(DM_VIEW, "width:%f, view.width:%f\n", width, view.width);
    }
    return width;
}

- (CGPoint)offsetFromView:(UIView*)otherView {
    CGFloat x = 0, y = 0;
    for (UIView* view = self; view && view != otherView; view = view.superview) {
        x += view.left;
        y += view.top;
    }
    return CGPointMake(x, y);
}

- (CGFloat)maxOfHeighInSubviews
{
    CGFloat height = .0f;
    for (UIView* view in self.subviews) {
        if (view.height > height) {
            height = view.height;
        }
    }
    return height;
}

- (CGFloat)maxOfWidthInSubviews
{
    CGFloat width = .0f;
    for (UIView* view in self.subviews) {
        if (view.width > width) {
            width = view.width;
        }
    }
    return width;
}


- (CGFloat)spaceOfXForSubviews:(NSArray*)subviews inFrame:(CGRect)frame
{
    return (frame.size.width - [subviews totalWidthOfNoneHiddenViews]) / ([subviews numOfNoHiddenView] + 1);
}

- (CGFloat)spaceOfYForSubviews:(NSArray*)subviews  inFrame:(CGRect)frame
{
    return (frame.size.height - [subviews totalHeightOfNoneHiddenViews]) / ([subviews numOfNoHiddenView] + 1);
}

- (CGFloat)spaceOfXForSubviews:(NSArray*)subviews
{
    return [self spaceOfXForSubviews:subviews inFrame:self.frame];
}

- (CGFloat)spaceOfXForSubviewsWithZeroEdgeLayout:(NSArray*)subviews
{
    if (1 >= [subviews numOfNoHiddenView]) {
        return .0f;
    }
    return (self.frame.size.width - [subviews totalWidthOfNoneHiddenViews]) / ([subviews numOfNoHiddenView] - 1);
}

- (void)layoutSubviews:(NSArray*)subviews withOrientaion:(UIInterfaceOrientation)orientation wrap:(BOOL)wrap inFrame:(CGRect)frame
{
    BOOL isPortrait = UIInterfaceOrientationIsPortrait(orientation);    
    CGFloat spaceX = [self spaceOfXForSubviews:subviews inFrame:frame];
    CGFloat spaceY = [self spaceOfYForSubviews:subviews inFrame:frame];
    if (spaceX < 0)  spaceX = .0;
    if (spaceY < 0)  spaceY = .0;
    __block CGPoint origin = frame.origin;
    __block CGFloat max = .0f;

    if (isPortrait) {
        origin.y += spaceY;
    }else{
        origin.x += spaceX;
    }
    
    void (^layoutSubviewWithIndex)(int) = ^(int idx){
        UIView* view = [subviews objectAtIndex:idx];
        if ([view isKindOfClass:[UIView class]]) {
            if (view.height < 0.0001 || view.hidden) {
                return ;
            }
            CGPoint originBackup = origin;
            if (!wrap) {
                /* 居中 */
                if (isPortrait) {
                    origin.x += (frame.size.width - view.width) / 2; /* 所有view x坐标剧中 */
                    if (origin.x < 0) {
                        origin.x = 0;
                    }
                }else {
                    origin.y += (frame.size.height - view.height) / 2; /* 所有view y坐标剧中 */
                    if (origin.y < 0) {
                        origin.y = 0;
                    }
                }
            }
           view.origin = origin;
            origin = originBackup;
            /* 移动到下一个坐标 */
            UIView* nextView = (idx + 1 < [subviews count] ? [subviews objectAtIndex:idx + 1] : nil);
            if (isPortrait) {
                origin.y += (spaceY + view.height);
                if (wrap) {
                    /* 如果竖直layout， 记录下最大的宽度 */
                    if (view.width > max) {
                        max = view.width;
                    }
                    /* 检测是否到了边界，则换行 */
                    if (origin.y + nextView.width + spaceY > frame.origin.y + frame.size.height) {
                        origin.y = frame.origin.y + spaceY;
                        origin.x = origin.x + max + spaceX;
                    }
                }
            }
            else {
                origin.x += (spaceX + view.width);
                if (wrap) {
                    if (view.height > max) {
                        max = view.height;
                    }
                    if (origin.x + nextView.height + spaceX > frame.origin.x + frame.size.width) {
                        origin.x = frame.origin.x + spaceX;
                        origin.y = origin.y + max + spaceY;
                    }
                }
            }
        }
    };
    
    int i = 0;    
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationLandscapeLeft:            
        {
            for (i = 0; i < [subviews count]; ++i) {
                layoutSubviewWithIndex(i);
            }
            break;
        }
        case UIInterfaceOrientationPortraitUpsideDown:
        case UIInterfaceOrientationLandscapeRight:            
        {
            for (i = [subviews count] - 1; i >= 0; --i) {
                layoutSubviewWithIndex(i);
            }
            break;
        }
        default:
            LJXError("unknow orietaion:%d", orientation);
            break;
    }
}

- (void)layoutSubviewsWrap:(NSArray*)subviews withOrientaion:(UIInterfaceOrientation)orientation inFrame:(CGRect)frame
{
    [self layoutSubviews:subviews withOrientaion:orientation wrap:NO inFrame:frame];
}

- (void)layoutSubviewsWrap:(NSArray*)subviews withOrientaion:(UIInterfaceOrientation)orientation
{
    [self layoutSubviews:subviews withOrientaion:orientation wrap:YES inFrame:self.bounds];
}

- (void)layoutSubviews:(NSArray*)subviews withOrientaion:(UIInterfaceOrientation)orientation
{
    [self layoutSubviews:subviews withOrientaion:orientation wrap:NO inFrame:self.bounds];
}

- (void)layoutSubviews:(NSArray*)subviews withOrientaion:(UIInterfaceOrientation)orientation inFrame:(CGRect)frame
{
    [self layoutSubviews:subviews withOrientaion:orientation wrap:NO inFrame:frame];    
}

- (void)layoutSubviewsWithOrientaion:(UIInterfaceOrientation)orientation inFrame:(CGRect)frame
{
    [self layoutSubviews:self.subviews withOrientaion:orientation wrap:NO inFrame:frame];
}

- (void)layoutSubviewsWithOrientaion:(UIInterfaceOrientation)orientation
{
    [self layoutSubviews:self.subviews withOrientaion:orientation];
}

- (void)layoutSubviewsWithOrientaion:(UIInterfaceOrientation)orientation wrap:(BOOL)wrap
{
    [self layoutSubviews:self.subviews withOrientaion:orientation wrap:wrap inFrame:self.bounds];
}

//- (CGFloat)spaceOfXForCollectionSubviews:(NSArray*)subviews
//{
//    return (self.width - [subviews totalWidthOfNoneHiddenCollectionViews]) / ([subviews numOfNoHiddenView] + 1);
//}

/* 竖起坐标之间的间隔 */
- (CGFloat)spaceOfYForCollectionSubviews:(NSArray*)subviews
{
    return (self.height - [subviews totalHeightOfNoneHiddenCollectionViews]) / ([subviews count] + 1);
}

- (CGFloat)spaceOfYForCollectionSubviews:(NSArray*)subviews inFrame:(CGRect)frame
{
    return (frame.size.height - [subviews totalHeightOfNoneHiddenCollectionViews]) / ([subviews count] + 1);
}

- (void)layoutCollectionSubviews:(NSArray*)collection inFrame:(CGRect)aFrame
{
    @try {
        CGFloat spaceY = [self spaceOfYForCollectionSubviews:collection inFrame:aFrame];
        
//        CGFloat offsetY = frame.origin.y;

        CGRect frame = CGRectMake(aFrame.origin.x, aFrame.origin.y, aFrame.size.width, 0.0f);
        
        for (NSArray* array in collection) {
            CGFloat max = [array maxHeightOfNoneHiddenViews];
            frame.size.height = max + spaceY * 2;
            [self layoutSubviews:array withOrientaion:UIInterfaceOrientationLandscapeLeft inFrame:frame];
            frame.origin.y += (max + spaceY);
        }
    }
    @catch (NSException *exception) {
        LJXNSExceptionError(exception);
    }
}

- (void)layoutCollectionSubviews:(NSArray*)collection
{
    [self layoutCollectionSubviews:collection inFrame:self.bounds];
}


- (CGFloat)spaceOfXForSubviewsWithZeroEdge:(NSArray*)subviews inFrame:(CGRect)frame
{
    NSUInteger count = [subviews numOfNoHiddenView];
    if (count  > 1) {
        return (frame.size.width - [subviews totalWidthOfNoneHiddenViews]) / (count - 1);
    }else{
        return ((self.width - [(UIView *)[subviews lastObject] width])/2);
    }
}

- (CGFloat)spaceOfYForSubviewsWithZeroEdge:(NSArray*)subviews  inFrame:(CGRect)frame
{
    NSUInteger count = [subviews numOfNoHiddenView];
    if (count  > 1) {
        return (frame.size.height - [subviews totalHeightOfNoneHiddenViews]) / ([subviews numOfNoHiddenView] - 1);
    }else{
        return ((self.height - [(UIView *)[subviews lastObject] height])/2);
    }
}


- (void)layoutSubviewsWithZeroEdge:(NSArray*)subviews withOrientaion:(UIInterfaceOrientation)orientation inFrame:(CGRect)frame
{
    BOOL isPortrait = UIInterfaceOrientationIsPortrait(orientation);
    CGFloat spaceX = [self spaceOfXForSubviewsWithZeroEdge:subviews inFrame:frame];
    CGFloat spaceY = [self spaceOfYForSubviewsWithZeroEdge:subviews inFrame:frame];
    if (spaceX < 0)  spaceX = .0;
    if (spaceY < 0)  spaceY = .0;
    __block CGPoint origin = frame.origin;
    
    void (^layoutSubviewWithIndex)(int) = ^(int idx){
        UIView* view = [subviews objectAtIndex:idx];
        if ([view isKindOfClass:[UIView class]]) {
            if (view.height < 0.0001 || view.hidden) {
                return ;
            }
            CGPoint originBackup = origin;
            /* 居中 */
            if (isPortrait) {
                origin.x += (frame.size.width - view.width)/2;
                if (origin.x < 0) {
                    origin.x = 0;
                }
            }else {
                origin.y += (frame.size.height - view.height) / 2;
                if (origin.y < 0) {
                    origin.y = 0;
                }
            }
            view.origin = origin;
            origin = originBackup;
            /* 移动到下一个坐标 */
            if (isPortrait) {
                origin.y += (spaceY + view.height);
            }
            else {
                origin.x += (spaceX + view.width);
            }
        }
    };
    
    int i = 0;
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationLandscapeLeft:
        {
            for (i = 0; i < [subviews count]; ++i) {
                layoutSubviewWithIndex(i);
            }
            break;
        }
        case UIInterfaceOrientationPortraitUpsideDown:
        case UIInterfaceOrientationLandscapeRight:
        {
            for (i = [subviews count] - 1; i >= 0; --i) {
                layoutSubviewWithIndex(i);
            }
            break;
        }
        default:
            LJXError("unknow orietaion:%d", orientation);
            break;
    }
}

- (void)layoutSubviewsWithZeroEdgeAndOrientaion:(UIInterfaceOrientation)orientation
{
    [self layoutSubviewsWithZeroEdge:self.subviews withOrientaion:orientation inFrame:self.bounds];
}

- (CGFloat)spaceOfYForCollectionSubviewsWithZeroEdge:(NSArray*)subviews inFrame:(CGRect)frame
{
    return (frame.size.height - [subviews totalHeightOfNoneHiddenCollectionViews]) / ([subviews count] - 1);
}

- (void)layoutCollectionSubviewsWithZeroEdge:(NSArray*)collection inFrame:(CGRect)aFrame
{
    @try {
        CGFloat spaceY = [self spaceOfYForCollectionSubviewsWithZeroEdge:collection inFrame:aFrame];
        
        //        CGFloat offsetY = frame.origin.y;
        
        CGRect frame = CGRectMake(aFrame.origin.x, aFrame.origin.y, aFrame.size.width, 0.0f);
        
        for (NSArray* array in collection) {
            CGFloat max = [array maxHeightOfNoneHiddenViews];
            frame.size.height = max;
            [self layoutSubviewsWithZeroEdge:array withOrientaion:UIInterfaceOrientationLandscapeLeft inFrame:frame];
            frame.origin.y += (max + spaceY);
        }
    }
    @catch (NSException *exception) {
        LJXNSExceptionError(exception);
    }
}

- (void)layoutCollectionSubviewsWithZeroEdge:(NSArray*)collection
{
    [self layoutCollectionSubviewsWithZeroEdge:collection inFrame:self.bounds];
}


- (void)layoutSubviews:(NSArray*)subviews withOrientaion:(UIInterfaceOrientation)orientation alignment:(LJXiewLayoutAlignment)alignment
{
    CGFloat totalHeight = [subviews totalHeightOfViews];
    
}
@end



