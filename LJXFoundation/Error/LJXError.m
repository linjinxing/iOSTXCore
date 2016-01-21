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