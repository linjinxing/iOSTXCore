//
//  UIImage+Bundle.h
//  iMove
//
//  Created by linjinxing on 7/30/14.
//  Copyright (c) 2014 iMove. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Bundle)
+ (instancetype)imageWithName:(NSString*)fileName inMainBundleName:(NSString*)name;
+ (instancetype)imageWithName:(NSString*)fileName subdirectory:(NSString*)subdir inMainBundleName:(NSString*)name;
@end
