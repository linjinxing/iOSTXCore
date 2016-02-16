//
//  UIImage+OpenCV.m
//  PRJCTH
//
//  Created by linjinxing on 16/2/3.
//  Copyright © 2016年 CTH. All rights reserved.
//

#import "UIImage+OpenCV.h"
#import "MAOpenCV.h"

@implementation UIImage (OpenCV)

- (UIImage*)thresholdImage
{
    cv::Mat original = [MAOpenCV cvMatGrayFromAdjustedUIImage:self];
    
    cv::GaussianBlur(original, original, cvSize(11,11), 0);
    cv::adaptiveThreshold(original, original, 255, cv::ADAPTIVE_THRESH_MEAN_C, cv::THRESH_BINARY, 5, 2);
    UIImage* image = [MAOpenCV UIImageFromCVMat:original];
    
    original.release();
    return image;
}
@end
