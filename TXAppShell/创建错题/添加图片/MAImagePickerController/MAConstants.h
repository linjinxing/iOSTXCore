//
//  MAConstants.h
//  instaoverlay
//
//  Created by Maximilian Mackh on 11/6/12.
//  Copyright (c) 2012 mackh ag. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kImageCapturedSuccessfully @"imageCapturedSuccessfully"
#define kCameraToolBarHeight 54
#define kCameraFlashDefaultsKey @"MAImagePickerControllerFlashIsOn"
#define kCropButtonSize 100
#define kActivityIndicatorSize 100

/* 完成选择和编辑 */
typedef void(^MAImagePickerDidFinish)(UIImage*image);
/* 用户取消选择或编辑 */
typedef void(^MAImagePickerDidCancel)();

@interface MAConstants : NSObject

@end
