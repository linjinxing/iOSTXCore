//
//  UIImage+Addition.m
//  LJXUIKit
//
//  Created by Mobo360 on 15/4/24.
//  Copyright (c) 2015年 Mobo. All rights reserved.
//

#import "UIImage+Addition.h"

@implementation UIImage (Addition)
+ (NSData*)imageDataForFilePath:(NSString*)filePath
{
	NSData* data = nil;
	if (self){
		
		UIImage *image=[UIImage imageWithContentsOfFile:filePath];
		//判断图片是不是png格式的文件
		if (UIImagePNGRepresentation(image)) {
			//返回为png图像。
			data = UIImagePNGRepresentation(image);
		}else {
			//返回为JPEG图像。
			data = UIImageJPEGRepresentation(image, 1.0);
		}
	}
	return data;
}

+ (instancetype)imageFromView:(UIView *)view
{
	UIGraphicsBeginImageContext(view.frame.size);
	[[view layer] renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return screenshot;
}

- (UIImage*)mergeImage:(UIImage*)aImage frame:(CGRect)frame
{
	UIGraphicsBeginImageContext(self.size);
	CGFloat mergedScale = MAX(self.scale, aImage.scale);
	UIGraphicsBeginImageContextWithOptions(self.size, NO, mergedScale);
	[self drawInRect: CGRectMake(0, 0, self.size.width, self.size.height)];
	[aImage drawInRect: frame];
	
	UIImage* combinedImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return combinedImage;
}

@end
