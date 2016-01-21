//
//  LJXListButton.m
//  iMove
//
//  Created by linjinxing on 8/5/14.
//  Copyright (c) 2014 iMove. All rights reserved.
//

#import "LJXButton.h"
#import "LJXListButton.h"
#import "UIButtonAdditions.h"
#import "UIControl+LJXBlocks.h"
#import "NSArray+UI.h"
#import "NSArray+BlocksKit.h"
#import "UIView+Subviews.h"
#import "UIView+Layout.h"
//#import "LJXFoundationMacros.h"


@interface LJXListButton()
@property(nonatomic, strong)UIButton* btnSelectedItem;
@property(nonatomic, copy)NSArray* titles;
@property(nonatomic, copy)NSArray* buttons;
@end

@implementation LJXListButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (instancetype)initWithTitles:(NSArray*)titles
{
    self = [super init];
    if (self) {
        self.titles = [titles copy];
        
        NSMutableArray* buttons = [NSMutableArray arrayWithCapacity:[titles count]];
        for (int i =0; i < [titles count]; ++i) {
            UIButton* btn = [LJXButton buttonWithTitle:[titles objectAtIndex:i] tag:i];
            if (btn) {
                [buttons addObject:btn];
            }
        }
        
        self.buttons = buttons;
        DeclareWeakSelf;
        [buttons addEventHandler:^(UIButton *sender) {
            [weakSelf setSelectedIndex:[sender tag]];
        } forControlEvents:UIControlEventTouchUpInside];
        [self addSubviewsFromArray:buttons];
        
        self.btnSelectedItem = [LJXButton buttonWithTitle:[titles firstObject]];
        [self.btnSelectedItem setTitleColor:[UIColor colorWithWhite:0.7 alpha:1] forState:UIControlStateNormal];
        [self.btnSelectedItem addEventHandler:^(id sender) {
            weakSelf.isCollapse = !weakSelf.isCollapse;
        } forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnSelectedItem];
        
        self.spaceBetweenSelectedItemAndListView = 2;
        
        weakSelf.isCollapse = YES;
        
        self.clipsToBounds = YES;
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGFloat maxWidth = [self.subviews maxWidthOfViews];
    CGFloat totalHeight = .0f;
    if (self.isCollapse) {
        totalHeight = self.btnSelectedItem.height;
    }else{
        totalHeight = self.spaceBetweenSelectedItemAndListView + [self.subviews totalHeightOfViews];
    }
    if (size.width < maxWidth) {
        size.width = maxWidth;
    }
    if (size.height < totalHeight) {
        size.height = totalHeight;
    }
    return size;
}

- (void)setSelectedIndex:(NSInteger)aSelectedIndex
{
    UIButton* btn = self.buttons[_selectedIndex];
    btn.selected = NO;
    
    _selectedIndex = aSelectedIndex;
    btn = self.buttons[_selectedIndex];
    btn.selected = YES;
    [self.btnSelectedItem setTitle:btn.currentTitle forState:UIControlStateNormal];
    
    self.isCollapse = YES;
}

- (void)setIsCollapse:(BOOL)aIsCollapse
{
    _isCollapse = aIsCollapse;
    self.size = [self sizeThatFits:CGSizeMake(self.width, self.btnSelectedItem.height)];
}

- (void)layoutSubviews
{
    __block CGRect frame = self.btnSelectedItem.frame;
    frame.origin.y = self.btnSelectedItem.height + self.spaceBetweenSelectedItemAndListView;
	[self.buttons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[obj setFrame:frame];
		frame.origin.y += [obj frame].size.height;
	}];
}

- (void)setTitleFont:(UIFont *)font
{
	[self.buttons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [[obj titleLabel] setFont:font];
    }];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
	[self.buttons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj setTitle:title forState:state];
    }];
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state
{
	[self.buttons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj setTitleColor:color forState:state];
    }];
}

- (void)setButtonBackgroundColor:(UIColor *)color
{
    [self.btnSelectedItem setBackgroundColor:color];
	[self.buttons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj setBackgroundColor:color];
    }];
}


- (void)setButtonContentEdgeInsets:(UIEdgeInsets)edge
{
    [self.btnSelectedItem setContentEdgeInsets:edge];
    [self.btnSelectedItem sizeToFit];
	[self.buttons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj setContentEdgeInsets:edge];
        [obj sizeToFit];
    }];
}

- (void)setButtonTitleEdgeInsets:(UIEdgeInsets)edge
{
    [self.btnSelectedItem setTitleEdgeInsets:edge];
    [self.btnSelectedItem sizeToFit];
	[self.buttons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj setTitleEdgeInsets:edge];
        [obj sizeToFit];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
