//
//  LJXHTTPRequest.m
//  SCar
//
//  Created by Mobo360 on 15/4/9.
//  Copyright (c) 2015年 yfb. All rights reserved.
//

#import "LJXURLJSONConnection.h"

NSString* const LJXURLJSONConnectionErrorDomain = @"LJXURLConnectionErrorDomain";
typedef void (^LJXRequestResponseData)(NSData* data, NSError* error);


static void LJXURLConnectionSendRequest(NSURLRequest* req,
                                        LJXRequestResponseData responseBlock)
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLResponse* response = nil;
        NSError* error = nil;
        NSData* data = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error];
        if (responseBlock) {
            responseBlock(data, error);
        }
    });
}

static id LJXURLConnectionDecodeReponseData(NSData *data,
                                            NSError** error)
{
//    LJXAssert(nil != data);
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:error];
    NSLog(@"obj:%@, error:%@", result, *error);
    return result;
}


static id LJXURLConnectionJSON2ClassInstance(id responseObject,
                                             NSString* keypath,
                                             NSError**error,
                                             Class class)
{
	id result = nil;
    id datas = keypath ? [responseObject valueForKeyPath:keypath] : responseObject;
	if (class) {
        NSError* error = nil;
		if ([datas isKindOfClass:[NSArray class]]) {
			result = [class objectArrayWithKeyValuesArray:datas error:&error];
		}else if ([datas isKindOfClass:[NSDictionary class]]){
            result = [class objectWithKeyValues:datas error:&error];
		}else{
            error = [NSError errorWithDomain:LJXURLJSONConnectionErrorDomain code:LJXHTTPRequestErrorJSON2ClassFailure userInfo:@{NSLocalizedFailureReasonErrorKey:@"json数据转对象失败"}];
			NSLog(@"datas:%@ convert to class:%@ failure", datas, NSStringFromClass(class));
		}
	}else{
        result = datas ? datas : responseObject;
	}
	return result;
}


void LJXURLJSONConnection(NSURLRequest* request,
                          NSString* keyPath,
                          Class class,
//                          LJXURLJSONConnectionReponseDataError getErrorMsg,
                          LJXURLJSONConnectionSuccess success,
                          LJXURLJSONConnectionFailure failure)
{
	/* 如果需要解析成class，那么传入的getErrorMsg是不能为空 */
//	if (nil != class && nil == getErrorMsg) {
//		NSLog(@"必须对返回的数据判断是否成功，如果不需要判断，请直接返回Yes");
//        assert(nil != class && nil == getErrorMsg);
//		return;
//	}

#define returnIfError(error, responseObj)   \
        if (error) { \
            if (failure) { \
                failure(error, responseObj); \
            } \
            return ; \
        }
    
    LJXURLConnectionSendRequest(request, ^(NSData *data, NSError *error) {
        returnIfError(error, nil);
        id obj = LJXURLConnectionDecodeReponseData(data, &error);
        returnIfError(error, obj ? obj : data);
        id result = LJXURLConnectionJSON2ClassInstance(obj, keyPath, &error, class);
        returnIfError(error, obj ? obj : data);
        if (success) {
            success(result);
        }
    });
	
}


void LJXURLJSONConnectionURL(NSString* url,
                             NSString* keyPath,
                             Class class,
//                             LJXURLJSONConnectionReponseDataError getErrorMsg,
                             LJXURLJSONConnectionSuccess success,
                             LJXURLJSONConnectionFailure failure)
{
	LJXURLJSONConnection([NSURLRequest requestWithURL:[NSURL URLWithString:url]], keyPath, class, success, failure);
}







