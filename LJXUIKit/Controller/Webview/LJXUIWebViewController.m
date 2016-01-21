//
//  MOBP2PUserProtocolViewController.m
//  MOBP2PLending
//
//  Created by Mobo360 on 15/5/22.
//  Copyright (c) 2015年 Mobo. All rights reserved.
//

#import "LJXUIWebViewController.h"
#import "LJXLoadingViewController.h"

@interface LJXUIWebViewController()<UIWebViewDelegate>
@property(nonatomic, strong) UIWebView* webview;
@end

@implementation LJXUIWebViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	if (nil == self.webview){
		UIWebView* webview = [[UIWebView alloc] initWithFrame:self.view.bounds];
//		 webview.translatesAutoresizingMaskIntoConstraints = NO;
		
		[self.view addSubview:webview];
		self.webview = webview;
		
//			NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:webview attribute:NSLayoutAttributeTop multiplier:1 constant:0];
//			[webview addConstraint:constraint];
//			
//			constraint = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:webview attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
//			[webview addConstraint:constraint];
//			
//			constraint = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:webview attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
//			[webview addConstraint:constraint];
//			
//		constraint = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:webview attribute:NSLayoutAttributeRight multiplier:1 constant:0];
//			[webview addConstraint:constraint];
		
	}
	self.webview.delegate = self;
	[self loadRequest];
}


- (void)loadRequest
{
	[self showHUDProgress];
	NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:[self.url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
	NSAssert(nil != req, @"NSURLRequest 不能为空。");
	[self.webview loadRequest:req];
	
//	LJXPerformBlockAsyn(^{
//		NSError* error = nil;
//		NSURL* url = [NSURL URLWithString:self.url];
//		NSString* str = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
//		LJXFoundationLog("str:%@, error:%@", str, error);
//		if	(error){
//			[self hidHUDProgress];
//			[self showErrorHUD:error];
//		}
////		else{
////			[self.webview loadHTMLString:str baseURL:url];
////		}
//	});
	
//	@weakify(self)
//	[NSTimer scheduledTimerWithTimeInterval:10.0 repeats:NO block:^(NSTimer *inTimer) {
//		@strongify(self)
//		[self hidHUDProgress];
//		[self showHUDAndHidWithStr:@"加载超时!"];
//		[self.webview stopLoading];
//	}];
}

- (IBAction)refresh:(id)sender
{
	[self loadRequest];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[self hidHUDProgress];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	[self hidHUDProgress];	
	[self showErrorHUD:error];
}

@end






