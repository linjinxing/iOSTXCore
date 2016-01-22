//
//  MBP2PURLJSONConnection.h
//  LJXNetworking
//
//  Created by Mobo360 on 15/4/30.
//  Copyright (c) 2015年 Mobo. All rights reserved.
//  每一个平台都要定制自己的请求哈。

#import <Foundation/Foundation.h>
//
//@interface MBP2PURLJSONConnectionCreateSignalPage : NSObject
//@property(nonatomic, assign) NSUInteger size;
//@property(nonatomic, assign) NSUInteger num;
//+ (instancetype)requestPageWithSize:(NSUInteger)size num:(NSUInteger)num;
//@end
//

FOUNDATION_EXPORT NSString* const MOBHTTPRequestErrorDomain;
//FOUNDATION_EXPORT NSString* const MBP2PNotificationURLJSONConnectionSignIn;

typedef enum tagMOBRequestErrorCode
{
	MOBRequestErrorCodeSuccess,   /*  操作成功  */
	MOBRequestErrorCodeInvalidParamter,   /* 请求参数非法! */
	MOBRequestErrorCodeAccessForbidden,   /* 请求非法，禁止访问！ */
	MOBRequestErrorCodeSignInTimeout,   /* 登录已超时，请重新登录。 */
	MOBRequestErrorCodeTransactionRisk,   /* 交易存在风险，请稍后重试！ */
	MOBRequestErrorCodeConnectionTimeOut,   /* 网络连接超时，请稍后重试！ */
	MOBRequestErrorCodeServerError,   /* 系统出现错误，请稍后重试！ */
	MOBRequestErrorCodeUserNameExist = 101,  /* 用户名已存在 */
	MOBRequestErrorCodeUserNameNotExist,   /* 用户名不存在 */
	MOBRequestErrorCodeSingInPasswordError,   /* 用户登录密码错误 */
	MOBRequestErrorCodeTransactionPasswordError,   /* 用户交易密码错误 */
	MOBRequestErrorCodeIDCardExist,   /* 身份证号码已注册 */
	MOBRequestErrorCodePhoneExist,   /* 手机号码已注册 */
	MOBRequestErrorCodeInvalidCode,   /* 验证码不正确 */
	MOBRequestErrorCodePhoneNotExist,    /* 手机号码不存在 */
	MOBRequestErrorCodeIDCardValidationDone    /* 用户已完成实名认证 */
}MOBRequestErrorCode;

FOUNDATION_EXTERN NSString* const MOBConstURLHost;

RACSignal* TXURLJSONConnectionCreateSignal(NSString* path, NSDictionary* param, NSString* keyPath, Class cls);


RACSignal* CTHURLJSONConnectionCreateSignal(NSDictionary* param, NSString* keyPath, Class cls);
