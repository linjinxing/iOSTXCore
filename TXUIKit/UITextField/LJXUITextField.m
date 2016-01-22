//
//  LJXUITextField.m
//  LJXUIKit
//
//  Created by Mobo360 on 15/6/2.
//  Copyright (c) 2015年 Mobo. All rights reserved.
//

#import "LJXUITextField.h"
#import "LJXUIMacros.h"

@interface LJXUITextField()
@property(nonatomic, weak) IBOutlet UITextField* tf;
@end

@implementation LJXUITextField

- (void)awakeFromNib
{
	self.backgroundColor = UIColorFromRGBHex(0xcccccc);
	self.tf.textColor = UIColorFromRGBHex(0x666666);
	
	if	(nil == self.tf.leftView){
		UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, self.tf.leftView.frame.size.height)];
		view.backgroundColor = [UIColor clearColor];
		self.tf.leftViewMode = UITextFieldViewModeAlways;
		self.tf.leftView = view;
	}
}

@end
