//
//  NSObject+UI.m
//  QvodUI
//
//  Created by steven on 7/27/13.
//  Copyright (c) 2013 steven. All rights reserved.
//

#import "UIResponderAdditions.h"
#import "UIViewController+Addition.h"
#import "UIViewAdditions.h"

UIViewController* LJXUIGetTopViewController()
{
    UIViewController* (^topvcForWindow)(UIWindow*win) = ^(UIWindow*window){
        UIViewController* vc = [window rootViewController];
//        LJXUILog("window:%@, [window subviews]:%@, vc:%@", window, [window subviews], vc);
        if (nil == vc) {
            vc =  [[[window subviews] lastObject] viewController];
        }
        UIViewController* topVC = vc.presentedTopViewController;
        return (topVC ? topVC : vc);
    };
    
    BOOL bDelegateWin = NO;
    UIWindow* win = [UIApplication sharedApplication].keyWindow;
//    LJXUILog("win:%@", win);
    if (nil == win){
        bDelegateWin = YES;
        win = [[UIApplication sharedApplication].delegate window];
    }
    
    UIViewController* topvc = topvcForWindow(win);
    if (nil == topvc && !bDelegateWin) {
        win = [[UIApplication sharedApplication].delegate window];
    }
    topvc = topvcForWindow(win);
    return topvc;
}



