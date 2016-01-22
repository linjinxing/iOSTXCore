//
//  UINavigationController+LJXAddition.h
//  SCar
//
//  Created by Mobo360 on 15/4/15.
//  Copyright (c) 2015年 mobo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (LJXAddition)
- (void)pushViewControllerWithIdentifier:(NSString *)viewControllerIdentifier inStoryboard:(NSString*)storyboardName;
- (void)pushViewControllerWithIdentifier:(NSString *)viewControllerIdentifier inStoryboard:(NSString*)storyboardName title:(NSString*)title;
@end


