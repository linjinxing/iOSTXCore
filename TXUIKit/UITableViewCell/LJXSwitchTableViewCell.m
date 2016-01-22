//
//  LJXSwitchTableViewCell.m
//  LJXTableView
//
//  Created by LoveYouForever on 9/22/14.
//  Copyright (c) 2014 i-Move. All rights reserved.
//

#import "LJXSwitchTableViewCell.h"
//#import "LJXSettingDataSourceSectonItem.h"

@interface LJXSwitchTableViewCell()
@property(strong, nonatomic) UISwitch* swi;
@end

@implementation LJXSwitchTableViewCell

//- (void)setupWithItem:(id<LJXSettingDataSourceSectonItem>)item
//{
//    [super setupWithItem:item];
//    UISwitch* s = [[UISwitch alloc] init];
//    self.accessoryView = s;
//    s.on = [[item defaultValue] boolValue];
//    [s addTarget:self action:@selector(switchValueDidChange:) forControlEvents:UIControlEventValueChanged];
//    self.swi = s;
//}
//
//
//- (void)switchValueDidChange:(UISwitch*)sender
//{
//    if (self.actionHandler) {
//        self.actionHandler(self, @(self.swi.on), UIControlEventValueChanged);
//    }
//}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//}

@end
