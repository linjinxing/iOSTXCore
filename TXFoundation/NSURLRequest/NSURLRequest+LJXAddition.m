//
//  NSURLRequest+LJXAddition.m
//  SCar
//
//  Created by Mobo360 on 15/4/23.
//  Copyright (c) 2015年 mobo. All rights reserved.
//

#import "NSURLRequest+LJXAddition.h"

static NSString * const FORM_FLE_INPUT = @"filePath";

@implementation NSURLRequest (LJXAddition)

+ (NSURLRequest *)requestWithURL: (NSString *)url  // IN
					  postParems: (NSDictionary *)postParems // IN
				       imageData: (NSData *)imageData  // IN
					   imageName: (NSString *)imageName  // IN
{
	
	NSString *TWITTERFON_FORM_BOUNDARY = @"0xKhTmLbOuNdArY";
	//根据url初始化request
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
														   cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
													   timeoutInterval:10];
	//分界线 --AaB03x
	NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
	//结束符 AaB03x--
	NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
	//得到图片的data
	NSData* data = imageData;
	//http body的字符串
	NSMutableString *body=[[NSMutableString alloc]init];
	//参数的集合的所有key的集合
	NSArray *keys= [postParems allKeys];
	
	//遍历keys
	for (int i=0;i<[keys count];i++){
		//得到当前key
		NSString *key=[keys objectAtIndex:i];
		
		//添加分界线，换行
		[body appendFormat:@"%@\r\n",MPboundary];
		//添加字段名称，换2行
		[body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
		//添加字段的值
		[body appendFormat:@"%@\r\n",[postParems objectForKey:key]];
		
		NSLog(@"添加字段的值==%@",[postParems objectForKey:key]);
	}
	
	if (imageName){
		////添加分界线，换行
		[body appendFormat:@"%@\r\n",MPboundary];
		
		//声明pic字段，文件名为boris.png
		[body appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",FORM_FLE_INPUT, imageName];
		//声明上传文件的格式
		[body appendFormat:@"Content-Type: image/jpge,image/gif, image/jpeg, image/pjpeg, image/pjpeg\r\n\r\n"];
	}
	
	//声明结束符：--AaB03x--
	NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
	//声明myRequestData，用来放入http body
	NSMutableData *myRequestData=[NSMutableData data];
	
	//将body字符串转化为UTF8格式的二进制
	[myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
	if (data){
		//将image的data加入
		[myRequestData appendData:data];
	}
	//加入结束符--AaB03x--
	[myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
	
	//设置HTTPHeader中Content-Type的值
	NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
	//设置HTTPHeader
	[request setValue:content forHTTPHeaderField:@"Content-Type"];
	//设置Content-Length
	[request setValue:[NSString stringWithFormat:@"%@", @([myRequestData length])] forHTTPHeaderField:@"Content-Length"];
	//设置http body
	[request setHTTPBody:myRequestData];
	//http method
	[request setHTTPMethod:@"POST"];
	
	return request;
}

@end


