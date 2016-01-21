//
//  MBP2PURLJSONConnection.m
//  LJXNetworking
//
//  Created by Mobo360 on 15/4/30.
//  Copyright (c) 2015年 Mobo. All rights reserved.
//

#import "MBP2PURLJSONConnection.h"
#import "TXURLJSONConnectionSignal.h"

NSString* const MOBHTTPRequestErrorDomain = @"MOBHTTPRequestErrorDomain";
NSString* const MBP2PNotificationURLJSONConnectionSignIn = @"MBP2PNotificationURLJSONConnectionSignIn";

static NSData* MBHTTPRequestBodyData(id parameter)
{
	NSError* error;
	NSData* tmpData = [NSJSONSerialization dataWithJSONObject:parameter
													  options:NSJSONWritingPrettyPrinted error:&error];
	LJXFoundationLog("parameter:%@", parameter);
	if (error) {
		LJXNSError(error);
	}
	return tmpData;
}

RACSignal* MBP2PURLJSONConnectionCreateSignal(NSString* path, NSDictionary* body, NSString* keyPath, Class cls)
{
	NSURL* nsurl = [NSURL URLWithString:[MOBConstURLHost stringByAppendingString:path]];
	//	NSURL* nsurl = [NSURL URLWithString:[@"http://192.168.31.14:8181/shancar_webus_business" stringByAppendingString:path]];
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:nsurl];
	NSMutableDictionary* dict = nil;
	if (body) {
		dict = [NSMutableDictionary dictionaryWithDictionary:body];
		dict[@"os"] = @"ios";
	}else{
		dict = [NSMutableDictionary dictionaryWithDictionary:@{@"os":@"ios"}];
	}

	[request setHTTPBody:MBHTTPRequestBodyData(dict)];
	
	[request setHTTPMethod:@"POST"];
	
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
//    NSString *errMsg = error.localizedDescription;
//    switch (error.code) {
//        case kCFURLErrorTimedOut:
//            errMsg = @"请求超时";
//            break;
//        case kCFURLErrorCannotConnectToHost:
//            errMsg = @"网络不给力";
//            break;
//        case kCFURLErrorNotConnectedToInternet:
//            errMsg = @"网络似乎已经断开";
//            break;
//        default:
//            break;
//    }
//    NSError *tempErr = [NSError errorWithDomain:@"connect failed" code:error.code userInfo:@{NSLocalizedDescriptionKey:errMsg}];
    
    return TXURLJSONConnectionSignal(request, keyPath, cls);
    
//	return LJXURLJSONConnectionCreateSignal(request, keyPath, cls,
//											^NSError*(id respondse){
//												NSInteger errorCode = [respondse[@"code"] integerValue];
//												if	(MOBRequestErrorCodeSuccess == errorCode){
//													return nil;
//												}else{
//													if (MOBRequestErrorCodeSignInTimeout == errorCode) {
//														[[NSNotificationCenter defaultCenter] postNotificationName:MBP2PNotificationURLJSONConnectionSignIn object:nil];
//													}
//													return [NSError errorWithDomain:MOBHTTPRequestErrorDomain code:errorCode userInfo:@{NSLocalizedDescriptionKey:respondse[@"msg"]}] ;
//												}
//											});
}



