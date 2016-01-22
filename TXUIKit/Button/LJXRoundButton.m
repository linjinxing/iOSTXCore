//
//  LJXRoundButton.m
//  LJXUIKit
//
//  Created by Mobo360 on 15/5/14.
//  Copyright (c) 2015年 Mobo. All rights reserved.
//

#import "LJXRoundButton.h"

@implementation LJXRoundButton


- (void)awakeFromNib
{
	self.layer.cornerRadius = 5;
	self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
	// (note - may prefer to use the tintColor of the control)
}

- (void)setEnabled:(BOOL)enabled
{
	[super setEnabled:enabled];
	self.alpha = enabled ? 1.0 : 0.5;
}

@end
