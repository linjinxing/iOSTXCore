//
//  UIImage+editor.h
//  DavidVideo
//
//  Created by Test on 14-9-7.
//  Copyright (c) 2014年 Test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (editor)
- (UIImage*)scaleToSize:(CGSize)newSize;

- (UIImage *)scaleWithWidth:(CGFloat)newWidth;
- (void)save2TempWithName:(NSString*)aName;
@end
