//
//  UIView+Subviews.h
//  QvodUI
//
//  Created by steven on 3/8/13.
//  Copyright (c) 2013 steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Subviews)

- (NSDictionary*)subviewsWithKeyPaths:(id) firstKeyPath,  ... NS_REQUIRES_NIL_TERMINATION;

- (void)removeSubviewClass:(Class) aClass;
- (NSArray*)subviewsWithClass:(Class) aClass;
- (void)removeAllSubviews;
- (void)addSubviewsFromArray:(NSArray*)aSubviews;
- (void)addSubviews:(UIView*)firstView, ... NS_REQUIRES_NIL_TERMINATION;

- (void)addSubviewIfNeed:(UIView*)view;

- (void)setSubviewsTransform:(CGAffineTransform)transform;
@end
