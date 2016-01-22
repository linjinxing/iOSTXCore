//
//  MBP2PURLJSONConnection.m
//  LJXNetworking
//
//  Created by Mobo360 on 15/4/30.
//  Copyright (c) 2015年 Mobo. All rights reserved.
//
#import "TXURLJSONConnection.h"
#import "TXURLJSONConnectionSignal.h"

NSString* const MOBConstURLHost = @"http://112.126.80.207:8016";

NSString* const MOBHTTPRequestErrorDomain = @"MOBHTTPRequestErrorDomain";
//NSString* const MBP2PNotificationURLJSONConnectionSignIn = @"MBP2PNotificationURLJSONConnectionSignIn";


static NSString* obj2jsonstr(id obj, NSError** error)
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:error];
    
    if (! jsonData) {
        LJXNSError(*error);
        return nil;
    } else {
        NSString* str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] ;
        str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        //        str = [str stringByReplacingOccurrencesOfString:@"\"" withString:@"%22"];
        return str;
    }
}

static NSData* httBodyData(id obj, NSError** error){
    NSString* str = obj2jsonstr(obj, error);
    if (str) {
        return [[@"params=" stringByAppendingString:str] dataUsingEncoding:NSUTF8StringEncoding];
    }
    return nil;
}

//static NSData* MBHTTPRequestBodyData(id parameter)
//{
//	NSError* error;
//	NSData* tmpData = [NSJSONSerialization dataWithJSONObject:parameter
//													  options:NSJSONWritingPrettyPrinted error:&error];
//	LJXFoundationLog("parameter:%@", parameter);
//	if (error) {
//		LJXNSError(error);
//	}
//	return tmpData;
//}

RACSignal* TXURLJSONConnectionCreateSignal(NSString* path, NSDictionary* param, NSString* keyPath, Class cls)
{
#if 0 /* body 形式 */
    NSError* error;
    path = @"/LoginServer/appServlet";
//    NSString* url = [MOBConstURLHost stringByAppendingFormat:@"%@?params=%@", path, obj2jsonstr(param, &error)];
    NSString* url = [MOBConstURLHost stringByAppendingString:path];
    LJXFoundationLog("url:%@", url);
//    LJXFoundationLog("url en:%@", [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
    NSURL* nsurl = [NSURL URLWithString:url];
	//	NSURL* nsurl = [NSURL URLWithString:[@"http://192.168.31.14:8181/shancar_webus_business" stringByAppendingString:path]];
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:nsurl];
	
	[request setHTTPMethod:@"POST"];
    [request setHTTPBody:httBodyData(param, &error)];
    LJXNSError(error);
	
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
#else
    NSError* error;
    path = @"/LoginServer/appServlet";
    NSString* url = [MOBConstURLHost stringByAppendingFormat:@"%@?params=%@", path, obj2jsonstr(param, &error)];
    LJXFoundationLog("url:%@", url);
    LJXFoundationLog("url en:%@", [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]);
    NSURL* nsurl = [NSURL URLWithString:[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    //	NSURL* nsurl = [NSURL URLWithString:[@"http://192.168.31.14:8181/shancar_webus_business" stringByAppendingString:path]];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:nsurl];
#endif
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

RACSignal* CTHURLJSONConnectionCreateSignal(NSDictionary* param, NSString* keyPath, Class cls){
    return TXURLJSONConnectionCreateSignal(nil, param, keyPath, cls);
}

