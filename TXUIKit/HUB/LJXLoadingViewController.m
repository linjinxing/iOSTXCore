//
//  LJXLoadingView.m
//  iMoveHomeServer
//
//  Created by LoveYouForever on 11/13/14.
//  Copyright (c) 2014 i-Move. All rights reserved.
//
//
#import "LJXLoadingViewController.h"

@implementation UIViewController (MBHud)

-(MBProgressHUD *)showHudWithStr:(NSString *)str
{
//    LJXPerformBlockAsynOnMainThread(^{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:window];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = str;
        [window addSubview:hud];
        [hud show:YES];
        return hud;
//    });
}

-(void)showHUDAndHidWithStr:(NSString *)str
{
    LJXPerformBlockAsynOnMainThread(^{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        MBProgressHUD *hud = [[MBProgressHUD alloc] init];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = str;
        [window addSubview:hud];
        [hud show:YES];
        [hud hide:YES afterDelay:1.5f];
//        return hud;
    });
}

-(void)showErrorHUD:(NSError*)error
{
	 [self showHUDAndHidWithStr:[error localizedDescription]];
}

-(void)showSuccessHUD:(NSString*)msg
{
	 [self showHUDAndHidWithStr:msg];
}

-(MBProgressHUD *)showHUDProgress{
	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithWindow:window];
	hud.mode = MBProgressHUDModeIndeterminate;
	[window addSubview:hud];
	[hud show:YES];
	return hud;
}

-(void)hidHUDProgress
{
	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	[MBProgressHUD hideAllHUDsForView:window animated:NO];
}

-(MBProgressHUD *)showHUDWithStr:(NSString *)str andHideAfterDelay:(NSTimeInterval)time didDismiss:(void(^)())didDismiss
{
	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	MBProgressHUD *hud = [[MBProgressHUD alloc] init];
	hud.mode = MBProgressHUDModeText;
	hud.labelText = str;
	[window addSubview:hud];
	[hud show:YES];
	LJXPerformBlockOnMainThreadAfterDelay(time, ^{
		[hud hide:YES];
		if (didDismiss) {
			didDismiss();
		}
	});
	return hud;
}

-(MBProgressHUD *)showSuccessHUD:(NSString*)msg andHideAfterDelay:(NSTimeInterval)time didDismiss:(void(^)())didDismiss
{
	return [self showHUDWithStr:msg andHideAfterDelay:1.5 didDismiss:didDismiss];
}

@end
