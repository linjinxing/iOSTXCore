//
//  LJXUserNameTextField.m
//  LJXUIKit
//
//  Created by Mobo360 on 15/5/8.
//  Copyright (c) 2015年 Mobo. All rights reserved.
//

#import "LJXUserNameTextField.h"
#import "UIView+Layout.h"

@implementation LJXUserNameTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setupLeftView
{
	UIImageView* iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_id_icon"]];
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


@end
