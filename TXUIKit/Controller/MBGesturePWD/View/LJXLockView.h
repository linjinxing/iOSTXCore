//
//  LJXLockView.h
//  LockSample
//
//  Created by Lugede on 14/11/11.
//  Copyright (c) 2014年 lugede.cn. All rights reserved.
//
//  田字形手势解锁控件

#import <UIKit/UIKit.h>

@protocol LJXLockDelegate <NSObject>

@required
- (void)lockString:(NSString*)string;

@end

@interface LJXLockView : UIView

@property (nonatomic, weak) id<LJXLockDelegate> delegate;

- (void)showErrorCircles:(NSString*)string; // 设置错误的密码以高亮
- (void)clearColorAndSelectedButton; // 重置

@end
