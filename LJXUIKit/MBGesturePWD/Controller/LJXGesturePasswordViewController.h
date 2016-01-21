//
//  LJXGesturePasswordViewController.h
//  MoboWallet
//
//  Created by mobao_ios on 15/4/23.
//  Copyright (c) 2015年 mobo. All rights reserved.
//

#import <UIKit/UIKit.h>

// 进入此界面时的不同目的
typedef enum {
	LJXLockViewTypeCheck,  // 检查手势密码
	LJXLockViewTypeCreate, // 创建手势密码
	LJXLockViewTypeModify, // 修改
	LJXLockViewTypeClean,  // 清除
}LJXLockViewType;

enum LJXGesturePasswordErrorCode{
	LJXGesturePasswordErrorCodeSuccess,
	LJXGesturePasswordErrorCodeOverErrorCount /* 输错密码多次 */
};

//手势密码创建验证界面
@interface LJXGesturePasswordViewController : UIViewController
@property (nonatomic, copy) void(^didError)(NSError*error);
//@property (nonatomic, copy) void(^forgetPasswordAction)(LJXErrorBlock didSuccess);
@property (nonatomic, assign) LJXLockViewType lockType;
@property (nonatomic, assign, readonly) BOOL bOldPasswordSuccessed;//修改密码时原密码是否正确;
@end
