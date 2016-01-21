//
//  NSURLRequest+LJXAddition.h
//  SCar
//
//  Created by Mobo360 on 15/4/23.
//  Copyright (c) 2015年 mobo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLRequest (LJXAddition)
/**
 *  网页格式表单提交
 *
 *  @param url           目标地址
 *  @param postParems    附带的参数
 *  @param imageFilePath 图片的路径
 *  @param imageName     图片名字
 *
 *  @return 返回 NSURLRequest
 */
+ (NSURLRequest *)requestWithURL: (NSString *)url  // IN
					  postParems: (NSDictionary *)postParems // IN
				       imageData: (NSString *)imageData  // IN
					   imageName: (NSString *)imageName;  // IN;
@end
