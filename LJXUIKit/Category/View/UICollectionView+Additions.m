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


@end
