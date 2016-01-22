//
//  LJXPasswordTextField.m
//  LJXUIKit
//
//  Created by Mobo360 on 15/5/8.
//  Copyright (c) 2015年 Mobo. All rights reserved.
//

#import "LJXPasswordTextField.h"
#import "UIButtonAdditions.h"
#import "UIView+Layout.h"

@interface LJXPasswordTextField()
@property(nonatomic, assign) BOOL openEyes;
@end

@implementation LJXPasswordTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setupLeftView
{
	UIImageView* iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_password_icon"]];
	iv.contentMode = UIViewContentModeCenter;
	iv.width += 10.0f;
	self.leftView = iv;
	self.leftViewMode = UITextFieldViewModeAlways;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self setupLeftView];
	}
	return self;
}

- (void)awakeFromNib
{
	[self setupLeftView];
}

- (void)action:(UIButton*)btn
{
	self.openEyes = !self.openEyes;
	self.secureTextEntry = !self.openEyes;
	[btn setImage:[UIImage imageNamed:self.openEyes ? @"sign_password_open_icon" : @"sign_password_close_icon"] forState:UIControlStateNormal];
}

- (void)setEyesButtonHidden:(BOOL)eyesButtonHidden
{
	if (!eyesButtonHidden) {
		UIButton* btn = [UIButton buttonWithNomalImage:[UIImage imageNamed:@"sign_password_close_icon"] highlightedImage:[UIImage imageNamed:@"sign_password_open_icon"]];
		btn.width = 60.0f;
		btn.height = 40.0f;
		[btn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
		self.rightView = btn;
		self.rightViewMode = UITextFieldViewModeAlways;
	}else{
		self.rightView = nil;
	}
}

@end
