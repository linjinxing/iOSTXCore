//
//  UICollectionView+Additions.m
//  iMove
//
//  Created by linjinxing on 8/7/14.
//  Copyright (c) 2014 iMove. All rights reserved.
//

#import "UICollectionView+Additions.h"

@implementation UICollectionView (Additions)
- (void)registerClass:(Class)cellClass
{
    [self registerClass:cellClass forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
}

#if 0

- (CGSize)calculateContentSize
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
            QVError("unknow orietaion:%d", orientation);
            break;
    }
}

#endif

@end
