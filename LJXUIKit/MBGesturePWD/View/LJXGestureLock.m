//
//  LJXGestureLock.m
//  MoboWallet
//
//  Created by mobao_ios on 15/4/23.
//  Copyright (c) 2015年 mobo. All rights reserved.
//

#import "LJXGestureLock.h"
#import "LJXGesturePasswordViewController.h"

@implementation LJXGestureLock
+(void)verificationGesturePassword {
    if ([LJXLockPassword isNeedVerificationLockPassword]) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LJXSetGesturePwd" bundle:nil];
        LJXGesturePasswordViewController *controller = [sb instantiateViewControllerWithIdentifier:@"LJXGesturePasswordViewController"];
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        if (!keyWindow) {
            return;
        }
        if(keyWindow.rootViewController.presentingViewController == nil){
            controller.lockType = LJXLockViewTypeCheck;
            controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [keyWindow.rootViewController presentViewController:controller animated:NO completion:^{
            }];
        }

    }
}
@end
