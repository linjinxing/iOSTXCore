//
//  UICollectionView+Additions.h
//  iMove
//
//  Created by linjinxing on 8/7/14.
//  Copyright (c) 2014 iMove. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (Additions)
- (void)registerClass:(Class)cellClass;

// 计算大小
- (CGSize)calculateContentSize;
@end
