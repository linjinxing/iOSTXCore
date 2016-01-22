//
//  LJXLoadingView.h
//  iMoveHomeServer
//
//  Created by LoveYouForever on 11/13/14.
//  Copyright (c) 2014 i-Move. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJXMBProgressHUD.h"

//
//@interface LJXLoadingViewController : UIViewController
//
//+ (void)showWithMessage:(NSString*)msg;
//+ (void)show;
//+ (void)showSaving;
//+ (void)dismiss;
//+ (void)showWithError:(NSString *)errorNote;
//+ (void)showWithSuccess:(NSString *)successNote;
//
//@end
//
//
//#define LJXLoadingViewShowErrorIfNeed(error) do{ \
//                                    if (error) [LJXUIGetTopViewController() im_displaySuccessString:[error isKindOfClass:[NSString class]] ? (NSString*)error : [error localizedDescription]]; \
//                                    }while(0)
//
//#define LJXLoadingViewShowSaving  do{ \
//                                    [LJXLoadingViewController showSaving]; \
//                                    }while(0)
//
//#define LJXLoadingViewShow do{ \
//                             [LJXLoadingViewController show]; \
//                            }while(0)
//
//#define LJXLoadingViewDismiss do{ \
//                                 [LJXLoadingViewController dismiss]; \
//                                }while(0)
//
//
//#define LJXLoadingViewShowMessage(msg) do{ \
//                                             [LJXLoadingViewController showWithMessage:msg]; \
//                                            }while(0)
//
//#define LJXLoadingViewShowError(msg) do{ \
//                                             [LJXUIGetTopViewController() im_displaySuccessString:msg]; \
//                                            }while(0)
//
//#define LJXLoadingViewShowSuccess(msg) do{ \
//                                            [LJXUIGetTopViewController() im_displaySuccessString:msg]; \
//                                            }while(0)
//
//#define LJXLoadingViewShowDeleteMessage LJXLoadingViewShowMessage(@"删除中...")
//
//#define LJXLoadingViewShowSuccessDelete LJXLoadingViewShowError(@"删除成功")
//#define LJXLoadingViewShowErrorDelete   LJXLoadingViewShowSuccess(@"删除失败")
//
//#define LJXLoadingViewShowSuccessModify LJXLoadingViewShowSuccess(@"修改成功")


@interface UIViewController (MBHud)

//显示提示文字
-(LJXMBProgressHUD *)showHudWithStr:(NSString *)str;
//显示提示文字并1.5秒后隐藏
-(LJXMBProgressHUD *)showHUDAndHidWithStr:(NSString *)str;
//显示菊花
-(LJXMBProgressHUD *)showHUDProgress;
//隐藏菊花和提示文字等
-(void)hidHUDProgress;

-(LJXMBProgressHUD *)showHUDWithStr:(NSString *)str andHideAfterDelay:(NSTimeInterval)time didDismiss:(void(^)())didDismiss;

-(LJXMBProgressHUD *)showErrorHUD:(NSError*)error;
-(LJXMBProgressHUD *)showSuccessHUD:(NSString*)msg;

-(LJXMBProgressHUD *)showSuccessHUD:(NSString*)msg andHideAfterDelay:(NSTimeInterval)time didDismiss:(void(^)())didDismiss;
@end



