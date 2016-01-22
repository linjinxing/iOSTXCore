//
//  UIStoryboard+Addition.m
//  TXUIKit
//
//  Created by linjinxing on 16/1/23.
//  Copyright © 2016年 Mobo. All rights reserved.
//

#import "UIStoryboard+Addition.h"

@implementation UIStoryboard (Addition)
+ (UIViewController*)instantiateViewControllerWithIdentifier:(NSString*)identifier inStoryboard:(NSString*)sbName{
   UIStoryboard* sb = [UIStoryboard storyboardWithName:sbName bundle:nil];
    return [sb instantiateViewControllerWithIdentifier:identifier];
}
+ (UINavigationController*)instantiateNaviVCWithIdentifier:(NSString*)identifier inStoryboard:(NSString*)sb{
    return (UINavigationController*)[self instantiateViewControllerWithIdentifier:identifier inStoryboard:sb];
}

+ (UIViewController*)instantiateViewControllerWithClass:(Class)cls inStoryboard:(NSString*)sb
{
    return [self instantiateViewControllerWithIdentifier:NSStringFromClass(cls) inStoryboard:sb];
}

@end
