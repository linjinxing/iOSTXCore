//
//  UIViewController+Addition.h
//  iMoveHomeServer
//
//  Created by LoveYouForever on 11/3/14.
//  Copyright (c) 2014 i-Move. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Addition)
- (void)popSelfViewController;
- (void)presentViewControllerWithTransparentBackgroud:(UIViewController*)vc;
- (UIViewController*)presentedTopViewController;

- (void)setupToolbarItemsWithTitles:(NSArray *)titles action:(SEL)action;
- (UIViewController*)viewControllerInStoryboard:(NSString*)sb identifier:(NSString*)identifier;

- (UIButton *)toolbarItemWithTitle:(NSString *)title;
//- (void)setupToolbarItemsWithTitles:(NSArray *)titles image:(NSArray *)images action:(SEL)action;

- (UIViewController* )presentViewControllerWithIdentifier:(NSString *)viewControllerIdentifier inStoryboard:(NSString*)storyboardName;

//- (void)pushViewControllerWithIdentifier:(NSString *)viewControllerIdentifier inStoryboard:(NSString*)storyboardName;

// 创建viewcontroller，并添加返回按键，并从present它
- (UIViewController* )presentViewControllerWithIdentifier:(NSString *)viewControllerIdentifier inStoryboard:(NSString*)storyboardName createExitBtn:(BOOL)bl;

+ (UIViewController*) instantiateViewControllerInStoryboard:(NSString*) storyboardName;
/**
 *  将自己在最顶层的viewcontroller中显示
 *
 *  @param storyboardName 自己所在的storyboard的名字
 *
 *  @return 实例化的自己
 */
+ (UIViewController*) prsentInStoryboard:(NSString*) storyboardName;
@end

/**
 *  创建class，并添加返回按键，并从present它
 * Class
 */
UIViewController* LJXViewControlerPresentClass(Class cls, void(^init)(UIViewController*viewController));


void LJXUIPresentViewControlerWithNaviController(UIViewController* vc, BOOL showReturnButton);



