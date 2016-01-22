//
//  LJXTableViewCell.h
//  LJXTableView
//
//  Created by LoveYouForever on 9/22/14.
//  Copyright (c) 2014 i-Move. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "LJXSettingProtocol.h"

//@class LJXSettingDataSourceSectonItem;

@interface LJXTableViewCell : UITableViewCell
@property(assign, nonatomic) BOOL allowDeleted;
@property(strong, nonatomic, readonly) UIButton* deleteButton;
- (void)resetDeleteButtonState;
//- (void)setupWithItem:(id<LJXSettingDataSourceSectonItem>)item;
@end

