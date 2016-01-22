//
//  LJXiewController.m
//  LJX
//
//  Created by lin steven on 4/16/11.
//  Copyright 2011 LJX. All rights reserved.
//

#import "LJXViewController.h"


@interface LJXViewController()
//@property(nonatomic, assign) UIStatusBarStyle statusBarStyle;
//@property(nonatomic, assign) BOOL statusBarHidden;
//@property(nonatomic, assign) UIBarStyle navigationBarStyle;
//@property(nonatomic, assign) BOOL navigationBarHidden;
//@property(nonatomic, assign) BOOL wantFullSceen;
@end

@implementation LJXViewController


- (void(^)(UIViewController*, NSString*))setupTitleBlock
{
    return ^(UIViewController*vc, NSString* title){
        UILabel* l = [[UILabel alloc] init];
        l.backgroundColor = [UIColor clearColor];
        l.textColor = [UIColor whiteColor];
        l.font = [UIFont boldSystemFontOfSize:20];
        l.text = title;
        [l sizeToFit];
        vc.navigationItem.titleView = l;
    };
}


- (void)viewDidLoad
{
    [super viewDidLoad];
//    if ([LJXSystem isiPad]) {
//        [self bk_addObserverForKeyPaths:@[@"title", @"navigationItem.title"] task:^(LJXiewController* vc, NSString* keyPath) {
//            [vc setupTitleBlock](vc, [vc valueForKeyPath:keyPath]);
//        }];
//    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)pushBarStatus
{
//    self.navigationBarHidden = self.navigationController.navigationBar.hidden;
//    self.navigationBarStyle = self.navigationController.navigationBar.barStyle;
//
//    self.statusBarStyle = [UIApplication sharedApplication].statusBarStyle;
//    self.statusBarHidden = [UIApplication sharedApplication].statusBarHidden;
//    
//    self.wantFullSceen = self.wantsFullScreenLayout;
    
    //LJXUILog("self.wantFullSceen:%d, self.statusBarStyle:%d, self.statusBarHidden:%d", self.wantFullSceen, self.statusBarStyle, self.statusBarHidden);    
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//}

- (BOOL)shouldAutorotate {
    return YES;
}

//- (NSUInteger)supportedInterfaceOrientations{
////        return UIInterfaceOrientationMaskAll;
//    if ([LJXSystem isiPad]) {
//        return UIInterfaceOrientationMaskAll;
//    }else{
//        return UIInterfaceOrientationMaskPortrait;
//    }
//}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
//    if ([LJXSystem isiPad]) {
//        //LJXUILog("is pad return yes");
//        return YES;
//    }else{
//        //LJXUILog("iphone toInterfaceOrientation:%d", toInterfaceOrientation);
//        return (UIInterfaceOrientationPortrait == toInterfaceOrientation);
//    }
//}
//
//- (void)popBarStatus
//{
//    [self setWantsFullScreenLayout:self.wantFullSceen];
//    [[UIApplication sharedApplication] setStatusBarStyle:self.statusBarStyle];
//    [[UIApplication sharedApplication] setStatusBarHidden:self.statusBarHidden];
//    self.navigationController.navigationBar.barStyle = self.navigationBarStyle;
//    [self.navigationController setNavigationBarHidden:self.navigationBarHidden animated:YES];
//    //LJXUILog("self.wantFullSceen:%d, self.statusBarStyle:%d, self.statusBarHidden:%d", self.wantFullSceen, self.statusBarStyle, self.statusBarHidden);
//}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
