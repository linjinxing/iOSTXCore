//
//  LJXUINavigationController.m
//  LJXUIKit
//
//  Created by Mobo360 on 15/6/2.
//  Copyright (c) 2015年 Mobo. All rights reserved.
//

#import "LJXUINavigationController.h"
#import "UIViewController+Addition.h"

@interface LJXUINavigationController()<UINavigationControllerDelegate>

@end

@implementation LJXUINavigationController

- (instancetype)init
{
	self = [super init];
	if (self) {
		self.delegate = self;
	}
	return self;
}

- (void)awakeFromNib
{
	self.delegate = self;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	
	if (!(1 == [navigationController.viewControllers count])) {
		viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar_back"] style:UIBarButtonItemStylePlain target:viewController action:@selector(popSelfViewController)];
	}
}
@end
