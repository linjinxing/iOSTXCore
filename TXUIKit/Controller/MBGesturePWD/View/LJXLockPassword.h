//
//  LJXLockPassword.h
//  LockSample
//
//  Created by Lugede on 14/11/12.
//  Copyright (c) 2014年 lugede.cn. All rights reserved.
//
//  密码保存模块

#import <Foundation/Foundation.h>

@interface LJXLockPassword : NSObject

#pragma mark - 锁屏密码读写
+ (void)setUser:(NSString*)userName;
+ (NSString*)loadLockPassword;
+ (void)clearLockPassword;
+ (void)saveLockPassword:(NSString*)pswd;
//+ (BOOL)isAlreadyAskedCreateLockPassword;
//+ (void)setAlreadyAskedCreateLockPassword;
+ (BOOL)isNeedVerificationLockPassword;//返回应用时是否验证手势密码
+ (void)setNeedVerificationLockPassword:(BOOL)bl;//设置验证密码 yes or no

@end
