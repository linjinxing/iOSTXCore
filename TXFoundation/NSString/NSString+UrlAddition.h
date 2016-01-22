//
//  NSString+UrlAddition.h
//  LJXWebsite
//
//  Created by Zhang Jing on 13-2-26.
//  Copyright (c) 2013年 steven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (UrlAddition)

- (BOOL)isHostEqualToURL:(NSString*)url;
- (BOOL)isLocalHost;

//将NSUrl中query方法返回的请求字符串转换为字典形式(值进行过UrlDecode)
- (NSDictionary *)queryParams;

//将字符串进行Url编码
//- (NSString *)urlEncode;

//将字符串进行Url解码
- (NSString *)urlDecode;

//将字符串进行Url解码（GB2312）
- (NSString *)urlEncodeGB2312;

- (NSURL*)nsurl;

- (BOOL)isAudiovisualContent;

- (BOOL)isiPodOrAssetURL;

//判断是否是网络URL
- (BOOL)isRemoteURL;


#pragma mark - URLEncode Decode

- (NSString *)URLEncode;
- (NSString *)URLEncodeUsingEncoding:(NSStringEncoding)encoding;

- (NSString *)URLDecode;
- (NSString *)URLDecodeUsingEncoding:(NSStringEncoding)encoding;

@end
