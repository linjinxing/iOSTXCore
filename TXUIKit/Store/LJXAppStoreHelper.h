//
//  LJXAppStoreHelper.h
//  SCar
//
//  Created by mobao_ios on 15/4/20.
//  Copyright (c) 2015年 mobo. All rights reserved.
//

#import <UIKit/UIKit.h>

//跳转到appstore的相关应用，或者直接应用里展示相关应用
@interface LJXAppStoreHelper : NSObject

+(void)showApplicationWithAppID:(NSString *)appId parentController:(UIViewController *)vc ofAppStore:(BOOL)bl;
@end
