//
//  NSArray+UI.h
//  QvodUI
//
//  Created by steven on 3/8/13.
//  Copyright (c) 2013 steven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface NSArray (UI)
- (CGFloat)totalHeightOfViews;
- (CGFloat)totalWidthOfViews;
- (CGFloat)maxHeightOfViews;
- (CGFloat)maxWidthOfViews;
- (CGFloat)minHeightOfViews;
- (CGFloat)minWidthOfViews;

- (CGFloat)maxHeightOfNoneHiddenViews;
- (CGFloat)maxWidthOfNoneHiddenViews;
- (CGFloat)totalWidthOfNoneHiddenViews;
- (CGFloat)totalHeightOfNoneHiddenViews;
- (NSUInteger)numOfNoHiddenView;


- (CGFloat)totalWidthOfNoneHiddenCollectionViews;
- (CGFloat)totalHeightOfNoneHiddenCollectionViews;

- (NSArray*)buttonsWithTitles:(NSArray*)titles;

//- (void)addIMControlAction
@end
