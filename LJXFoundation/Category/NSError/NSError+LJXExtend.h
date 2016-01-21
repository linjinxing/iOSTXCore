//
//  NSError+LJXExtend.h
//  iMoveHomeServer
//
//  Created by zengwm on 14/11/22.
//  Copyright (c) 2014年 i-Move. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (LJXExtend)

/**
 *  NSError扩展
 *
 *  @param domain
 *  @param code
 *  @param description 错误描述,必填
 *  @param failReason  错误原因,可选
 *
 *  @return NSError
 */
+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code description:(NSString *)description failReason:(NSString *)failReason;


@end
