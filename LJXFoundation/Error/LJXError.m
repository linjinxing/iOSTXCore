//
//  LJXError.m
//  iMoveHomeServer
//
//  Created by LoveYouForever on 12/30/14.
//  Copyright (c) 2014 i-Move. All rights reserved.
//

#import "LJXError.h"

NSString * const kLJXVErrorDomain = @"com.i-move.erro";

NSError*  LJXErrorCreateWithCode(NSInteger code, NSDictionary* userInfo)
{
    return [NSError errorWithDomain:kLJXVErrorDomain code:code userInfo:userInfo];
}

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
