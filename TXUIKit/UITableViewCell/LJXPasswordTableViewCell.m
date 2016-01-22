//
//  LJXPasswordTableViewCell.m
//  LJXSettingTableView
//
//  Created by LoveYouForever on 9/24/14.
//  Copyright (c) 2014 i-Move. All rights reserved.
//

#import "LJXPasswordTableViewCell.h"
#import "LJXUI.h"
#import "LJXFoundation.h"

@implementation LJXPasswordTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithStyle:LJXTableViewCellStylePassword reuseIdentifier:reuseIdentifier item:nil];
}

- (void)setupTextfieldRightView
{
    LJXMultiStateButton* button = [LJXMultiStateButton buttonWithType:UIButtonTypeCustom];
    [button setBtnImages:@[[UIImage imageNamed:@"setting_icon_hide1"], [UIImage imageNamed:@"setting_icon_hide2"]]];
    self.textField.rightView = button;
    self.textField.rightViewMode = UITextFieldViewModeAlways;
    
    DeclareWeakSelf;
    button.actionHandler = ^(id sender, id value, UIControlEvents events){
        [sender setBtnState:(0 == [sender btnState]) ? 1 : 0];
        weakSelf.textField.secureTextEntry = (0 == [sender btnState]);
    };
}

- (void)setupWithItem:(id<LJXSettingDataSourceSectonItem>)item
{
    [super setupWithItem:item];
    [self setupTextfieldRightView];
    self.textField.secureTextEntry = YES;
}

- (void)awakeFromNib
{
    [self setupTextField];
    self.textField.secureTextEntry = YES;
    [self setupTextfieldRightView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
