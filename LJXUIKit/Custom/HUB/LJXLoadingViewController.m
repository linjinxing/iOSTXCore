//
//  LJXLoadingView.m
//  iMoveHomeServer
//
//  Created by LoveYouForever on 11/13/14.
//  Copyright (c) 2014 i-Move. All rights reserved.
//
//
#import "LJXLoadingViewController.h"
//#import "LJXFoundation.h"
//#import "LJXUIStyle.h"
#import "LJXMBProgressHUD.h"
//
//static LJXLoadingViewController* vc = nil;
//
//@interface LJXLoadingViewController()
//@property(weak, nonatomic) IBOutlet UIImageView* imageView;
//@property(weak, nonatomic) IBOutlet UILabel* lableMsg;
//@property(assign, nonatomic) BOOL animating;
//@property(strong, nonatomic) UIWindow* window;
//@end
//
//@implementation LJXLoadingViewController
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [self startSpin];
//}
//
////- (void)viewWillDisappear:(BOOL)animated
////{
////    [super viewWillDisappear:animated];
////    [self stopSpin];
////}
//
//- (void) spinWithOptions: (UIViewAnimationOptions) options {
//    [UIView animateWithDuration: 0.2f
//                          delay: 0.0f
//                        options: options
//                     animations: ^{
//                         self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, M_PI / 2);
//                     }
//                     completion: ^(BOOL finished) {
//                         if (finished) {
//                             if (self.animating) {
//                                 // if flag still set, keep spinning with constant speed
//                                 [self spinWithOptions: UIViewAnimationOptionCurveLinear];
//                             } else if (options != UIViewAnimationOptionCurveEaseOut) {
//                                 // one last spin, with deceleration
//                                 [self spinWithOptions: UIViewAnimationOptionCurveEaseOut];
//                             }
//                         }
//                     }];
//}
//
//- (void) startSpin {
//    if (!self.animating) {
//        self.animating = YES;
//        [self spinWithOptions: UIViewAnimationOptionCurveEaseIn];
//    }
//}
//
//- (void) stopSpin {
//    // set the flag to stop spinning after one last 90 degree increment
//    self.animating = NO;
////    self.view.layer.cornerRadius
//}
//
//+ (void)showWithMessage:(NSString*)msg
//{
//    [self dismiss];
//    LJXProgressHUD* hud = [LJXProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
//    [hud showText:msg];
////    [SVProgressHUD showWithStatus:msg];
//    /*
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"LJXUI" bundle:nil];
//        vc = [sb instantiateViewControllerWithIdentifier:@"LJXLoadingViewController"];
//        vc.view.backgroundColor = LJXUIStyleMaskingBackgroundColor();
//        vc.modalPresentationStyle = LJXIsiOS8Later ? UIModalPresentationOverCurrentContext : UIModalPresentationCurrentContext;
//    });
//    
//    UIWindow *win = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    win.windowLevel = UIWindowLevelStatusBar;
//    win.hidden = NO;
//    win.rootViewController = vc;
//    [win makeKeyAndVisible];
//    
//    vc.window = win;
////    vc.view.backgroundColor = [UIColor orangeColor];
//    vc.lableMsg.text = msg;
//*/
////    [nav presentViewController:vc animated:NO completion:nil];
//}
//
//+ (void)showSaving
//{
//    [self dismiss];
//    LJXProgressHUD* hud = [LJXProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
//    [hud showText:@"保存中..."];
//}
//
//+ (void)show
//{
//    [self dismiss];
//    LJXProgressHUD* hud = [LJXProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
//    [hud showText:@"加载中..."];
////    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
////    [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeBlack];
////    [self showWithMessage:@"正在加载..."];
//}
////
////+ (void)showLoading
////{
////    [self showWithMessage:@""];
////}
//
//+ (void)showWithError:(NSString *)errorNote
//{
//    [self dismiss];    
//    [SVProgressHUD showErrorWithStatus:errorNote];
////    [SVProgressHUD dismiss];
////    [[UIApplication sharedApplication].keyWindow makeToast:errorNote duration:1.5 position:CSToastPositionCenter];
//}
//
//+ (void)showWithSuccess:(NSString *)successNote
//{
//    [SVProgressHUD showSuccessWithStatus:successNote];
//}
//
//+ (void)dismiss
//{
//    [SVProgressHUD dismiss];
//    [LJXProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication].delegate window] animated:NO];
//    return;
//    /*
//    [vc stopSpin];
//    [vc.window resignKeyWindow];
//    vc.window = nil;
//    [[[[UIApplication sharedApplication] delegate] window] makeKeyAndVisible];
//     */
////    vc.window = nil;
////    [vc dismissViewControllerAnimated:NO completion:nil];
//}
//
//@end
//
//
//
@implementation UIViewController (MBHud)

-(LJXMBProgressHUD *)showHudWithStr:(NSString *)str
{
	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	LJXMBProgressHUD *hud = [[LJXMBProgressHUD alloc] initWithView:window];
	hud.mode = MBProgressHUDModeText;
	hud.labelText = str;
	[window addSubview:hud];
	[hud show:YES];
	return hud;
}

-(LJXMBProgressHUD *)showHUDAndHidWithStr:(NSString *)str
{
	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	LJXMBProgressHUD *hud = [[LJXMBProgressHUD alloc] init];
	hud.mode = MBProgressHUDModeText;
	hud.labelText = str;
	[window addSubview:hud];
	[hud show:YES];
	[hud hide:YES afterDelay:1.5f];
	return hud;
}

-(LJXMBProgressHUD *)showErrorHUD:(NSError*)error
{
	return [self showHUDAndHidWithStr:[error localizedDescription]];
}

-(LJXMBProgressHUD *)showSuccessHUD:(NSString*)msg
{
	return [self showHUDAndHidWithStr:msg];
}

-(LJXMBProgressHUD *)showHUDProgress{
	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	LJXMBProgressHUD *hud = [[LJXMBProgressHUD alloc] initWithWindow:window];
	hud.mode = MBProgressHUDModeIndeterminate;
	[window addSubview:hud];
	[hud show:YES];
	return hud;
}

-(void)hidHUDProgress
{
	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	[LJXMBProgressHUD hideAllHUDsForView:window animated:NO];
}

-(LJXMBProgressHUD *)showHUDWithStr:(NSString *)str andHideAfterDelay:(NSTimeInterval)time didDismiss:(void(^)())didDismiss
{
	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	LJXMBProgressHUD *hud = [[LJXMBProgressHUD alloc] init];
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

-(LJXMBProgressHUD *)showSuccessHUD:(NSString*)msg andHideAfterDelay:(NSTimeInterval)time didDismiss:(void(^)())didDismiss
{
	return [self showHUDWithStr:msg andHideAfterDelay:1.5 didDismiss:didDismiss];
}

@end
