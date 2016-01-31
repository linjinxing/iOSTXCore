//
//  UIImage+editor.m
//  DavidVideo
//
//  Created by Test on 14-9-7.
//  Copyright (c) 2014年 Test. All rights reserved.
//

#import "UIImage+editor.h"

@implementation UIImage (editor)
- (UIImage *)scaleWithSize:(CGSize)_size
{
	UIGraphicsBeginImageContext(_size);
	
	[self drawInRect:CGRectMake(0, 0, _size.width, _size.height)];
	
	UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	
	
	UIGraphicsEndImageContext();
	
	return scaledImage;
}


- (UIImage*)scaleToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext( newSize );
    [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


- (UIImage *)scaleWithWidth:(CGFloat)newWidth
{
	return [self scaleWithSize:CGSizeMake(newWidth, (self.size.height / self.size.width) * newWidth)];
}


- (void)save2TempWithName:(NSString*)aName
{
	NSData* date = UIImageJPEGRepresentation(self, 1.0);
	NSString* path = [[LJXPath systemData] stringByAppendingPathComponent:aName];
	
	if	(0 == [[aName pathExtension] length]){
		path = [path stringByAppendingString:@".jpg"];
	}
	
	NSError* error ;
	if (![date writeToFile:path options:NSDataWritingAtomic error:&error]){
		LJXError("error to save:%@, path:%@\n", error, path);
	}
}

@end
