//
//  MOBP2PUserProtocolViewController.h
//  MOBP2PLending
//
//  Created by Mobo360 on 15/5/22.
//  Copyright (c) 2015年 Mobo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJXUIWebViewController : UIViewController
@property(nonatomic, strong) NSString* url;
@property(nonatomic, strong, readonly) UIWebView* webview;

- (void)loadRequest;
@end
