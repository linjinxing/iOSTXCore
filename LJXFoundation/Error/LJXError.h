//
//  LJXError.h
//  iMoveHomeServer
//
//  Created by LoveYouForever on 12/30/14.
//  Copyright (c) 2014 i-Move. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LJXErrorCode) {
    LJXErrorCodeSuccess,
	LJXErrorCodeUserCancel, /* 用户取消 */
    LJXErrorCodeInvalidParameter, /* 无效参数 */
    LJXErrorCodeNetworkNotReachable, /* 网络不通 */
};

FOUNDATION_EXTERN NSString * const kLJXVErrorDomain;

NSError*  LJXErrorCreateWithCode(NSInteger code, NSDictionary* userInfo);