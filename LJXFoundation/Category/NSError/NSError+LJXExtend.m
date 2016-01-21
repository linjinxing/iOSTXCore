//
//  NSError+LJXExtend.m
//  iMoveHomeServer
//
//  Created by zengwm on 14/11/22.
//  Copyright (c) 2014年 i-Move. All rights reserved.
//

#import "NSError+LJXExtend.h"

@implementation NSError (LJXExtend)

+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code description:(NSString *)description failReason:(NSString *)failReason
{
    NSParameterAssert(description);
    if (!description) {
        NSException *exception = [NSException exceptionWithName:@"NSError Exception" reason:@"请填写错误描述description" userInfo:nil];
        [exception raise];
    }

    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:2];
    [userInfo setValue:description forKey:NSLocalizedDescriptionKey];
    [userInfo setValue:false forKey:NSLocalizedFailureReasonErrorKey];
    return [NSError errorWithDomain:domain code:code userInfo:userInfo];
}

@end
