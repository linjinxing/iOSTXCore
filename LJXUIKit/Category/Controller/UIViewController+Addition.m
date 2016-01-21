//
//  UIViewController+Addition.m
//  iMoveHomeServer
//
//  Created by LoveYouForever on 11/3/14.
//  Copyright (c) 2014 i-Move. All rights reserved.
//

#import "UIViewController+Addition.h"
#import "UIResponderAdditions.h"

@implementation UIViewController (Addition)
//
//- (void)setupToolbarItemsWithTitles:(NSArray *)titles image:(NSArray *)images action:(SEL)action
//{
//    UIBarButtonItem* (^item)(NSString*, UIImage*,NSUInteger tag) = ^(NSString* title, UIImage *image,NSUInteger tag){
//        LJXButton *button = [[LJXButton alloc] init];
//        
//        button.titleLabel.font = [UIFont systemFontOfSize:10.0f];
//        [button setTitle:title forState:UIControlStateNormal];
//        button.imageView.contentMode = UIViewContentModeCenter;
//        button.titleLabel.contentMode = UIViewContentModeCenter;
//        [button setTitleColor:UIColorFromRGB(0X007AFF) forState:UIControlStateNormal];
//        [button setImage:image forState:UIControlStateNormal];
//        button.layout = LJXBL_ImageTop;
//        [button sizeToFit];
//        [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:button];
//        item.tag = tag;
//        return item;
//    };
//    
//    NSMutableArray*items = [NSMutableArray arrayWithCapacity:5];
//    UIBarButtonItem* space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    [items addObject:space];
//    for (int i = 0; i < [titles count]; ++i) {
//        [items addObject:item(titles[i],images[i], i)];
//        [items addObject:space];
//    }
//    [self setToolbarItems:items animated:YES];
//}

- (void)setupToolbarItemsWithTitles:(NSArray *)titles action:(SEL)action
{
    UIBarButtonItem* (^item)(NSString*, NSUInteger tag) = ^(NSString* title, NSUInteger tag){
        UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:action];


        item.tag = tag;
        return item;
    };
    
    NSMutableArray*items = [NSMutableArray arrayWithCapacity:5];
    UIBarButtonItem* space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [items addObject:space];
    for (int i = 0; i < [titles count]; ++i) {
        [items addObject:item(titles[i], i)];
        [items addObject:space];
    }
    [self setToolbarItems:items animated:YES];
}

- (UIViewController*)viewControllerInStoryboard:(NSString*)name identifier:(NSString*)identifier
{
    UIStoryboard* sb = [UIStoryboard storyboardWithName:name bundle:nil];
    return [sb instantiateViewControllerWithIdentifier:identifier];
}

- (UIButton *)toolbarItemWithTitle:(NSString *)title
{
//    __block UIBarButtonItem* item = nil;
    __block UIButton *buttonItem = nil;
    [self.toolbarItems enumerateObjectsUsingBlock:^(UIBarButtonItem *obj, NSUInteger idx, BOOL *stop) {
        UIButton *button = (UIButton *)obj.customView;
        if ([button.titleLabel.text isEqualToString:title]){
            buttonItem = button;
            *stop = YES;
        }
    }];
    return buttonItem;
}

- (UIViewController*)__presentedViewController:(UIViewController*)viewCtrl
{
    if (viewCtrl.presentedViewController) {
        return [viewCtrl __presentedViewController:viewCtrl.presentedViewController];
    }else{
        return viewCtrl;
    }
}

- (UIViewController*)presentedTopViewController
{
    return [self __presentedViewController:self];
}

- (UIViewController* )presentViewControllerWithIdentifier:(NSString *)viewControllerIdentifier inStoryboard:(NSString*)storyboardName
{
	UIStoryboard* sb = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
	UIViewController* vc = [sb instantiateViewControllerWithIdentifier:viewControllerIdentifier];
    
    UINavigationController* nav = (UINavigationController *)vc;
    if (![vc isKindOfClass:[UINavigationController class]]) {
       nav = [[UINavigationController alloc] initWithRootViewController:vc];
    }

	[self presentViewController:nav animated:YES completion:nil];
	return vc;
}

- (UIViewController *)presentViewControllerWithIdentifier:(NSString *)viewControllerIdentifier inStoryboard:(NSString *)storyboardName createExitBtn:(BOOL)bl {
    
    UIViewController *controller = [self presentViewControllerWithIdentifier:viewControllerIdentifier inStoryboard:storyboardName];
    __weak UIViewController* weakVC = controller;
    if (bl) {
        controller.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:weakVC action:@selector(exitBtn)];
    }
    return controller;
}
- (void)exitBtn{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)popSelfViewController
{
	[self.navigationController popViewControllerAnimated:YES];
}

//- (void)pushViewControllerWithIdentifier:(NSString *)viewControllerIdentifier inStoryboard:(NSString*)storyboardName
//{
//	UIStoryboard* sb = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
//	UIViewController* vc = [sb instantiateViewControllerWithIdentifier:viewControllerIdentifier];
//	[self.navigationController pushViewController:vc animated:YES];
//}
@end


void LJXUIPresentViewControlerWithNaviController(UIViewController* vc, BOOL showReturnButton)
{
	if ([LJXUIGetTopViewController() presentingViewController]) {
		LJXUILog("[LJXUIGetTopViewController() presentingViewController]:%@", [LJXUIGetTopViewController() presentingViewController]);
	}else{
		__weak UIViewController* weakVC = vc;
		
		if (showReturnButton){
			vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:^{
				[weakVC dismissViewControllerAnimated:YES completion:nil];
			} action:@selector(invoke)];
		}
		//	[[UIBarButtonItem alloc] bk_initWithTitle:@"返回" style:UIBarButtonItemStylePlain handler:^(id sender) {
		//        [weakVC dismissViewControllerAnimated:YES completion:nil];
		//    }];
		UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
		[LJXUIGetTopViewController() presentViewController:nav animated:YES completion:nil];
	}
}

UIViewController* LJXViewControlerPresentClass(Class class, void(^init)(UIViewController*viewController))
{
    UIViewController* vc = [[class alloc] init];
    if (init) {
        init(vc);
    }
	LJXUIPresentViewControlerWithNaviController(vc, YES);
	return vc;
}





