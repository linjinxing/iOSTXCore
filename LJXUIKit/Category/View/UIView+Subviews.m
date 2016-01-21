//
//  UIView+Subviews.m
//  QvodUI
//
//  Created by steven on 3/8/13.
//  Copyright (c) 2013 steven. All rights reserved.
//

#import "UIView+Subviews.h"


//#import "UIControl+BlocksKit.h"
//#import "LJXiewPropertiesSetting.h"
//#import "LJXControlActionHandler.h"

@implementation UIView (Subviews)
//
//+ (BOOL)IsSytemClass:(Class)cls
//{
//    static NSSet* a = nil;
//    if (nil == a) {
//        a = [NSSet setWithObjects:NSStringFromClass([UIView class]), NSStringFromClass([UILabel class]), NSStringFromClass([UIControl class]), NSStringFromClass([UISlider class]), NSStringFromClass([UIButton class]), NSStringFromClass([UISegmentedControl class]), NSStringFromClass([UIAlertView class]), NSStringFromClass([UIActionSheet class]), NSStringFromClass([UIToolbar class]), NSStringFromClass([UINavigationBar class]),
//             NSStringFromClass([UIPickerView class]), NSStringFromClass([UIWebView class]), NSStringFromClass([UIActivityIndicatorView class]), NSStringFromClass([UIDatePicker class]), NSStringFromClass([UIImageView class]), NSStringFromClass([UIProgressView class]), NSStringFromClass([UIScrollView class]),
//             NSStringFromClass([UITabBar class]), NSStringFromClass([UISwitch class]), NSStringFromClass([UITableView class]), NSStringFromClass([UITextField class]), NSStringFromClass([UITextView class]), NSStringFromClass([UISearchBar class]), NSStringFromClass([UICollectionView class]),
//             nil];
//    }
//    return [a containsObject:NSStringFromClass(cls)];
//}

//- (NSDictionary*)subviewsWithKeyPaths:(id) firstKeyPath,  ... NS_REQUIRES_NIL_TERMINATION
//{
//    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:20];
//    va_list ap;
//    va_start(ap, firstKeyPath);
//    id obj = firstKeyPath;
//    @try{
//        while (obj) {
//            @try{
//                UIView* view = [self valueForKeyPath:obj];
//                if ([view isKindOfClass:[UIView class]])
//                {
//                    [dict setObject:view forKey:[NSNumber numberWithLong:view.tag]];
////                    LJXUILog("tag:%d, view:%@", view.tag, [view className]);
//                }else{
//                    LJXError("havne't found subview of view:%@, for key path:@", [self className], obj);
//                }
//            }
//            @catch(NSException * e) {
//                LJXNSExceptionError(e);
//            }
//            obj = va_arg(ap, id);
//        }
//    }
//    @catch(NSException * e) {
//        LJXNSExceptionError(e);
//    }
//    @finally{
//        va_end(ap);
//        return dict;
//    }
//    return dict;
//}



///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removeAllSubviews {
    while (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}


- (void)addSubviewsFromArray:(NSArray*)aSubviews
{
    for (int i = 0; i < [aSubviews count]; ++i) {
        UIView* view = [aSubviews objectAtIndex:i];
        if ([view isKindOfClass:[UIView class]]) {
            [self addSubview:view];
        }else{
            LJXError("obj:%@ isn't a view", view);
        }
    }
}

- (void)removeSubviewClass:(Class) aClass
{
    for (UIView* view in self.subviews) {
        if ([view isKindOfClass:aClass]) {
            [view removeFromSuperview];
        }
    }
}

- (NSArray*)subviewsWithClass:(Class) aClass
{
    NSMutableArray* subviews = [NSMutableArray arrayWithCapacity:[self.subviews count]];
    for (UIView* view in self.subviews) {
        if ([view isKindOfClass:aClass]) {
            [subviews addObject:view];
        }
    }
    return subviews;
}

- (void)addSubviews:(UIView*)firstView, ... NS_REQUIRES_NIL_TERMINATION
{
    @try{
        va_list ap;
        va_start(ap, firstView);
        UIView* view = firstView;
        while (view) {
            if ([view isKindOfClass:[UIView class]]) [self addSubview:view];
            view = va_arg(ap, id);
        }
        va_end(ap);
    }
    @catch(NSException * e) {
        LJXNSExceptionError(e);
    }
}

- (void)addSubviewIfNeed:(UIView *)view
{
    if (view)
    {
        if (view.superview && self != view.superview) {
            [view removeFromSuperview];
        }
        [self addSubview:view];
    }
}

- (void)setSubviewsTransform:(CGAffineTransform)transform
{
    for (UIView* view in self.subviews) {
        view.transform = transform;
        if ([view.subviews count]) {
            [self setSubviewsTransform:transform];
        }
    }
}

@end
