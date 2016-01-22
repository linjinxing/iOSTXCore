//
//  UIImage+Addition.h
//  LJXUIKit
//
//  Created by Mobo360 on 15/4/24.
//  Copyright (c) 2015年 Mobo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Addition)
+ (NSData*)imageDataForFilePath:(NSString*)filePath;
+ (instancetype)imageFromView:(UIView*)view;

/**
 *  合并图片image，frame是相对于self的坐标。
 *
 *  @param image 被合并图片
 *  @param frame 相对于self的坐标
 *
 *  @return 新的图片
 */
- (UIImage*)mergeImage:(UIImage*)image frame:(CGRect)frame;
@end
