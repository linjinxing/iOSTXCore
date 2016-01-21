//
//  UINavigationController+LJXAddition.m
//  SCar
//
//  Created by Mobo360 on 15/4/15.
//  Copyright (c) 2015年 mobo. All rights reserved.
//

#import "UINavigationController+LJXAddition.h"

@implementation UINavigationController (LJXAddition)
- (void)pushViewControllerWithIdentifier:(NSString *)viewControllerIdentifier inStoryboard:(NSString*)storyboardName
{
	[self pushViewControllerWithIdentifier:viewControllerIdentifier inStoryboard:storyboardName title:nil];
}

- (void)pushViewControllerWithIdentifier:(NSString *)viewControllerIdentifier inStoryboard:(NSString*)storyboardName title:(NSString*)title
{
	UIStoryboard* sb = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
	UIViewController* vc = [sb instantiateViewControllerWithIdentifier:viewControllerIdentifier];
	if (title) vc.title = title;
	[self pushViewController:vc animated:YES];
}


@end
