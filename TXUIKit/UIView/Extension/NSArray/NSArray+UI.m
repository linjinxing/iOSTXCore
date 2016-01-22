//
//  NSArray+UI.m
//  QvodUI
//
//  Created by steven on 3/8/13.
//  Copyright (c) 2013 steven. All rights reserved.
//

#import "NSArray+UI.h"
#import <UIKit/UIKit.h>

@implementation NSArray (UI)
- (CGFloat)totalHeightOfViews
{
    CGFloat height = 0;
    @try {
        for (UIView* view in self) {
            height += view.frame.size.height;
        }
    }
    @catch (NSException *exception) {
        LJXNSExceptionError(exception);
    }
    @finally {
        return height;
    }
}
- (CGFloat)totalWidthOfViews
{
    CGFloat width = 0;    
    @try {
        for (UIView* view in self) {
            width += view.frame.size.width;
        }
    }
    @catch (NSException *exception) {
        LJXNSExceptionError(exception);
    }
    @finally {
        return width;
    }
}

- (CGFloat)maxHeightOfViews
{
    CGFloat max = .0f;
    @try {
        for (UIView* view in self) {
            if (view.frame.size.height > max) {
                max = view.frame.size.height;   
            }
        };
    }
    @catch (NSException *exception) {
        LJXNSExceptionError(exception);
    }
    @finally {
        return max;
    }
}

- (CGFloat)maxHeightOfNoneHiddenViews
{
    CGFloat max = .0f;
    @try {
        for (UIView* view in self) {
            if (!view.hidden && view.frame.size.height > max) {
                max = view.frame.size.height;
            }
        };
    }
    @catch (NSException *exception) {
        LJXNSExceptionError(exception);
    }
    @finally {
        return max;
    }
}


- (CGFloat)maxWidthOfViews
{
    CGFloat max = .0f;
    @try {
       for (UIView* view in self) {
            if (view.frame.size.width > max) {
                max = view.frame.size.width;
            }
        };
    }
    @catch (NSException *exception) {
        LJXNSExceptionError(exception);
    }
    @finally {
        return max;
    }
}

- (CGFloat)minHeightOfViews
{
    CGFloat min = .0f;
    @try {
        for (UIView* view in self) {
            if (view.frame.size.height < min) {
                min = view.frame.size.height;
            }
        };
    }
    @catch (NSException *exception) {
        LJXNSExceptionError(exception);
    }
    @finally {
        return min;
    }
}

- (CGFloat)minWidthOfViews
{
    CGFloat min = .0f;
    @try {
        for (UIView* view in self) {
            if (view.frame.size.width < min) {
                min = view.frame.size.width;
            }
        };
    }
    @catch (NSException *exception) {
        LJXNSExceptionError(exception);
    }
    @finally {
        return min;
    }
}

- (CGFloat)maxWidthOfNoneHiddenViews
{
    CGFloat max = .0f;
    @try {
        for (UIView* view in self) {
            if (!view.hidden && view.frame.size.width > max) {
                max = view.frame.size.width;
            }
        };
    }
    @catch (NSException *exception) {
        LJXNSExceptionError(exception);
    }
    @finally {
        return max;
    }
}

- (CGFloat)totalWidthOfNoneHiddenViews
{
    CGFloat width = 0;
    @try {
        for (UIView* view in self) {
            if (!view.hidden) {
                width += view.frame.size.width;
            }
        }
    }
    @catch (NSException *exception) {
        LJXNSExceptionError(exception);
    }
    @finally {
        return width;
    }
}

- (CGFloat)totalHeightOfNoneHiddenViews
{
    CGFloat height = 0;
    @try {
        for (UIView* view in self) {
            if (!view.hidden) {
                height += view.frame.size.height;
            }
        }
    }
    @catch (NSException *exception) {
        LJXNSExceptionError(exception);
    }
    @finally {
        return height;
    }
}

- (CGFloat)totalHeightOfNoneHiddenCollectionViews{
    CGFloat height = 0;
    @try {
        for (NSArray* line in self) {
            CGFloat maxHeight = 0;
            for (UIView* view in line) {
                if (!view.hidden) {
                    if  (view.frame.size.height > maxHeight)
                        maxHeight = view.frame.size.height;
                }
            }
            height += maxHeight;
        }
    }
    @catch (NSException *exception) {
        LJXNSExceptionError(exception);
    }
    @finally {
        return height;
    }
}

- (NSUInteger)numOfNoHiddenView
{
    NSUInteger i = 0;
    @try {
        for (UIView* view in self) {
            if (!view.hidden && view.frame.size.height > 0.0001) i++;
        }
    }
    @catch (NSException *exception) {
        LJXNSExceptionError(exception);
    }
    @finally {
        return i;
    }
}

- (CGFloat)totalWidthOfNoneHiddenCollectionViews
{
    CGFloat width = .0f;    
    @try {
        for (NSArray* array in self) {
            width += [array maxWidthOfNoneHiddenViews];
        }
    }
    @catch (NSException *exception) {
        LJXNSExceptionError(exception);
    }
    @finally {
        return width;
    }
}

- (NSArray*)buttonsWithTitles:(NSArray*)titles
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:[self count]];
    @try {
        for (UIButton* b in self) {
             if ([titles containsObject:b.titleLabel.text])
             {
                 [dict setValue:b forKey:b.titleLabel.text];
             }
        }
    }
    @catch (NSException *exception) {
        LJXNSExceptionError(exception);
    }
    @finally {
        NSMutableArray* a = [NSMutableArray arrayWithCapacity:[dict count]];
        for (NSString* t in titles) {
            [a addObject:[dict valueForKey:t]];
        }
        return a;
    }
}

@end
