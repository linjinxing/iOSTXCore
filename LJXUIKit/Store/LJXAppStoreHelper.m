//
//  LJXAppStoreHelper.m
//  SCar
//
//  Created by mobao_ios on 15/4/20.
//  Copyright (c) 2015年 mobo. All rights reserved.
//

#import "LJXAppStoreHelper.h"
#import <StoreKit/StoreKit.h>

@interface LJXAppStoreHelper ()<SKStoreProductViewControllerDelegate>

@end
@implementation LJXAppStoreHelper

+ (void)showApplicationWithAppID:(NSString *)appId parentController:(UIViewController *)vc ofAppStore:(BOOL)bl {
    if (bl) {
        NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@?mt=8",appId];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        
    }else {
        SKStoreProductViewController *storeController = [[SKStoreProductViewController alloc] init];
        storeController.delegate = self;
        [storeController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:appId} completionBlock:^(BOOL result, NSError *error) {
            if (!result) {
                NSLog(@"SKStoreProductViewController 初始化失败");
            }
        }];
        
        [vc presentViewController:storeController animated:YES completion:nil];
    }
}


+(void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    if (viewController) {
        [viewController dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
