//
//  LJXTextfieldTableViewCell.h
//  LJXTableView
//
//  Created by LoveYouForever on 9/22/14.
//  Copyright (c) 2014 i-Move. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJXTableViewCell.h"


@interface LJXTextfieldTableViewCell : LJXTableViewCell
@property(strong, nonatomic, readonly) UITextField* textField;
- (void)setupTextField;
@end
