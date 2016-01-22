//
//  LJXRoundFrameButton.m
//  LJXUIKit
//
//  Created by Mobo360 on 15/5/14.
//  Copyright (c) 2015年 Mobo. All rights reserved.
//

#import "LJXRoundFrameButton.h"
#import "LJXUIStyle.h"

@implementation LJXRoundFrameButton


- (void)awakeFromNib
{
	self.layer.cornerRadius = 5;
	self.layer.borderWidth = 1;
	self.layer.borderColor = LJXUIStyleButtonBackgroudColor().CGColor;
	// (note - may prefer to use the tintColor of the control)
}

@end



