//
//  LJXListButton.h
//  iMove
//
//  Created by linjinxing on 8/5/14.
//  Copyright (c) 2014 iMove. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJXListButton : UIControl
@property(nonatomic, assign)BOOL isCollapse;  /* 是否折叠起来 */
@property(nonatomic, assign)CGFloat spaceBetweenSelectedItemAndListView; /* 选中的标题和下面选值视图的空隙 */
@property(nonatomic, assign)NSInteger selectedIndex;
- (instancetype)initWithTitles:(NSArray*)titles;

- (void)setTitleFont:(UIFont *)font;
- (void)setTitle:(NSString *)title forState:(UIControlState)state;
- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state;
- (void)setButtonBackgroundColor:(UIColor *)color;
- (void)setButtonTitleEdgeInsets:(UIEdgeInsets)edge;
- (void)setButtonContentEdgeInsets:(UIEdgeInsets)edge;
@end



