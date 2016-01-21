//
//  LJXTextfieldTableViewCell.m
//  LJXTableView
//
//  Created by LoveYouForever on 9/22/14.
//  Copyright (c) 2014 i-Move. All rights reserved.
//

#import "LJXTextfieldTableViewCell.h"
#import "LJXSettingDataSourceSectonItem.h"
#import "LJXTableViewConst.h"
#import "LJXFoundation.h"
#import "LJXUI.h"

@interface LJXTextfieldTableViewCell()
@property(strong, nonatomic)UITextField* textField;
@end

@implementation LJXTextfieldTableViewCell

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithStyle:LJXTableViewCellStyleTextfield reuseIdentifier:reuseIdentifier item:nil];
}

- (void)setupTextField
{
    [self.textField removeFromSuperview];
    self.textField = [[UITextField alloc] init];
    [self.contentView addSubview:self.textField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textOfTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self.textField];
}

- (void)setupWithItem:(id<LJXSettingDataSourceSectonItem>)item
{
    [super setupWithItem:item];
    [self.textField removeFromSuperview];
    self.textField = [[UITextField alloc] init];
    self.textField.placeholder = [item detailTitle];
    [self.contentView addSubview:self.textField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textOfTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self.textField];
    if ([[item defaultValue] length]) {
        self.textField.text = [item defaultValue];
    }
}

- (void)textOfTextFieldDidChange:(NSNotification*)noti
{
    if (self.actionHandler)
        self.actionHandler(self, self.textField.text, UIControlEventValueChanged);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.contentView.bounds;
    if ([self.textLabel.text length]) {
        CGSize size = [self.textLabel.text sizeWithAttributes:@{NSFontAttributeName:self.textLabel.font}];
        CGRect textFrame = self.textLabel.frame;
        textFrame.size.width = size.width + LJXTableViewControlSpace * 2;
        self.textLabel.frame = textFrame;
        
        frame.origin.x = self.textLabel.frame.size.width + LJXTableViewControlSpace * 2;
        frame.size.width -= (self.textLabel.frame.size.width + LJXTableViewControlSpace * 4);
    }
    self.textField.frame = frame;
}


@end
