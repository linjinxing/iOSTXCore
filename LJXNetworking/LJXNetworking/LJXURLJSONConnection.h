//
//  LJXHTTPRequest.h
//  SCar
//
//  Created by Mobo360 on 15/4/9.
//  Copyright (c) 2015年 yfb. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum tagLJXURLJSONConnectionErrorCode{
	LJXHTTPRequestErrorOK,
//	LJXHTTPRequestErrorReponseErrorCode,   /* 服务器在response中返回了错误码 */
    LJXHTTPRequestErrorJSON2ClassFailure   /* json数据转对象失败  */
}LJXURLJSONConnectionErrorCode;

FOUNDATION_EXPORT NSString* const LJXURLJSONConnectionErrorDomain;

/* 请求返回结果，result可能是一个自定义的类，一个数组或字典 */
typedef void (^LJXURLJSONConnectionSuccess)(id result);

/* 请求返回结果返回失败，包括将json数据映射为model时失败 */
typedef void (^LJXURLJSONConnectionFailure)(NSError *error, id respondseObject);

/**
 *  url请求，解析返回的json数据，目前只支持json格式
 *
 *  @param request       NSURLRequest
 *  @param keyPath       返回的reponse数据从哪里开始解析成相应的cls
 *  @param cls           reponse数据解析成json后对应的类
 *  @param success       成功回调
 *  @param failure       失败回调
 */
void LJXURLJSONConnection(NSURLRequest* request,
                          NSString* keyPath,
                          Class cls,
                          LJXURLJSONConnectionSuccess success,
                          LJXURLJSONConnectionFailure failure);

void LJXURLJSONConnectionURL(NSString* url,
                             NSString* keyPath,
                             Class cls,
                             LJXURLJSONConnectionSuccess success,
                             LJXURLJSONConnectionFailure failure);

