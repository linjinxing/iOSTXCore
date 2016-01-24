//
//  LJXHTTPRequest.m
//  SCar
//
//  Created by Mobo360 on 15/4/9.
//  Copyright (c) 2015年 yfb. All rights reserved.
//
#import <MJExtension/MJExtension.h>
//#import <AFNetworking/AFNetworking.h>
#import "TXFoundation.h"
#import "LJXURLJSONConnection.h"

NSString* const LJXURLJSONConnectionErrorDomain = @"LJXURLConnectionErrorDomain";
typedef void (^LJXRequestResponseData)(NSData* data, NSError* error);


//static void LJXURLConnectionSendRequest(NSURLRequest* req,
//                                        LJXRequestResponseData responseBlock)
//{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSURLResponse* response = nil;
//        NSError* error = nil;
//        NSData* data = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error];
//        if (responseBlock) {
//            responseBlock(data, error);
//        }
//    });
//}

static void LJXURLConnectionSendRequest(NSURLRequest* req, LJXHTTPRequestResponse response)
{
    
#if defined(DEBUG)
    void (^printfResponseInfoBlock)(AFHTTPRequestOperation*) = ^(AFHTTPRequestOperation *operation){
        if ([operation responseData]) {
            NSString* str = [[NSString alloc] initWithData:[operation responseData] encoding:NSUTF8StringEncoding];
            NSError* jsonerror;
            id result = [NSJSONSerialization JSONObjectWithData:[operation responseData] options:NSJSONReadingAllowFragments error:&jsonerror];
            LJXFoundationLog("str:%@, body data:%@", str, result);
        }
    };
    
#define PrintfResponseInfo printfResponseInfoBlock
    
#else
#define PrintfResponseInfo
#endif
    
    id (^decodeJSON)(id responseData, NSError** error) = ^(id responseData, NSError** error){
        id result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:error];
        LJXNSError(*error);
        LJXHTTPRequestLog("obj:%@", result);
        return result;
    };
    
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    op.responseSerializer = [AFHTTPResponseSerializer serializer];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",nil];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        PrintfResponseInfo(operation);
        NSError* error = nil;
        id result = decodeJSON([operation responseData], &error);
        if (response) {
            response(result, error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        PrintfResponseInfo(operation);
        id result = nil;
        if ((kCFURLErrorCannotDecodeContentData == error.code)
            && [operation responseData]) {
            NSError* error = nil;
            result = decodeJSON([operation responseData], &error);
        }
        if (response) {
            response(result, error);
        }
    }];
    
    
    static AFHTTPRequestOperationManager* mng = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mng.requestSerializer.timeoutInterval = req.timeoutInterval;
        mng = [AFHTTPRequestOperationManager manager];
        [mng.operationQueue setMaxConcurrentOperationCount:1];
    });
    [mng.operationQueue addOperation:op];
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
                                             Class cls)
{
	id result = nil;
    id datas = keypath ? [responseObject valueForKeyPath:keypath] : responseObject;
	if (cls) {
        NSError* error = nil;
		if ([datas isKindOfClass:[NSArray class]]) {
			result = [cls objectArrayWithKeyValuesArray:datas error:&error];
		}else if ([datas isKindOfClass:[NSDictionary class]]){
            result = [cls objectWithKeyValues:datas error:&error];
		}else{
            error = [NSError errorWithDomain:LJXURLJSONConnectionErrorDomain code:LJXHTTPRequestErrorJSON2ClassFailure userInfo:@{NSLocalizedFailureReasonErrorKey:@"json数据转对象失败"}];
			NSLog(@"datas:%@ convert to class:%@ failure", datas, NSStringFromClass(cls));
		}
	}else{
        result = datas ? datas : responseObject;
	}
	return result;
}


void LJXURLJSONConnection(NSURLRequest* request,
                          NSString* keyPath,
                          Class cls,
//                          LJXURLJSONConnectionReponseDataError getErrorMsg,
                          LJXURLJSONConnectionSuccess success,
                          LJXURLJSONConnectionFailure failure)
{
	/* 如果需要解析成cls，那么传入的getErrorMsg是不能为空 */
//	if (nil != cls && nil == getErrorMsg) {
//		NSLog(@"必须对返回的数据判断是否成功，如果不需要判断，请直接返回Yes");
//        assert(nil != cls && nil == getErrorMsg);
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
        id result = LJXURLConnectionJSON2ClassInstance(obj, keyPath, &error, cls);
        returnIfError(error, obj ? obj : data);
        if (success) {
            success(result);
        }
    });
	
}


void LJXURLJSONConnectionURL(NSString* url,
                             NSString* keyPath,
                             Class cls,
//                             LJXURLJSONConnectionReponseDataError getErrorMsg,
                             LJXURLJSONConnectionSuccess success,
                             LJXURLJSONConnectionFailure failure)
{
	LJXURLJSONConnection([NSURLRequest requestWithURL:[NSURL URLWithString:url]], keyPath, cls, success, failure);
}







