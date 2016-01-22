//
//  LJXButtonTableViewCell.m
//  LJXTableView
//
//  Created by LoveYouForever on 9/22/14.
//  Copyright (c) 2014 i-Move. All rights reserved.
//

#import "LJXButtonTableViewCell.h"
#import "LJXSettingDataSourceSectonItem.h"

@interface LJXButtonTableViewCell()
@property(strong, nonatomic) UIButton* button;
@end

@implementation LJXButtonTableViewCell

- (void)setupWithItem:(id<LJXSettingDataSourceSectonItem>)item
{
    [super setupWithItem:item];
    [self.button removeFromSuperview];
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setTitle:[item textTitle] forState:UIControlStateNormal];
    [self.contentView addSubview:btn];
    [btn addTarget:self action:@selector(buttonDidTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    self.textLabel.text = self.detailTextLabel.text = nil;
    
    self.button = btn;
}

- (void)buttonDidTouchUpInside:(UIButton*)sender
{
    if (self.actionHandler) {
        self.actionHandler(self, nil, UIControlEventTouchUpInside);
    }
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
    self.button.layer.borderColor = [UIColor blueColor].CGColor;
    self.button.layer.borderWidth = 1.0;
    CGRect frame = self.contentView.frame;
    self.button.frame = CGRectInset(frame, LJXTableViewControlSpace * 2, .0f) ;
}

@end
