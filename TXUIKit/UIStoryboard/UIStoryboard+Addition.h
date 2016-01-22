//
//  UIStoryboard+Addition.h
//  TXUIKit
//
//  Created by linjinxing on 16/1/23.
//  Copyright © 2016年 Mobo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIStoryboard (Addition)
+ (UIViewController*)instantiateViewControllerWithClass:(Class)cls inStoryboard:(NSString*)sb;

+ (UIViewController*)instantiateViewControllerWithIdentifier:(NSString*)identifier inStoryboard:(NSString*)sb;
+ (UINavigationController*)instantiateNaviVCWithIdentifier:(NSString*)identifier inStoryboard:(NSString*)sb;
@end
